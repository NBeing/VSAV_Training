for _,var in ipairs({playbackfile, use_last_recording,
					path,playkey,recordkey,togglepausekey,toggleloopkey,longwait,longpress,longline,framemame, 
					 display_hud, display_movelist, 
					 use_hb_config, hb_config_blank_screen, hb_config_draw_axis, hb_config_draw_pushboxes, hb_config_draw_throwable_boxes, hb_config_no_alpha,
					 mo_enable_frame_data, debug}) do
	var = nil
end

function script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*[/\\])")
end
scripts_path = script_path()

dofile(script_path().."macro-options.lua", "r") --load the globals
dofile(script_path().."macro-modules.lua", "r")
-- local socket = require "socket"
-- print(socket._VERSION)
local inpDispModule     = require "./input-display"
local frameDataModule   = require "./scripts/framedata"
local rollingModule     = require "./scripts/rolling" 
local vsavScriptModule  = require "./scripts/vsavscriptv2"
local cps2HitboxModule  = require "./scripts/cps2-hitboxes"
local macroLuaModule    = require "./scripts/macro"
local guardCancelModule = require "./scripts/guardCancel"
local autoguardModule   = require "./scripts/autoguard"
local cheatConfigModule = require './scripts/cheatConfig'
local gameStateModule   = require './scripts/gameState'
local dummyStateModule  = require './scripts/dummyState'
local runInputModule    = require './scripts/runDummyInput'
local neutralModule     = require './scripts/dummyNeutral' 
local serialize  	    = require './scripts/ser'
local util              = require './scripts/utilities'
local menuModule        = require './scripts/menu'

print("* Press Lua hotkey 1 for playback.")
print("* Press Lua hotkey 2 for recording.")
print("* Press Lua hotkey 3 to toggle pause after playback.")
print("* Press Lua hotkey 4 to toggle loop mode or adjust wait incrementation.")
print("* Press Lua hotkey 5 to show or hide hitboxes.")

local p1_addr = 0xFF8400
local p2_addr = 0xFF8800

globals = {
	game_state   = nil,
	dummy_state  = nil,
	config_state = nil,
	show_menu    = false
}

function togglehitbox()
	display_hitbox_default =  not display_hitbox_default
end

function togglemenu()
	globals.show_menu =  not globals.show_menu
end

input.registerhotkey(5, function()
	togglehitbox()
end)

input.registerhotkey(3, function()
	-- menu
	togglemenu()
end)
print(gui)
emu.registerstart(function()

	frameDataModule.registerStart(mo_enable_frame_data)
	cps2HitboxModule.registerStart()
	macroLuaModule.registerStart()

end)

emu.registerbefore(function()

	globals["options"] = cheatConfigModule.registerBefore()
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
	macroLuaModule.registerBefore(swapControls)
	rollingModule.roll()



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

		globals["options"] = cheatConfigModule.registerBefore()
		globals["game"]    = gameStateModule.registerBefore() 
		globals["dummy"]   = dummyStateModule.registerBefore()

		cheatConfigModule.registerBefore()
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
		cps2HitboxModule.guiRegister(display_hitbox_default, use_hb_config)
		vsavScriptModule.runCheats()
		-- inpDispModule.guiRegister(true)
		menuModule.guiRegister()
		-- print("show menu", show_menu)
		
	end)
	macroLuaModule.gameLoop()

	amountOfGarbage = collectgarbage("count")
	if amountOfGarbage > 10000 then
		collectgarbage("collect")
	end
end