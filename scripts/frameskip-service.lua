local global_settings_register_a5    = "m68000.a5"
local register_d1                    = "m68000.d1"
local global_settings_base_addr      = 0xFF8000
local logical_frame_counter_offset   = 0x81
local animation_frame_counter_offset = 0xB4
local frameskip_flag_offset          = 0x118
local last_frame_skipped_offset      = 0x134
local frameskip_pattern_read_addr    = 0x8E5A
local frameskip_next_frame_read_addr = 0x8E6A
local mod_32_bitmask                 = 0x1F

local function reverse_table_and_pad(tbl)
  for i = 1, math.floor(#tbl / 2) do
    local tmp = tbl[i]
    tbl[i] = tbl[#tbl - i + 1]
    tbl[#tbl - i + 1] = tmp
  end
  while #tbl < 32 do
    table.insert(tbl, 1, 0)
  end
end

local function int_to_bits(int)
  local tbl = {}
  while int > 0 do
    local rest = math.fmod(int, 2)
    tbl[#tbl + 1] = rest
    int = (int - rest) / 2
  end
  reverse_table_and_pad(tbl)
  return tbl
end

-- this implementaiton sucks lmao but whatever
local function bitwise_and(int_a, int_b)
  local a_bits = int_to_bits(int_a)
  local b_bits = int_to_bits(int_b)
  local anded_bits = {}
  for i = 1, #a_bits do
    local truth = a_bits[i] == 1 and b_bits[i] == 1
    local result = 0
    if truth then result = 1 end
    table.insert(anded_bits, result)
  end
  return tonumber(table.concat(anded_bits), 2)
end

local function left_shift(int, num_shifts)
  local int_bits = int_to_bits(int)
  for i = 1, num_shifts do
    table.insert(int_bits, #int_bits, table.remove(int_bits, 1))
  end
  return tonumber(table.concat(int_bits), 2)
end

local function is_nth_bit_set(value, n)
  local bits = int_to_bits(value)
  return bits[n + 1] == 1
end

local frameskip_pattern_observable
local current_frame_frameskip_data_observable
local frameskipServiceModule = {
  ["registerStart"] = function()
    frameskip_pattern_observable = Rx.Observable.create(function(observer)
      memory.registerexec(frameskip_pattern_read_addr, function()
        observer:onNext(table.concat(int_to_bits(memory.getregister("m68000.d0"))))
      end)
    end)
    current_frame_frameskip_data_observable = Rx.Observable.create(function(observer)
      memory.registerexec(frameskip_next_frame_read_addr, function()
        local frameskip_index = memory.getregister(register_d1)
        local global_settings_addr = memory.getregister(global_settings_register_a5)
        local calculated_frameskip_index = bitwise_and(memory.readbyte(global_settings_base_addr + logical_frame_counter_offset), mod_32_bitmask)
        local frameskip_value = memory.readbyte(global_settings_addr + frameskip_flag_offset)
        local last_frame_skipped_value = memory.readbyte(global_settings_addr + last_frame_skipped_offset)
        local animation_frame_counter = memory.readbyte(global_settings_base_addr + animation_frame_counter_offset)
        observer:onNext({
          frameskip_index = frameskip_index, -- seemingly 0 on skipped frames...
          calculated_frameskip_index = calculated_frameskip_index, -- ...so we calculate it too
          next_frame_will_be_skipped = frameskip_value == 0xFF,
          last_frame_was_skipped = last_frame_skipped_value == 0xFF,
          animation_frame_counter = animation_frame_counter
        })
      end)
    end)
  end,
  -- Emits the frameskip pattern whenever it is accessed in the game code
  -- @returns {Observable}
  ["get_frameskip_pattern"] = function()
    return frameskip_pattern_observable
  end,
  -- Emits an object containing data about the current logical frame
  -- 
  -- `frameskip_index` is the value at `A5+0x81` at the time of frameskip
  -- function return; this is `0` on skipped frames
  -- 
  -- `calculated_frameskip_index` is a reconstruction of what the frameskip
  -- index should be, for use on skipped frames
  -- 
  -- `next_frame_will_be_skipped` `true` if the next animation frame will be
  -- skipped
  -- 
  -- `last_frame_was_skipped` `true` if the last animation frame was skipped
  -- 
  -- `animation_frame_counter` the animation frame counter at `0xFF80B4`
  -- @returns {Observable}
  ["get_current_frame_frameskip_data"] = function()
    return current_frame_frameskip_data_observable
  end
}
return frameskipServiceModule