local p1_inp_disp_x = 125
local p1_inp_disp_y = 28
local p2_inp_disp_x = 225
local p2_inp_disp_y = 28
require "gd"
img_1_dir = gd.createFromPng("images/1_dir.png"):gdStr()
img_2_dir = gd.createFromPng("images/2_dir.png"):gdStr()
img_3_dir = gd.createFromPng("images/3_dir.png"):gdStr()
img_4_dir = gd.createFromPng("images/4_dir.png"):gdStr()
img_5_dir = gd.createFromPng("images/5_dir.png"):gdStr()
img_6_dir = gd.createFromPng("images/6_dir.png"):gdStr()
img_7_dir = gd.createFromPng("images/7_dir.png"):gdStr()
img_8_dir = gd.createFromPng("images/8_dir.png"):gdStr()
img_9_dir = gd.createFromPng("images/9_dir.png"):gdStr()
img_L_button = gd.createFromPng("images/L_button.png"):gdStr()
img_M_button = gd.createFromPng("images/M_button.png"):gdStr()
img_H_button = gd.createFromPng("images/H_button.png"):gdStr()
img_no_button = gd.createFromPng("images/no_button.png"):gdStr()
img_dir = {
img_1_dir,
img_2_dir,
img_3_dir,
img_4_dir,
img_5_dir,
img_6_dir,
img_7_dir,
img_8_dir,
img_9_dir
}
input_history_size_max = 30
input_history = {
    {},
    {}
}
-- HISTORY
history = {}
history_sections = {
    global = 1,
    P1 = 2,
    P2 = 3,
}
history_categories = {}
history_recording_on = false
history_category_count = 0
current_entry = 1
history_size_max = 80
history_line_count_max = 25
history_line_offset = 0
local frame_number = 0
-- History
function get_text_width(_text)
	if #_text == 0 then
	  return 0
	end
  
	return #_text * 4
  end
function string_hash(_str)
	if #_str == 0 then
		return 0
  end

  local _DJB2_INIT = 5381;
	local _hash = _DJB2_INIT
  for _i = 1, #_str do
    local _c = _str.byte(_i)
    _hash = bit.lshift(_hash, 5) + _hash + _c
  end
	return _hash
end
function string_to_color(_str)
	local _HRange = { 0.0, 360.0 }
	  local _SRange = { 0.8, 1.0 }
	  local _LRange = { 0.7, 1.0 }
  
	  local _HAmplitude = _HRange[2] - _HRange[1];
	  local _SAmplitude = _SRange[2] - _SRange[1];
	  local _LAmplitude = _LRange[2] - _LRange[1];
  
	local _hash = string_hash(_str)
  
	local _HI = bit.rshift(bit.band(_hash, 0xFF000000), 24)
	local _SI = bit.rshift(bit.band(_hash, 0x00FF0000), 16)
	  local _LI = bit.rshift(bit.band(_hash, 0x0000FF00), 8)
	  local _base = bit.lshift(1, 8)
  
	  local _H = _HRange[1] + (_HI / _base) * _HAmplitude;
	  local _S = _SRange[1] + (_SI / _base) * _SAmplitude;
	  local _L = _LRange[1] + (_LI / _base) * _LAmplitude;
  
	  local _HDiv60 = _H / 60.0
	  local _HDiv60_Floor = math.floor(_HDiv60);
	  local _HDiv60_Fraction = _HDiv60 - _HDiv60_Floor;
  
	  local _RGBValues = {
		  _L,
		  _L * (1.0 - _S),
		  _L * (1.0 - (_HDiv60_Fraction * _S)),
		  _L * (1.0 - ((1.0 - _HDiv60_Fraction) * _S))
	  }
  
	  local _RGBSwizzle = {
		  {1, 4, 2},
		  {3, 1, 2},
		  {2, 1, 4},
		  {2, 3, 1},
		  {4, 2, 1},
		  {1, 2, 3},
	  }
	  local _SwizzleIndex = (_HDiv60_Floor % 6) + 1
	local _R = _RGBValues[_RGBSwizzle[_SwizzleIndex][1]]
	local _G = _RGBValues[_RGBSwizzle[_SwizzleIndex][2]]
	local _B = _RGBValues[_RGBSwizzle[_SwizzleIndex][3]]
  
	--print(string.format("H:%.1f, S:%.1f, L:%.1f | R:%.1f, G:%.1f, B:%.1f", _H, _S, _L, _R, _G, _B))
  
	local _color = bit.lshift(math.floor(_R * 255), 24) + bit.lshift(math.floor(_G * 255), 16) + bit.lshift(math.floor(_B * 255), 8) + 0xFF
	return _color
  end
  
