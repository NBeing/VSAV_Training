function swap_inputs(_out_input_table)
  function swap(_input)
    local carry = _out_input_table["P1 ".._input]
    _out_input_table["P1 ".._input] = _out_input_table["P2 ".._input]
    _out_input_table["P2 ".._input] = carry
  end

  swap("Up")
  swap("Down")
  swap("Left")
  swap("Right")
  swap("Weak Punch")
  swap("Medium Punch")
  swap("Strong Punch")
  swap("Weak Kick")
  swap("Medium Kick")
  swap("Strong Kick")
end
function togglecontrolling()

	globals.controlling_p1 = not globals.controlling_p1

	local controlling = "P1"

	if globals.controlling_p1 ~= true then controlling = "P2" end

end

stick_gesture = {
  "none",
  "forward",
  "back",
  "down",
  "up",
  "QCF",
  "QCB",
  "HCF",
  "HCB",
  "DPF",
  "DPB",
  "HCharge",
  "VCharge",
  "360",
  "DQCF",
  "720",
  "back dash",
  "forward dash",
  "Shun Goku Ratsu", -- Gouki hidden SA1
  "Kongou Kokuretsu Zan", -- Gouki hidden SA2
}

button_gesture =
{
  "none",
  "recording",
  "LP",
  "MP",
  "HP",
  "EXP",
  "LK",
  "MK",
  "HK",
  "EXK",
  "LP+LK",
  "MP+MK",
  "HP+HK",
}
function queue_input_sequence(_player_obj, _sequence)
  if _sequence == nil or #_sequence == 0 then
    return
  end

  if _player_obj.pending_input_sequence ~= nil then
    return
  end

  local _seq = {}
  _seq.sequence = copytable(_sequence)
  _seq.current_frame = 1

  _player_obj.pending_input_sequence = _seq
end

function stick_input_to_sequence_input(_player_obj, _input)
  if _input == "Up" then return "up" end
  if _input == "Down" then return "down" end
  if _input == "Weak Punch" then return "LP" end
  if _input == "Medium Punch" then return "MP" end
  if _input == "Strong Punch" then return "HP" end
  if _input == "Weak Kick" then return "LK" end
  if _input == "Medium Kick" then return "MK" end
  if _input == "Strong Kick" then return "HK" end

  if _input == "Left" then
    if _player_obj.flip_input then
      return "back"
    else
      return "forward"
    end
  end

  if _input == "Right" then
    if _player_obj.flip_input then
      return "forward"
    else
      return "back"
    end
  end
  return ""
end

