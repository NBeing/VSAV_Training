for _,var in ipairs({playbackfile, use_last_recording,
					path,playkey,recordkey,togglepausekey,toggleloopkey,longwait,longpress,longline,framemame, 
					 display_recording_gui,
					 use_hb_config, hb_config_blank_screen, hb_config_draw_axis, hb_config_draw_pushboxes, hb_config_draw_throwable_boxes, hb_config_no_alpha,
					 mo_enable_frame_data, debug, quiet_framedata, show_controls_message}) do
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
local inpHistoryModule  = require"./scripts/inputHistory"
-- local inpDispModule     = require "./input-display"
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
serialize  	    = require './scripts/ser'
local util              = require './scripts/utilities'
local playerObject      = require './scripts/playerObject'
local menuModule        = require './scripts/menu'
local controllerModule  = require './scripts/controller'
local cps2HitboxModule  = require "./scripts/cps2-hitboxes"
local healthAndMeter    = require "./scripts/healthAndMeter"
local hudModule         = require "./scripts/hud"
local timersModule      = require "./scripts/timers"


local frameskipHandlerModule = require "./scripts/frameskipHandler"

if show_controls_message == true then
	print("* Press Start open the training menu..")
	print("* Press Coin to swap controls to dummy")
	print("* Press Volume Down to play back recording. (found in 'map game inputs')")
	print("* Press Volume Up to record dummy. (found in 'map game inputs')")
	print("* Press Alt + 3 to toggle looping playback.")
	print("* Press Alt + 4 to return to character select.")
end

local p1_addr = 0xFF8400
local p2_addr = 0xFF8800

globals = {
	game_state      = nil,
	dummy_state     = nil,
	config_state    = nil,
	show_menu       = false,
	controlling_p1  = true,
	show_p2         = true,
	quiet_framedata = quiet_framedata,
	show_position = show_position,
	show_meter = show_meter,
	show_life = show_life,
	timers = {},
	dmg_calc = {
		red_life = training_settings.max_life,
		white_life = training_settings.max_life
	},
	skip_frame = false,
	macroLua = nil,
	last_fd = "",
	set_last_data = function (fd) 
		globals.last_fd = fd
	end,
	gc_event = "p1_gc_none",
	pb_event = "p1_pb_none",
	controllerModule = nil,
	util = nil,
	menuModule = nil,
}

input.registerhotkey(5, function()
	print("Debug", emu.framecount())
	-- print("=======p1======")
	-- globals.util.printRamAddresses(0xFF8400, 0xFF8400 + 0x400)
	print("=======p2======")
	globals.util.printRamAddresses(0xFF8800, 0xFF8800 + 0x400)
end)


input.registerhotkey(4, function()
	-- Return to char select
	memory.writebyte(0xFF8005, 0x0C)
	last_fd = ""
end)
input.registerhotkey(3, function()
	globals.macroLua.toggleloop()
end)
toggleloop = nil

emu.registerstart(function()
	util.load_training_data()
	globals["options"] = configModule.registerBefore()
	globals.show_menu = false
	globals.controllerModule = controllerModule.registerStart()
	globals.util = util.registerStart()
	globals.inpHistoryModule = inpHistoryModule.registerStart() 
	globals.inpHistoryModule.reset_inp_history_scroll()
	globals.menuModule = menuModule.registerStart()
	player_objects = {
		playerObject.make_player_object(1, 0x02068C6C, "P1"),
		playerObject.make_player_object(2, 0x02069104, "P2")
	  }
	frameDataModule.registerStart(mo_enable_frame_data, quiet_framedata)
	cps2HitboxModule.registerStart()
	macroLuaModule.registerStart()

end)

