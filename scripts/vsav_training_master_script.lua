-- Utils
serialize  	    				= require './scripts/ser'
local util              		= require './scripts/utilities'
-- MacroLua Deps
dofile("macro-options.lua", "r") --load the globals
dofile("macro-modules.lua", "r")

-- Training Mode Menu
local configModule      		= require './scripts/config'
training_settings_file  		= "training_settings.json"
training_settings       		= configModule.default_training_settings

-- Our Thangs
local inpHistoryModule  		= require"./scripts/inputHistory"
local frameDataModule   		= require "./scripts/framedata"
local rollingModule     		= require "./scripts/rolling" 
local vsavScriptModule  		= require "./scripts/vsavscriptv2"
local macroLuaModule    		= require "./scripts/macro"
local guardCancelModule 		= require "./scripts/guardCancel"
local autoguardModule   		= require "./scripts/autoguard"
local gameStateModule   		= require './scripts/gameState'
local dummyStateModule  		= require './scripts/dummyState'
local neutralModule     		= require './scripts/dummyNeutral' 
local playerObject      		= require './scripts/playerObject'
local menuModule        		= require './scripts/menu'
local controllerModule  		= require './scripts/controller'
local cps2HitboxModule  		= require "./scripts/cps2-hitboxes"
local healthAndMeter    		= require "./scripts/healthAndMeter"
local hudModule         		= require "./scripts/hud"
local timersModule      		= require "./scripts/timers"
local throwTechModule   		= require "./scripts/throwTech"
local aestheticModule   		= require "./scripts/aesthetic"
local frameskipHandlerModule    = require "./scripts/frameskipHandler"

if show_controls_message == true then
	print("* Press Start open the training menu..")
	print("* Press Coin to swap controls to dummy")
	print("* Press Volume Down to play back recording. (found in 'map game inputs')")
	print("* Press Volume Up to record dummy. (found in 'map game inputs')")
	print("* Press Alt + 3 to toggle looping playback.")
	print("* Press Alt + 4 to return to character select.")
end


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
		p2_red_life = training_settings.p2_max_life,
		p2_white_life = training_settings.p2_max_life,
		p1_red_life = training_settings.p1_max_life,
		p1_white_life = training_settings.p1_max_life,
	},
	skip_frame = false,
	save_state = nil,
	debounceStarted = nil,
	macroLua = nil,
	last_fd = "",
	airdash_heights = {},
	time_between_dashes = {},
	dash_length_frames = {},
	short_hop_counter = {},
	time_between_dash_start_attack_start = {},
	time_between_attack_end_dash_start = {},
	frames_between_attacks = {},
	last_dash_ended = nil,
	last_dash_started = nil,
	last_attack_started = nil,
	last_attack_ended = nil,
	p2_hit_or_block_begin = nil,
	p2_hit_or_block_end = nil,
	meaty_trainer = {
		last_meaty_succeeded = true,
		last_p2_wakeup = nil,
		last_p1_hurtbox = nil,
	},
	pushboxes = {},
	hurtboxes = {},
	set_last_data = function (fd)
		globals.last_fd = fd
	end,
	gc_event = "p1_gc_none",
	pb_event = "p1_pb_none",
	controllerModule = nil,
	dummyStateModule = nil,
	util = nil,
	menuModule = nil,
	frameskipReady = false,
	input_history = {P1 ={}, P2 = {}},
	_input = {},
	parsed_dummy_state = {},
	playing = false,
	recording = false,
}


toggleloop = nil
emu.registerstart(function()
	util.load_training_data()
	globals.frameSkipHandlerModule = frameskipHandlerModule.registerStart()
	globals["options"] = configModule.registerBefore()
	globals.show_menu = false
	globals.controllerModule = controllerModule.registerStart()
	globals.util = util.registerStart()
	globals.inpHistoryModule = inpHistoryModule.registerStart() 
	globals.inpHistoryModule.reset_inp_history_scroll()
	globals.menuModule = menuModule.registerStart()
	globals.getCharacter = utilitiesModule.get_character
	globals.get_bishamon_ubk_ranges_by_char = charMovesModule.get_bishamon_ubk_ranges_by_char()

	player_objects = {
		playerObject.make_player_object(1, 0xFF8400, "P1"),
		playerObject.make_player_object(2, 0xFF8800, "P2")
	}
	P1 = player_objects[1]
	P2 = player_objects[2]
	
	frameDataModule.registerStart(globals.options.mo_enable_frame_data, quiet_framedata)
	cps2HitboxModule.registerStart(globals)
	macroLuaModule.registerStart()

end)

