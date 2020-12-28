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

local last_inputs = nil
function handle_hotkeys()
  local _inputs = joypad.getup()
  if last_inputs ~= nil then
		if  _inputs["P1 Start"] == nil and last_inputs["P1 Start"] == false then 
			globals.menuModule.togglemenu()
		end
		if  _inputs["P1 Coin"] == nil and last_inputs["P1 Coin"] == false then 
			globals.controllerModule.togglecontrolling()
		end

		if  (_inputs["Volume Down"] == nil and last_inputs["Volume Down"] == false ) then 
			globals.macroLua.playcontrol()
		end
		if  _inputs["Volume Up"] == nil and last_inputs["Volume Up"] == false then 
			globals.macroLua.reccontrol()
		end
  end
  last_inputs = _inputs
  return _inputs
end
controllerModule = {
  ["registerStart"] = function() 
    enable_both_players()
    return {
      togglecontrolling = togglecontrolling,
      disable_both_players = disable_both_players,
      enable_both_players = enable_both_players,
      handle_hotkeys = handle_hotkeys,
    }
  end,
  ["registerBefore"] = function()
    if globals.controlling_p1 == true then
      return
    end
    _input = joypad.get()
    swap_inputs(_input)
    joypad.set(_input)
end
}
return controllerModule