emu.registerbefore(function()
	function to_hex(num)
		local charset = {"0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"}
		local tmp = {}
		repeat
			table.insert(tmp,1,charset[num%16+1])
			num = math.floor(num/16)
		until num==0
		return table.concat(tmp)
	end
	function lookForValue(start_addr, end_addr, player)
		for i = start_addr, end_addr, 1 do 
			val = memory.readbyte(i)
			-- if val == 12 then print("found 12", to_hex(i), val) end
			if val == 11 then print(player.."==== found 11", to_hex(i), val) end
		end
	end
	-- print("block_stun_timer", block_stun_timer)
	-- print("hit pause", memory.readword(0xFF8800 + 0x164))
	-- print("569", memory.readbyte(0xff8569))
	-- print("958", memory.readbyte(0xff8958))
	-- print("9ab", memory.readbyte(0xff89ab))
	-- print("9ab", memory.readbyte(0xff89FC))
	-- lookForValue(0xFF8400, 0xFF8400 + 0x400, "P1")
	-- lookForValue(0xFF8800, 0xFF8800 + 0x400, "P2")

	inpHistoryModule.registerBefore()
	match_begun = gameStateModule.registerBefore().match_begun
	if match_begun == false then
		return
	end

	if globals.controlling_p1 == true then 
		p1 = playerObject.read_player_vars(player_objects[1])
		p2 = playerObject.read_player_vars(player_objects[2])
		gui.text( 2, 2, "Controlling: P1")
	else 
		gui.text( 2, 2, "Controlling: P2")
	end
	globals["options"] = configModule.registerBefore()
	globals["game"]    = gameStateModule.registerBefore() 
	globals["dummy"]   = dummyStateModule.registerBefore()
	globals["skip_frame"] = frameskipHandlerModule.registerBefore()
	globals["timers"] = timersModule.registerBefore()

	globals.util.disable_taunts()
	neutralModule.registerBefore()
	healthAndMeter.registerBefore()
	runDummyInput = runInputModule.registerBefore()
	cps2HitboxModule.registerBefore()
	autoguardModule.registerBefore()
	globals.macroLua  = macroLuaModule.registerBefore()
	rollingModule.roll()
	controllerModule.registerBefore()
	globals.controllerModule.handle_hotkeys()
	gc_keys = guardCancelModule.registerBefore(runDummyInput, globals.macroLua)
end)


emu.registerafter(function() --recording is done after the frame, not before, to catch input from playing macros
	match_begun = gameStateModule.registerBefore().match_begun
	if match_begun == false or globals == nil or globals.options == nil then
		return
	end
	vsavScriptModule.registerAfter()
	cps2HitboxModule.registerAfter()
	frameDataModule.registerAfter(globals.options.mo_enable_frame_data)
	macroLuaModule.registerAfter()

end)

if savestate.registersave and savestate.registerload then --registersave/registerload are unavailable in some emus

	savestate.registersave(function(slot)
		macroLuaModule.registerSave(slot)
	end)
	
	savestate.registerload(function(slot)

		globals.show_menu = false
		globals.controllerModule.enable_both_players()

		globals["options"] = configModule.registerBefore()
		globals["game"]    = gameStateModule.registerBefore() 
		globals["dummy"]   = dummyStateModule.registerBefore()

		configModule.registerBefore()
		frameDataModule.registerLoad()
		vsavScriptModule.registerLoad(slot)
		cps2HitboxModule.registerLoad()
		macroLuaModule.registerLoad(slot)
		input_history[1] = {}
		input_history[2] = {}
	end)
	
end

emu.registerexit(function() --Attempt to save if the script exits while recording
	if recording then recording = false finalize(recinputstream) end
end)


----------------------------------------------------------------------------------------------------
--[[ Handle pausing in the while true loop. ]]--
while true do
	gui.register(function()
		if globals == nil or globals.options == nil then
			return
		end
		match_begun = gameStateModule.registerBefore().match_begun
		if match_begun == false then
			return
		end

		hudModule.guiRegister()
		vsavScriptModule.guiRegister(display_hud, display_movelist)
		cps2HitboxModule.guiRegister(globals.options.display_hitbox_default, use_hb_config)
		vsavScriptModule.runCheats()
		inpHistoryModule.guiRegister()
		menuModule.guiRegister()
		
	end)

	macroLuaModule.gameLoop()

	amountOfGarbage = collectgarbage("count")
	if amountOfGarbage > 10000 then
		collectgarbage("collect")
	end
end