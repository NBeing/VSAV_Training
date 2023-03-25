local frameskip_pattern_read_addr    = 0x8E5A
local frameskip_next_frame_read_addr = 0x8E62

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

local function is_nth_bit_set(value, n)
  local bits = int_to_bits(value)
  return bits[n + 1] == 1
end

local frameskip_pattern_observable
local next_frame_will_be_skipped_observable
local frameskipServiceModule = {
  ["registerStart"] = function()
    frameskip_pattern_observable = Rx.Observable.create(function(observer)
      memory.registerexec(frameskip_pattern_read_addr, function()
        observer:onNext(table.concat(int_to_bits(memory.getregister("m68000.d0"))))
      end)
    end)
    next_frame_will_be_skipped_observable = Rx.Observable.create(function(observer)
      memory.registerexec(frameskip_next_frame_read_addr, function()
        local d0 = memory.getregister("m68000.d0")
        local d1 = memory.getregister("m68000.d1")
        observer:onNext(is_nth_bit_set(d0, d1))
      end)
    end)
  end,
  -- Emits the frameskip pattern whenever it is accessed in the game code
  -- @returns {Observable}
  ["get_frameskip_pattern"] = function()
    return frameskip_pattern_observable
  end,
  -- Emits `true` if the next frame will be skipped; `false` otherwise
  -- @returns {Observable}
  ["get_next_frame_skipped"] = function()
    return next_frame_will_be_skipped_observable
  end
}
return frameskipServiceModule