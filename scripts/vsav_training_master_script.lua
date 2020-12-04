for _,var in ipairs({playbackfile, use_last_recording,
					path,playkey,recordkey,togglepausekey,toggleloopkey,longwait,longpress,longline,framemame, 
					 display_hud, display_movelist, 
					 use_hb_config, hb_config_blank_screen, hb_config_draw_axis, hb_config_draw_pushboxes, hb_config_draw_throwable_boxes, hb_config_no_alpha,
					 mo_enable_frame_data, debug, mo_show_facing, quiet_framedata}) do
	var = nil
end

function script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*[/\\])")
end
dofile("macro-options.lua", "r") --load the globals
dofile("macro-modules.lua", "r")

local configModule      = require './scripts/config'
training_settings_file  = "training_settings.json"
training_settings       = configModule.default_training_settings

local inpDispModule     = require "./input-display"
local frameDataModule   = require "./scripts/framedata"
local rollingModule     = require "./scripts/rolling" 
local vsavScriptModule  = require "./scripts/vsavscriptv2"
local macroLuaModule    = require "./scripts/macro"
local guardCancelModule = require "./scripts/guardCancel"
local autoguardModule   = require "./scripts/autoguard"
local gameStateModule   = require './scripts/gameState'
local dummyStateModule  = require './scripts/dummyState'
local runInputModule    = require './scripts/runDummyInput'
local neutralModule     = require './scripts/dummyNeutral' 
local serialize  	    = require './scripts/ser'
local util              = require './scripts/utilities'
local playerObject      = require './scripts/playerObject'
local menuModule        = require './scripts/menu'
local controllerModule  = require './scripts/controller'
local cps2HitboxModule  = require "./scripts/cps2-hitboxes"

print("* Press Lua hotkey 1 open the training menu..")
print("* Press Lua hotkey 2 to swap controls to dummy")
print("* Press Lua hotkey 3 to play back recording")
print("* Press Lua hotkey 4 to record dummy.")
print("* Press Lua hotkey 5 to toggle looping playback.")


local p1_addr = 0xFF8400
local p2_addr = 0xFF8800

globals = {
	game_state      = nil,
	dummy_state     = nil,
	config_state    = nil,
	show_menu       = false,
	controlling_p1  = true,
	quiet_framedata = quiet_framedata
}

emu.message = function(text)
	mid_width = emu.screenwidth() / 2 - 25
	mid_height = emu.screenheight() - 8
	gui.text( mid_width, mid_height, text)
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
function disable_both_players( )
	disable_player(1)
	disable_player(2)
end
function enable_both_players( )
	enable_player(1)
	enable_player(2)
end

-- enable_both_players()
function togglemenu()
	globals.show_menu =  not globals.show_menu
	if globals.show_menu then
		disable_both_players()
	else 
		enable_both_players()
	end
end

-- input.registerhotkey(1, function()
-- 	togglemenu()
-- end)
input.registerhotkey(2, function()
	toggleloop()
end)

last_inputs = nil
toggleloop = nil

emu.registerstart(function()
	globals.show_menu = false
	enable_both_players()
	util.load_training_data()
	player_objects = {
		playerObject.make_player_object(1, 0x02068C6C, "P1"),
		playerObject.make_player_object(2, 0x02069104, "P2")
	  }
	frameDataModule.registerStart(mo_enable_frame_data, quiet_framedata)
	cps2HitboxModule.registerStart()
	macroLuaModule.registerStart()

end)

emu.registerbefore(function()

	-- Set remaining taunts to 0 for better start button behavior
	memory.writebyte(0xFF8400 + 0x179, 0)
	memory.writebyte(0xFF8800 + 0x179, 0)
	
	_inputs = joypad.getup()

	if globals.controlling_p1 == true then 
		p1 = playerObject.read_player_vars(player_objects[1])
		p2 = playerObject.read_player_vars(player_objects[2])
		emu.message("Controlling: P1")
	else 
		emu.message("Controlling: P2")
	end
	globals["options"] = configModule.registerBefore()
	globals["game"]    = gameStateModule.registerBefore() 
	globals["dummy"]   = dummyStateModule.registerBefore()
	options = globals["options"]
	dummy   = globals["dummy"]
	game    = globals["game"]
	
	neutralModule.registerBefore()
	
	runDummyInput = runInputModule.registerBefore()
	
	cps2HitboxModule.registerBefore()
	
	autoguardModule.registerBefore()
	
	gc_keys = guardCancelModule.registerBefore(runDummyInput)
	
	macroLua_funcs = macroLuaModule.registerBefore()
	rollingModule.roll()
	
	controllerModule.registerBefore()
	toggleloop = macroLua_funcs.toggleloop

	if last_inputs ~= nil then
		if  _inputs["P1 Start"] == nil and last_inputs["P1 Start"] == false then 
			togglemenu()
		end
		if  _inputs["P1 Coin"] == nil and last_inputs["P1 Coin"] == false then 
			togglecontrolling()
		end

		if  (_inputs["Volume Down"] == nil and last_inputs["Volume Down"] == false ) then 
			macroLua_funcs.playcontrol()
		end
		if  _inputs["Volume Up"] == nil and last_inputs["Volume Up"] == false then 
			macroLua_funcs.reccontrol()
		end
	end
	last_inputs = _inputs
end)

emu.registerafter(function() --recording is done after the frame, not before, to catch input from playing macros
	
	vsavScriptModule.registerAfter()
	cps2HitboxModule.registerAfter()
	frameDataModule.registerAfter(mo_enable_frame_data)
	macroLuaModule.registerAfter()

end)

if savestate.registersave and savestate.registerload then --registersave/registerload are unavailable in some emus

	savestate.registersave(function(slot)
		macroLuaModule.registerSave(slot)
	end)
	
	savestate.registerload(function(slot)

		globals.show_menu = false
		enable_both_players()

		globals["options"] = configModule.registerBefore()
		globals["game"]    = gameStateModule.registerBefore() 
		globals["dummy"]   = dummyStateModule.registerBefore()

		configModule.registerBefore()
		frameDataModule.registerLoad()
		vsavScriptModule.registerLoad(slot)
		cps2HitboxModule.registerLoad()
		macroLuaModule.registerLoad(slot)

	end)
	
end

emu.registerexit(function() --Attempt to save if the script exits while recording
	if recording then recording = false finalize(recinputstream) end
end)
----------------------------------------------------------------------------------------------------
--[[ Handle pausing in the while true loop. ]]--
while true do
	gui.register(function()

		vsavScriptModule.guiRegister(display_hud, display_movelist)
		cps2HitboxModule.guiRegister(training_settings.show_hitboxes, use_hb_config)
		vsavScriptModule.runCheats()
		-- inpDispModule.guiRegister(true)
		menuModule.guiRegister()
		
	end)

	macroLuaModule.gameLoop()

	amountOfGarbage = collectgarbage("count")
	if amountOfGarbage > 10000 then
		collectgarbage("collect")
	end
end