function history_add_entry(_section_name, _category_name, _event_name)
  if not history_enabled then return end
  if not history_recording_on then return end

  _event_name = _event_name or ""
  _category_name = _category_name or ""
  _section_name = _section_name or "global"
  if history_sections[_section_name] == nil then _section_name = "global" end

  if not history_categories_shown[_category_name] then return end

  -- Add category if it does not exists
  if history_categories[_category_name] == nil then
    history_categories[_category_name] = history_category_count
    history_category_count = history_category_count + 1
  end

  -- Insert frame if it does not exists
  if #history == 0 or history[#history].frame ~= frame_number then
    table.insert(history, {
      frame = frame_number,
      events = {}
    })
  end

  -- Remove overflowing history frame
  while #history > history_size_max do
    table.remove(history, 1)
  end

  local _current_frame = history[#history]
  table.insert(_current_frame.events, {
    name = _event_name,
    section = _section_name,
    category = _category_name,
    color = string_to_color(_event_name)
  })
end

history_filtered = {}
history_start_locked = false
function history_update()
  history_filtered = {}
  if not history_enabled then return end

  -- compute filtered history
  for _i = 1, #history do
    local _frame = history[_i]
    local _filtered_frame = { frame = _frame.frame, events = {}}
    for _j, _event in ipairs(_frame.events) do
      if history_categories_shown[_event.category] then
        table.insert(_filtered_frame.events, _event)
      end
    end

    if #_filtered_frame.events > 0 then
      table.insert(history_filtered, _filtered_frame)
    end
  end

--   -- process input
--   if player.input.down.start then
--     if player.input.pressed.HP then
--       history_start_locked = true
--       history_recording_on = not history_recording_on
--       if history_recording_on then
--         history_line_offset = 0
--       end
--     end
--     if player.input.pressed.HK then
--       history_start_locked = true
--       history_line_offset = 0
--       history = {}
--     end

--     if check_input_down_autofire(player, "up", 4) then
--       history_start_locked = true
--       history_line_offset = history_line_offset - 1
--       history_line_offset = math.max(history_line_offset, 0)
--     end
--     if check_input_down_autofire(player, "down", 4) then
--       history_start_locked = true
--       history_line_offset = history_line_offset + 1
--       history_line_offset = math.min(history_line_offset, math.max(#history_filtered - history_line_count_max - 1, 0))
--     end
--   end

--   if not player.input.down.start and not player.input.released.start then
--     history_start_locked = false
--   end
end
function history_draw()
  local _history = history_filtered
  if #_history == 0 then return end

  local _line_background = { 0x333333CC, 0x555555CC }
  local _separator_color = 0xAAAAAAFF
  local _width = emu.screenwidth() - 10
  local _height = emu.screenheight() - 10
  local _x_start = 5
  local _y_start = 5

  local _line_height = 8
  local _line_height = 2
  local _current_line = 0
  local _columns_start = { 0, 20, 200 }
  local _box_size = 6
  local _box_margin = 2
  gui.box(_x_start, _y_start , _x_start + _width, _y_start, 0x00000000, _separator_color)
  local _last_displayed_frame = 0
  for _i = 0, history_line_count_max do
    local _frame_index = #_history - (_i + history_line_offset)
    if _frame_index < 1 then
      break
    end
    local _frame = _history[_frame_index]
	local _events = {{}, {}, {}}

	for _j, _event in ipairs(_frame.events) do
	  if history_categories_shown[_event.category] then
        table.insert(_events[history_sections[_event.section]], _event)
      end
    end

    local _y = _y_start + _current_line * _line_height
    gui.box(_x_start, _y, _x_start + _width, _y + _line_height, _line_background[(_i % 2) + 1], 0x00000000)
    for _section_i = 1, 3 do
      local _box_x = _x_start + _columns_start[_section_i]
      local _box_y = _y + 1
      for _j, _event in ipairs(_events[_section_i]) do
        gui.box(_box_x, _box_y, _box_x + _box_size, _box_y + _box_size, _event.color, 0x00000000)
        gui.box(_box_x + 1, _box_y + 1, _box_x + _box_size - 1, _box_y + _box_size - 1, 0x00000000, 0x00000022)
        gui.text(_box_x + _box_size + _box_margin, _box_y, _event.name, text_default_color, 0x00000000)
        _box_x = _box_x + _box_size + _box_margin + get_text_width(_event.name) + _box_margin
      end
    end

    if _frame_index > 1 then
      local _frame_diff = _frame.frame - _history[_frame_index - 1].frame
      gui.text(_x_start + 2, _y + 1, string.format("%d", _frame_diff), text_default_color, 0x00000000)
    end
    gui.box(_x_start, _y + _line_height, _x_start + _width, _y + _line_height, 0x00000000, _separator_color)
    _current_line = _current_line + 1
    _last_displayed_frame = _frame_index
  end
end

function make_input_history_entry(_prefix, _input)
  local _up = _input[_prefix.." Up"]
  local _down = _input[_prefix.." Down"]
  local _left = _input[_prefix.." Left"]
  local _right = _input[_prefix.." Right"]
  local _direction = 5
  if _down then
    if _left then _direction = 1
    elseif _right then _direction = 3
    else _direction = 2 end
  elseif _up then
    if _left then _direction = 7
    elseif _right then _direction = 9
    else _direction = 8 end
  else
    if _left then _direction = 4
    elseif _right then _direction = 6
    else _direction = 5 end
  end


  return {
    frame = frame_number,
    direction = _direction,
    buttons = {
      _input[_prefix.." Weak Punch"],
      _input[_prefix.." Medium Punch"],
      _input[_prefix.." Strong Punch"],
      _input[_prefix.." Weak Kick"],
      _input[_prefix.." Medium Kick"],
      _input[_prefix.." Strong Kick"]
	},
    gc_event = globals.gc_event,
    pb_event = globals.pb_event,
  }
end

function is_input_history_entry_equal(_a, _b)
  if (_a.direction ~= _b.direction) then return false end
  if (_a.buttons[1] ~= _b.buttons[1]) then return false end
  if (_a.buttons[2] ~= _b.buttons[2]) then return false end
  if (_a.buttons[3] ~= _b.buttons[3]) then return false end
  if (_a.buttons[4] ~= _b.buttons[4]) then return false end
  if (_a.buttons[5] ~= _b.buttons[5]) then return false end
  if (_a.buttons[6] ~= _b.buttons[6]) then return false end
  if globals.options and globals.options.show_gc_trainer == true then 
    if (_a.gc_event ~= _b.gc_event) then return false end
    if (_a.pb_event ~= _b.pb_event) then return false end
  end
  return true
end

function update_input_history(_history, _prefix, _input)
  local _entry = make_input_history_entry(_prefix, _input)

  if #_history == 0 then
    table.insert(_history, _entry)
  else
    local _last_entry = _history[#_history]
    if _last_entry.frame ~= frame_number and not is_input_history_entry_equal(_entry, _last_entry) then
      table.insert(_history, _entry)
    end
  end

  while #_history > input_history_size_max do
    table.remove(_history, 1)
  end
end

function draw_input_history_entry(_entry, _x, _y, color, step)
	local no_buttons =  _entry.buttons[1] == false and
						_entry.buttons[2] == false and
						_entry.buttons[3] == false and
						_entry.buttons[4] == false and
						_entry.buttons[5] == false and
						_entry.buttons[6] == false 

	if globals.options.show_gc_trainer == true then 
		if _entry.gc_event == "p1_gc_begin" then
			gui.text(_x + 1 , _y - 9, "GC", "#00FF00")
			gui.box(_x + 10, _y - 9, _x + step - 1, _y - 4, "#99EE9977", "#99EE9977")
		elseif _entry.gc_event == "p1_gc_in_progress" then
			gui.box(_x , _y - 9, _x + step - 2, _y - 4, "#99EE9977","#99EE9977")
		elseif _entry.gc_event == "p1_gc_ended" then
			gui.text(_x + 1 , _y - 9, "GC", "#FF0000")
        end
        if _entry.pb_event == "p1_pb_begin" then
			gui.text(_x + 1 , _y - 9, "PB", "#00FF00")
			gui.box(_x + 10 , _y - 9, _x + step - 1, _y - 4, "#99EE9977", "#99EE9977")
		elseif _entry.pb_event == "p1_pb_in_progress" then
			gui.box(_x , _y - 9, _x + step - 2, _y - 4, "#99EE9977","#99EE9977")
		elseif _entry.pb_event == "p1_pb_ended" then
			gui.text(_x + 1 , _y - 9, "PB", "#FF0000")
		end
	end
	if no_buttons and _entry.direction == 5 then
		-- gui.box(_x -1 , _y - 1, _x + 30, _y + 20, color)
		gui.text(_x + 1 , _y + 2, "IDLE", "#99EE99")
		return;
	elseif no_buttons and _entry.direction ~= 5 then
		gui.image(_x + 2 , _y, img_dir[_entry.direction])
		return;	
	end
  gui.box(_x -1 , _y - 1, _x + 30, _y + 20, color)


  gui.image(_x, _y, img_dir[_entry.direction])

  local _img_LP = img_no_button
  local _img_MP = img_no_button
  local _img_HP = img_no_button
  local _img_LK = img_no_button
  local _img_MK = img_no_button
  local _img_HK = img_no_button
  if _entry.buttons[1] then _img_LP = img_L_button end
  if _entry.buttons[2] then _img_MP = img_M_button end
  if _entry.buttons[3] then _img_HP = img_H_button end
  if _entry.buttons[4] then _img_LK = img_L_button end
  if _entry.buttons[5] then _img_MK = img_M_button end
  if _entry.buttons[6] then _img_HK = img_H_button end

  gui.image(_x + 13, _y, _img_LP)
  gui.image(_x + 18, _y, _img_MP)
  gui.image(_x + 23, _y, _img_HP)
  gui.image(_x + 13, _y + 5, _img_LK)
  gui.image(_x + 18, _y + 5, _img_MK)
  gui.image(_x + 23, _y + 5, _img_HK)
end

function draw_input_history(_history, _x, _y, _is_left)
  local _step_y = 18

  local _step_x_idle = 22
  local _step_x_both = 38
  local _step_x_dirs_only = 18
  local _step_x_buttons_only = 38
  local _step_x_event = 38

  local num_idle = 0 
  local num_buttons_only = 0
  local num_dirs_only = 0
  local num_both = 0
  local num_event = 0

  local _j = 0
  
  local color = "black"
  local scroll_offset = 0
  if globals.options.inp_history_scroll > #_history then
	scroll_offset = #_history
  else
	scroll_offset = globals.options.inp_history_scroll
  end
  for _i = #_history - scroll_offset, 1, -1 do
	local _entry = _history[_i]
	-- print(_entry.event)
	local state = nil
	local no_buttons = _entry.buttons[1] == false and
		_entry.buttons[2] == false and
		_entry.buttons[3] == false and
		_entry.buttons[4] == false and
		_entry.buttons[5] == false and
		_entry.buttons[6] == false 

	local step = 0
	if no_buttons == false and _entry.direction ~= 5 then
		state = "both"
		step = _step_x_both
		num_both = num_both + 1
  	elseif no_buttons and _entry.direction ~= 5 then 
		state = "directions_only"
		step = _step_x_dirs_only
		num_dirs_only = num_dirs_only + 1
	elseif no_buttons and _entry.direction == 5 then
		state = "idle"
		step = _step_x_idle 
		num_idle = num_idle + 1
	elseif no_buttons == false and _entry.direction == 5 then
		state = "buttons_only"
		step = _step_x_buttons_only
		num_buttons_only = num_buttons_only + 1
	end


	local _current_y = _y + _j * _step_y
	local _current_x = 
		_x 
		- (num_both  * _step_x_both) 
		- (num_idle * _step_x_idle)
		- (num_dirs_only * _step_x_dirs_only)
		- (num_buttons_only * _step_x_buttons_only)
		- (num_event * _step_x_event)

	
    local _entry_offset = 0
    if _is_left then _entry_offset = 13 end
    draw_input_history_entry(_entry, _current_x + _entry_offset, _y, color, step)

    local _next_frame = frame_number
    if _i < #_history then
      _next_frame = _history[_i + 1].frame
    end
    local _frame_diff = _next_frame - _entry.frame
    local _text = "-"
    if (_frame_diff < 999) then
      _text = string.format("%d", _frame_diff)
    end

    local _offset = 0
    if _is_left then
      _offset = 8
      if (_frame_diff < 999) then
        if (_frame_diff >= 100) then _offset = 0
        elseif (_frame_diff >= 10) then _offset = 4 end
      end
    else
      _offset = 33
    end
    _j = _j + 1
	local held_length_x = 18
	if state == "idle" then
		held_length_x = 16
	elseif state == "event" then 
		held_length_x = 18
	elseif state == "directions_only" then
		held_length_x = 14
	elseif state == "buttons_only" then
		held_length_x = 10
	elseif state == "both" then
		held_length_x = 18
	end
	-- gui.text(_x + _offset, _current_y + 2, _text, 0xd6e3efff, 0x101000ff)
	gui.text(_current_x + held_length_x + _offset, _y + 11, _text, "#62b8d5", 0x101000ff)
  end
end

-- !History

-- !History
function reset_inp_history_scroll()
    globals.options.inp_history_scroll = 0
end
local function handle_gc_event()
    local block_stun_timer_addr = 0xFF8558 
    local block_stun_timer = memory.readbyte(block_stun_timer_addr)
    local p1_gc_timer = memory.readbyte(0xFF8558)

    if p1_gc_timer == 0 and globals.gc_event == "p1_gc_in_progress" then
      globals.gc_event = "p1_gc_ended"
      history_add_entry("P1", "GC", globals.gc_event)
    elseif globals.gc_event == "p1_gc_none" and p1_gc_timer > 0 then
      globals.gc_event = "p1_gc_begin"
      history_add_entry("P1", "GC", globals.gc_event)
    elseif p1_gc_timer > 0 then
        globals.gc_event = "p1_gc_in_progress"
        history_add_entry("P1", "GC", globals.gc_event)
    elseif globals.gc_event == "p1_gc_ended" then 
      globals.gc_event = "p1_gc_none"
      history_add_entry("P1", "GC", globals.gc_event)
    end
end
local function handle_pb_event()

    local p1_pushblock_counter = memory.readbyte(0xFF8400 + 0x170)
    local p1_tech_hit_timer = memory.readbyte(0xFF8400 + 0x1AB) 

    if p1_tech_hit_timer == 0 and globals.pb_event == "p1_pb_in_progress" then
        globals.pb_event = "p1_pb_ended"
    elseif globals.pb_event == "p1_pb_none" and p1_tech_hit_timer > 0 then
        globals.pb_event = "p1_pb_begin"
    elseif p1_tech_hit_timer > 0 then
        globals.pb_event = "p1_pb_in_progress"
    elseif globals.pb_event == "p1_pb_ended" then 
        globals.pb_event = "p1_pb_none"
    end
end
local inpHistoryModule = {
    ["registerStart"] = function()
        return {
            reset_inp_history_scroll = reset_inp_history_scroll
        }
    end,
    ["registerBefore"] = function()
        frame_number = emu.framecount()
        local _input = joypad.get()
        handle_gc_event()
        handle_pb_event()
        if globals.show_menu ~= true then
            update_input_history(input_history[1], "P1", _input)
            -- update_input_history(input_history[2], "P2", _input)
            history_update()				
            return
        end
    end,
    ["guiRegister"] = function()
        local _i = joypad.get()
		
		local _p1 = make_input_history_entry("P1", _i)
		local _p2 = make_input_history_entry("P2", _i)
		-- gui.rect(p1_inp_disp_x,p1_inp_disp_y ,p1_inp_disp_x + 35 ,p1_inp_disp_y + 10,"#000000")
		-- gui.rect(p2_inp_disp_x,p1_inp_disp_y ,p2_inp_disp_x + 35 ,p1_inp_disp_y + 10,"#000000")

		-- draw_input_history_entry(_p1, p1_inp_disp_x, p1_inp_disp_y)
		-- draw_input_history_entry(_p2, p2_inp_disp_x, p2_inp_disp_y)

		local input_underlay_x = 0
		local input_underlay_y = emu.screenheight() - 21
		gui.box(input_underlay_x, input_underlay_y, emu.screenwidth(), input_underlay_y + 25 ,"#00000099", "#00000055")
		draw_input_history(input_history[1], emu.screenwidth() - 15 + globals.options.inp_history_scroll, input_underlay_y + 2, true) 
    end
}
return inpHistoryModule