function make_input_sequence(_stick, _button, _delay_type, _delay_num)

  if _button == "recording" then
    return nil
  end

  local _sequence = {}
  if      _stick == "none"    then _sequence = { { } }
  elseif  _stick == "forward" then _sequence = { { "forward" } }
  elseif  _stick == "back"    then _sequence = { { "back" } }
  elseif  _stick == "down"    then _sequence = { { "down" } }
  elseif  _stick == "up"      then _sequence = { { "up" } }
  elseif  _stick == "up-forward"    then _sequence = { {"up", "forward" } }
  elseif  _stick == "up-back"       then _sequence = { {"up","back" } }
  elseif  _stick == "down-forward"  then _sequence = {{"down", "forward" } }
  elseif  _stick == "down-back"     then _sequence = { {"down", "back" } }
  elseif  _stick == "QCF"     then _sequence = { { "down" }, {"down", "forward"}, {"forward"} }
  elseif  _stick == "QCB"     then _sequence = { { "down" }, {"down", "back"}, {"back"} }
  elseif  _stick == "HCF"     then _sequence = { { "back" }, {"down", "back"}, {"down"}, {"down", "forward"}, {"forward"} }
  elseif  _stick == "HCB"     then _sequence = { { "forward" }, {"down", "forward"}, {"down"}, {"down", "back"}, {"back"} }
  elseif  _stick == "DPF"     then _sequence = { { "forward" }, {"down"}, {"down", "forward"} }
  elseif  _stick == "DPB"     then _sequence = { { "back" }, {"down"}, {"down", "back"} }
  elseif  _stick == "HCharge" then _sequence = { { "back", "h_charge" }, {"forward"} }
  elseif  _stick == "VCharge" then _sequence = { { "down", "v_charge" }, {"up"} }
  elseif  _stick == "360"     then _sequence = { { "forward" }, { "forward", "down" }, {"down"}, { "back", "down" }, { "back" }, { "up" } }
  elseif  _stick == "DQCF"    then _sequence = { { "down" }, {"down", "forward"}, {"forward"}, { "down" }, {"down", "forward"}, {"forward"} }
  elseif  _stick == "720"     then _sequence = { { "forward" }, { "forward", "down" }, {"down"}, { "back", "down" }, { "back" }, { "up" }, { "forward" }, { "forward", "down" }, {"down"}, { "back", "down" }, { "back" } }
  -- full moves special cases
  elseif  _stick == "back dash" then _sequence = { { "back" }, {}, { "back" } }
  elseif  _stick == "forward dash" then _sequence = { { "forward" }, {}, { "forward" } }
  elseif  _stick == "back dash cancel" then _sequence = { { "back" }, {}, { "back" } }
  elseif  _stick == "forward dash cancel" then _sequence = { { "forward" }, {}, { "forward" } }
  elseif  _stick == "Shun Goku Ratsu" then _sequence = { { "LP" }, {}, {}, { "LP" }, { "forward" }, {"LK"}, {}, { "HP" } }
  elseif  _stick == "Kongou Kokuretsu Zan" then _sequence = { { "down" }, {}, { "down" }, {}, { "down", "LP", "MP", "HP" } }
  elseif _stick == "PB-light" then _sequence = { {"LP"}, {}, {"LP"}, {}, {"LP"}, {}, {"LP"}, {}, {"LP"},{},{"LP"} } 
  elseif _stick == "PB-medium" then  _sequence = { {"MP"}, {}, {"MP"}, {}, {"MP"}, {}, {"MP"}, {}, {"MP"},{},{"MP"} }
  elseif _stick == "PB-heavy" then  _sequence = { {"HP"}, {}, {"HP"}, {}, {"HP"}, {}, {"HP"}, {}, {"HP"}, {} ,{"HP"} }
  elseif _stick == "PB-ascending" then _sequence = { {"LP"}, {"LK"}, {"MP"}, {"MK"}, {"HP"},{"HK"} }
  elseif _stick == "PB-descending" then _sequence = { {"HP"}, {"HP"},{"MP"},{"MK"}, {"LP"},{"LK"} }
  end

  if _delay_type == "delay_before" then
    for i=0, _delay_num do
      table.insert(_sequence,1, {})
    end
  end

  if 
    _stick == "forward dash cancel" or  
    _stick == "back dash cancel" or
    _stick == "up-forward" or
    _stick == "up-back"
  then
    for i=0, _delay_num do
      table.insert(_sequence, {})
    end
  end

  if _stick == "forward dash cancel" then 
    table.insert(_sequence, { "back" } ) 
    table.insert(_sequence, {} ) 

  end
  if _stick == "back dash cancel" then 
    table.insert(_sequence, { "forward" })
    table.insert(_sequence, {})
  
  end

  if     _button == "none" then
  elseif _button == "MP+HP"  then
    table.insert(_sequence[#_sequence], "MP")
    table.insert(_sequence[#_sequence], "HP")
  elseif _button == "MK+HK"  then
    table.insert(_sequence[#_sequence], "MK")
    table.insert(_sequence[#_sequence], "HK")
  elseif _button == "LP+LK" then
    table.insert(_sequence[#_sequence], "LP")
    table.insert(_sequence[#_sequence], "LK")
  elseif _button == "MP+MK" then
    table.insert(_sequence[#_sequence], "MP")
    table.insert(_sequence[#_sequence], "MK")
  elseif _button == "HP+HK" then
    table.insert(_sequence[#_sequence], "HP")
    table.insert(_sequence[#_sequence], "HK")
  else
    table.insert(_sequence[#_sequence], _button)
  end

  return _sequence
end
function process_pending_input_sequence(_player_obj, _input, delay)
  if _player_obj.pending_input_sequence == nil then
    return
  end
  -- Cancel all input
  _input[_player_obj.prefix.." Up"] = false
  _input[_player_obj.prefix.." Down"] = false
  _input[_player_obj.prefix.." Left"] = false
  _input[_player_obj.prefix.." Right"] = false
  _input[_player_obj.prefix.." Weak Punch"] = false
  _input[_player_obj.prefix.." Medium Punch"] = false
  _input[_player_obj.prefix.." Strong Punch"] = false
  _input[_player_obj.prefix.." Weak Kick"] = false
  _input[_player_obj.prefix.." Medium Kick"] = false
  _input[_player_obj.prefix.." Strong Kick"] = false

  local _s = ""
  local _current_frame_input = _player_obj.pending_input_sequence.sequence[_player_obj.pending_input_sequence.current_frame]
  for i = 1, #_current_frame_input do
    local _input_name = _player_obj.prefix.." "
    if _current_frame_input[i] == "forward" then
      if _player_obj.flip_input then _input_name = _input_name.."Right" else _input_name = _input_name.."Left" end
    elseif _current_frame_input[i] == "back" then
      if _player_obj.flip_input then _input_name = _input_name.."Left" else _input_name = _input_name.."Right" end
    elseif _current_frame_input[i] == "up" then
      _input_name = _input_name.."Up"
    elseif _current_frame_input[i] == "down" then
      _input_name = _input_name.."Down"
    elseif _current_frame_input[i] == "LP" then
      _input_name = _input_name.."Weak Punch"
    elseif _current_frame_input[i] == "MP" then
      _input_name = _input_name.."Medium Punch"
    elseif _current_frame_input[i] == "HP" then
      _input_name = _input_name.."Strong Punch"
    elseif _current_frame_input[i] == "LK" then
      _input_name = _input_name.."Weak Kick"
    elseif _current_frame_input[i] == "MK" then
      _input_name = _input_name.."Medium Kick"
    elseif _current_frame_input[i] == "HK" then
      _input_name = _input_name.."Strong Kick"
    end
    _input[_input_name] = true
    _s = _s.._input_name
  end

  _player_obj.pending_input_sequence.current_frame = _player_obj.pending_input_sequence.current_frame + 1
  if _player_obj.pending_input_sequence.current_frame > #_player_obj.pending_input_sequence.sequence then
    _player_obj.pending_input_sequence = nil
  end
end
-- Hotkeys Begin
input.registerhotkey(5, function()
	print("Debug", emu.framecount())
	-- print("=======p1======")
	-- globals.util.printRamAddresses(0xFF8400, 0xFF8400 + 0x400)
	print("=======RESETTING======")
	-- globals.util.printRamAddresses(0xFF8800, 0xFF8800 + 0x400)
end)

local function reset_ui_trainers()
	globals.show_menu = false
	globals.airdash_heights = {}
	globals.time_between_dashes = {}
	globals.dash_length_frames = {}
	globals.short_hop_counter = {}
	globals.time_between_dash_start_attack_start = {}
	globals.time_between_attack_end_dash_start = {}
	globals.frames_between_attacks = {}
	last_fd = ""
end 
input.registerhotkey(4, function()
	-- Return to char select
	memory.writebyte(0xFF8005, 0x0C)
    reset_ui_trainers()
end)
input.registerhotkey(3, function()
	globals.macroLua.toggleloop()
end)

local function debounce(func, debounceTime)
  if globals.debounceStarted == nil then 
    globals.debounceStarted = globals.current_frame
    func()
    return
  end
  if globals.debounceStarted + debounceTime <=  globals.current_frame then
    globals.debounceStarted = globals.current_frame
    func()
    return
  end
end

local last_inputs = nil
local function handle_hotkeys()
  local _inputs = joypad.getup()
  local down = player_objects[1].input.down
  if last_inputs ~= nil then
    -- if  down["start"] == true and down["LP"] == true then 
    if down["start"] == true then 
			debounce(globals.menuModule.togglemenu,20)
    end
    -- if  down["start"] == true and down["MP"] == true then 
		-- 	debounce(globals.menuModule.togglegraphmenu,10)
    -- end
    -- if  down["start"] == true and down["LK"] == true then 
		-- 	debounce(globals.menuModule.dec_graph,5)
    -- end
    -- if  down["start"] == true and down["MK"] == true then 
		-- 	debounce(globals.menuModule.inc_graph,5)
		-- end

		if  _inputs["P1 Coin"] == nil and last_inputs["P1 Coin"] == false then 
			globals.controllerModule.togglecontrolling()
		end
		if  (_inputs["Volume Down"] == nil and last_inputs["Volume Down"] == false ) then 

      if globals.macroLua.playing then
        globals.macroLua.playcontrol()
      else
        if globals.options.use_recording_savestate == true then
          savestate.load("current_recording")
        end
        globals.macroLua.playcontrol()
      end
    
		end
		if  _inputs["Volume Up"] == nil and last_inputs["Volume Up"] == false then 
      if globals.macroLua.recording then
        globals.macroLua.reccontrol()
      else
        if globals.options.use_recording_savestate == true then
          globals.save_state = savestate.create("current_recording")
          savestate.save(globals.save_state)
          globals.show_menu = false
        end
        globals.macroLua.reccontrol()

      end
		end
  end
  last_inputs = _inputs
  return _inputs
end
function disable_player( player_num )
	local player_addr = 0
	if player_num == 1 then
		player_addr = 0xFF8400
	else
		player_addr = 0xFF8800
	end 

	memory.writebyte(player_addr + 0x200, 0x01)
	memory.writebyte(player_addr + 0x3B4, 0x01)
end
function enable_player( player_num )
	local player_addr = 0
	if player_num == 1 then
		player_addr = 0xFF8400
	else
		player_addr = 0xFF8800
	end 
	memory.writebyte(player_addr + 0x200, 0x00)
	memory.writebyte(player_addr + 0x3B4, 0x00)
end
function disable_both_players()
	disable_player(1)
	disable_player(2)
end
function enable_both_players( )
	enable_player(1)
	enable_player(2)
end


-- Hotkeys End
controllerModule = {
  ["registerStart"] = function() 
    enable_both_players()
    return {
      togglecontrolling = togglecontrolling,
      disable_both_players = disable_both_players,
      enable_both_players = enable_both_players,
      handle_hotkeys = handle_hotkeys,
      stick_gesture = stick_gesture,
      button_gesture = button_gesture,
      make_input_sequence = make_input_sequence, 
      process_pending_input_sequence = process_pending_input_sequence,
      queue_input_sequence = queue_input_sequence,
    }
  end,
  ["registerBefore"] = function()
    _input = joypad.get()
    if globals.controlling_p1 == true then
      return _input
    end
    swap_inputs(_input)
    -- joypad.set(_input)
    return _input
end
}
return controllerModule