local last 
emu.registerbefore(function()
	aestheticModule.registerBefore()
	globals["game"]    		 = gameStateModule.registerBefore() 

	if globals.game_state.match_begun == false then
		return
	end
	
	charMovesModule.registerBefore()
	
	globals["options"] 		 = configModule.registerBefore()
	globals["pushboxes"]     = cps2HitboxModule.getPushboxes()
	globals["hurtboxes"]	 = cps2HitboxModule.getHurtboxes()
	globals["char_moves"]    = charMovesModule.registerBefore()
	globals["dummy"]   		 = dummyStateModule.registerBefore().get_dummy_state()
	globals["skip_frame"] 	 = frameskipHandlerModule.registerBefore()
	globals["timers"] 		 = timersModule.registerBefore()
	globals["current_frame"] = emu.framecount()
	
	globals.util.disable_taunts() -- For our start menu to work w/o taunting
	healthAndMeter.registerBefore()
	cps2HitboxModule.registerBefore()
	rollingModule.roll()

	globals.controllerModule.handle_hotkeys()

	globals._input = controllerModule.registerBefore()
	globals.macroLua  = macroLuaModule.registerBefore()
	globals.macroLua.setloop()


	playerObject.read_player_vars(player_objects[1], player_objects[2])
	-- playerObject.read_player_vars(player_objects[2])
	
	if globals.macroLua.playing == true then
		local macroLua_keys = globals.macroLua.get_keytable()
		for k,v in pairs(macroLua_keys) do globals._input[k] = v end
	else
		local dummy_neutral_keys = neutralModule.registerBefore(globals._input)
		autoguardModule.registerBefore(dummy_neutral_keys, player_objects)
		local gc_keys = guardCancelModule.registerBefore()
		throwTechModule.registerBefore(globals._input)
	end

	globals.controllerModule.process_pending_input_sequence(player_objects[1], globals._input)
	globals.controllerModule.process_pending_input_sequence(player_objects[2], globals._input)

	joypad.set(globals._input)

	inpHistoryModule.registerBefore(globals._input)

end)


emu.registerafter(function() --recording is done after the frame, not before, to catch input from playing macros
	if globals.game_state.match_begun == false or globals == nil or globals.options == nil then
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
		globals.debounceStarted = nil
		globals.controllerModule.enable_both_players()
		globals["options"] = configModule.registerBefore()
		globals["game"]    = gameStateModule.registerBefore() 
		globals["dummy"]   = dummyStateModule.registerBefore().get_dummy_state()

		configModule.registerBefore()
		frameDataModule.registerLoad()
		vsavScriptModule.registerLoad(slot)
		cps2HitboxModule.registerLoad()
		macroLuaModule.registerLoad(slot)
		globals.dmg_calc.red_life = 0
		globals.dmg_calc.white_life = 0
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
			gui.clearuncommitted()
			return
		end
		if globals.game_state and globals.game_state.match_begun == false then
			gui.clearuncommitted()
			hudModule.guiRegisterCSS()
			return
		end
		hudModule.guiRegister()
		vsavScriptModule.guiRegister(display_hud, display_movelist)
		cps2HitboxModule.guiRegister(globals.options.display_hitbox_default, use_hb_config)
		vsavScriptModule.runCheats()
		timersModule.guiRegister()
		menuModule.guiRegister()
		if globals.options.show_scrolling_input == true then
			inpHistoryModule.guiRegister(globals._input)
		end
	end)

	macroLuaModule.gameLoop()

	amountOfGarbage = collectgarbage("count")
	if amountOfGarbage > 15000 then
		collectgarbage("collect")
	end
end
