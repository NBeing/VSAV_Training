for _,var in ipairs({playbackfile, use_last_recording,
					path,playkey,recordkey,togglepausekey,toggleloopkey,longwait,longpress,longline,framemame, show_position,
					 display_recording_gui,
					 use_hb_config, hb_config_blank_screen, hb_config_draw_axis, hb_config_draw_pushboxes, hb_config_draw_throwable_boxes, hb_config_no_alpha,
					 mo_enable_frame_data, debug, quiet_framedata, show_controls_message}) do
	var = nil
end

function script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*[/\\])")
end
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
copytable = deepcopy
dofile("macro-options.lua", "r") --load the globals
dofile("macro-modules.lua", "r")

serialize  	    = require './scripts/ser'
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
local neutralModule     = require './scripts/dummyNeutral' 
local util              = require './scripts/utilities'
local playerObject      = require './scripts/playerObject'
local menuModule        = require './scripts/menu'
local controllerModule  = require './scripts/controller'
local cps2HitboxModule  = require "./scripts/cps2-hitboxes"
local healthAndMeter    = require "./scripts/healthAndMeter"
local hudModule         = require "./scripts/hud"
local timersModule      = require "./scripts/timers"
local throwTechModule   = require "./scripts/throwTech"

-- local frameskipHandlerModule = require "./scripts/frameskipHandler"

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
last_dummy_config = {  }
last_dummy_dict = {}
local graph_data = nil
function update_graph_data()
	local keyset={}
	local n=0
	for k,v in pairs(last_dummy_config) do
		n=n+1
		if tonumber(k) ~= nil then
			keyset[tonumber(k)]=v
		end
	end

	local sorted = {}
	for k, v in pairs(keyset) do
		table.insert(sorted,{frame = k, state = v})
	end

	table.sort(sorted, function(a,b) 
		return a["frame"] < b["frame"] 
	end)
	local min_items = 7
	local chopped = {}
	local chop_index = - min_items
	for key, val in pairs(sorted) do
		if 
			(chop_index > globals.graph_data_index and chop_index < globals.graph_data_index + 7) 
		then 
			table.insert(chopped,{frame = val.frame, state = val.state})
		end

		chop_index = chop_index + 1

	  end
	  
	graph_data = chopped
end

local init_clock = 0
local fc = 0
local prev_frames = {}

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
	total_pb_attempt_counter = {},
	successful_pb_counter = {},
	time_between_dash_start_attack_start = {},
	time_between_attack_end_dash_start = {},
	frames_between_attacks = {},
	last_dash_ended = nil,
	last_dash_started = nil,
	last_attack_started = nil,
	last_attack_ended = nil,
	p2_hit_or_block_begin = nil,
	p2_hit_or_block_end = nil,
	set_last_data = function (fd) 
		globals.last_fd = fd
	end,
	pushboxes = {},
	gc_event = "p1_gc_none",
	pb_event = "p1_pb_none",
	controllerModule = nil,
	dummyStateModule = nil,
	util = nil,
	menuModule = nil,
	frameskipReady = false,
	graph_data_index = 0,
	graph_data_max = 8,
	show_graph_menu = false,
	update_graph_data = update_graph_data,
	input_history = {P1 ={}, P2 = {}},
	_input = {},
	parsed_dummy_state = {},
	graph_data_max = 100,
	playing = false,
	recording = false,
}

local gather_graph_data = false
local was_gathering_graph_data = false

input.registerhotkey(5, function()
	print("Debug", emu.framecount())
	-- print("=======p1======")
	-- globals.util.printRamAddresses(0xFF8400, 0xFF8400 + 0x400)
	print("=======RESETTING======")
	-- globals.util.printRamAddresses(0xFF8800, 0xFF8800 + 0x400)
end)

input.registerhotkey(4, function()
	-- Return to char select
	globals.show_menu = false
	memory.writebyte(0xFF8005, 0x0C)
	globals.airdash_heights = {}
	globals.time_between_dashes = {}
	globals.dash_length_frames = {}
	globals.short_hop_counter = {}
	globals.time_between_dash_start_attack_start = {}
	globals.time_between_attack_end_dash_start = {}
	globals.frames_between_attacks = {}
	last_fd = ""
end)
input.registerhotkey(3, function()
	globals.macroLua.toggleloop()
end)
toggleloop = nil
emu.registerstart(function()
	util.load_training_data()
	-- globals.frameSkipHandlerModule = frameskipHandlerModule.registerStart()
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
	-- print("currently selected", memory.readbyte(0xFF8400 + 0x382))
	-- print("unknown mirror",memory.readbyte(0xFF6198))
	-- print("have selected character", memory.readbyte(0xFF8400 + 0x3BD))
	-- memory.writebyte(0xFF8400 + 0x3BD, 0x02)

	-- print("P1 guard", memory.readbyte(0xFF8400 + 0x1AB))
	-- if memory.readbyte(0xFF8400 + 0x1AB) > 0 then
	-- 	print("P1 blockin")
	-- 	memory.writebyte(0xFF8400 + 0x170, 0x06)
	-- end
	-- fc = fc + 1
    -- if fc % 60 == 0 then 
    --     local cur_clock = os.clock()
    --     print("ending at", cur_clock)
    --     print("It takes this amount of time to run 60 frame", cur_clock - init_clock )
    --     table.insert(prev_frames, 1, {cur_clock - init_clock})
    --     fc = 0
    --     init_clock = cur_clock
    -- end
    -- if tablelength(prev_frames) == 6 then
    --     print(serialize(prev_frames))
	-- end
	gameStateModule.registerBefore()
	if globals.game_state.match_begun == false then
		return
	end

	charMovesModule.registerBefore()

	globals["options"] 		 = configModule.registerBefore()
	globals["game"]    		 = gameStateModule.registerBefore() 
	globals["pushboxes"]     = cps2HitboxModule.getPushboxes()
	globals["char_moves"]    = charMovesModule.registerBefore()
	globals["dummy"]   		 = dummyStateModule.registerBefore().get_dummy_state()
	-- globals["skip_frame"] 	 = frameskipHandlerModule.registerBefore()
	globals["timers"] 		 = timersModule.registerBefore()
	globals["current_frame"] = emu.framecount()
	-- print("rev", globals.dummy.p2_reversal)

	globals.util.disable_taunts()
	healthAndMeter.registerBefore()
	cps2HitboxModule.registerBefore()
	rollingModule.roll()

	globals.controllerModule.handle_hotkeys()

	globals._input = controllerModule.registerBefore()
	globals.macroLua  = macroLuaModule.registerBefore()
	globals.macroLua.setloop()

	if globals.options.display_pb_stats == false then
		globals.total_pb_attempt_counter = {}
		globals.successful_pb_counter = {}
	end

	-- if globals.macroLua and (globals.macroLua.playing == true or globals.macroLua.recording == true) then
	-- 	if was_gathering_graph_data == false then
	-- 		last_dummy_config = {}
	-- 	end
	-- 	gather_graph_data = true
	-- 	was_gathering_graph_data = true
	-- else 
	-- 	gather_graph_data = false
	-- 	was_gathering_graph_data = false
	-- end

	if 
		globals and
		globals.current_frame and 
		-- gather_graph_data and
		last_dummy_config 
	then
		last_dummy_config[globals.current_frame] = globals.parsed_dummy_state
		last_dummy_dict[globals.current_frame] = globals["dummy"]
		if util.tablelength(last_dummy_config) > globals.graph_data_max then
			last_dummy_dict[globals.current_frame - globals.graph_data_max]  = nil 
			last_dummy_config[globals.current_frame - globals.graph_data_max] = nil
		end
	end

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


	-- local p2_horizontal_charge = memory.readword(0xFF8740 + 0x400)
	-- local p2_horizontal_charge_1 = memory.readbyte(0xFF8800 + 0x316)
	-- local p2_horizontal_charge_2 = memory.writebyte(0xFF8800 + 0x33E, 0x3C)

	-- print(p2_horizontal_charge, p2_horizontal_charge_1,p2_horizontal_charge_2)
	joypad.set(globals._input)

	inpHistoryModule.registerBefore(globals._input)
	-- VerticalCharge Value is at PL1/PL2 + 0x33E & 0x34E
	-- A successful charge value is equal to or greater than a value of 0x3C
	-- That address is a WORD and there is address 0x33C & 0x34c that starts at at 
	-- value 0x3C and reduces the value until value 0x00, this is another check for the charge function.
	
	-- I did find anotehr indication that a charge time is complete.
	-- Horizontal Charge State Address = 0xFF8740. 
	-- Where a "charging" value is 0x02 and a sucessful charge is value "0x04".

	-- Vertical Charge State Address = 0xFF8738 & 0xFF8748.
	-- Where a "charging" value is 0x02 and a sucessful charge is value "0x04".

end)


emu.registerafter(function() --recording is done after the frame, not before, to catch input from playing macros
	if globals.game_state.match_begun == false or globals == nil or globals.options == nil then
		return
	end
	-- if memory.readdword(0xFF8804) == 0x02020400 then
	-- 	-- print("reversal frame registered after frame was drawn", emu.framecount())		
	-- 	-- local current = last_dummy_dict[globals.current_frame]
	-- 	-- current.p2_reversal_frame = true
	-- 	memory.writebyte(0xFF8902, 0x00)
	-- 	memory.writebyte(0xFF8906, 0x02)
	-- end

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
		globals.last_dash_ended = nil
		globals.last_dash_started = nil
		globals.last_attack_started = nil
		globals.last_attack_ended = nil
		globals.p2_hit_or_block_begin = nil
		globals.p2_hit_or_block_end = nil
	end)
	
end

emu.registerexit(function() --Attempt to save if the script exits while recording
	if recording then recording = false finalize(recinputstream) end
end)

----------------------------------------------------------------------------------------------------
--[[ Handle pausing in the while true loop. ]]--
while true do
	gui.register(function()
		-- if memory.readdword(0xFF8804) == 0x02020400 then
		-- 	print("reversal frame registered during gui lifecycle hook")
		-- end
	
		if globals == nil or globals.options == nil then
			gui.clearuncommitted()
			return
		end
		if globals.game_state and globals.game_state.match_begun == false then
			gui.clearuncommitted()
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
		-- local frame_index = 0

		-- local step_x = 50
		-- local step_y = 10
		-- local init_x = 2
		-- local init_y = 2
		-- local current_x = 0
		-- local current_y = 0 
		-- if 
		-- 	graph_data ~= nil 
		-- 	and globals.show_graph_menu == true 
		-- 	and globals.input_history 
		-- 	and globals.input_history.P2 
		-- then
		-- 	gui.box(0,0,emu.screenwidth(), emu.screenheight(),"black")
		-- 	update_graph_data()
		-- 	local added_space = 0

		-- 	for k, v in ipairs(graph_data) do
		-- 		if frame_index == 0 then

		-- 			local index_row = 0 

		-- 			for _k, _v in pairs(v["state"]) do
		-- 				local __x = init_x
		-- 				local __y = init_y + 12 +  10 + ( step_y * index_row )
		-- 				if type(_v.value) ~= "function" then
		-- 					if tostring(_v.name) == "p2_input" then
		-- 						added_space = 8
		-- 					end
		-- 					gui.text(__x,__y + added_space, _v.name)
		-- 					index_row = index_row + 1
		-- 				end
		-- 			end
		-- 		end
		-- 		local _x = init_x + 70 + (step_x * frame_index)
		-- 		local _y = init_y

		-- 		gui.text(_x,_y,v["frame"])
		-- 		if globals.input_history.P1 and globals.input_history.P1[v.frame] then
		-- 			globals.inpHistoryModule.draw_input_history_entry(globals.input_history.P1[v.frame], _x,_y + 8, 0)
		-- 		end
		-- 		local index_row = 0 

		-- 		added_space = 0
		-- 		if util.tablelength(v.state) then 
		-- 			for key, val in pairs(v["state"]) do
		-- 			local __y = init_y + 12 + 10 + ( step_y * index_row )

		-- 			if type(val.value) ~= "function" then

		-- 				if tostring(val.name) == "p2_input" then
		-- 					if globals.input_history.P2 and globals.input_history.P2[v.frame] then
		-- 						globals.inpHistoryModule.draw_input_history_entry(globals.input_history.P2[v.frame], _x,__y+5, 0)
		-- 					end
		-- 					added_space = 10
		-- 					index_row = index_row + 1
		-- 				else 
		-- 					local color =  util.string_to_color(tostring(val.name)..tostring(val.value))
		-- 					gui.rect(_x - 1,__y + added_space, _x + step_x - 1, __y + step_y+ added_space, color)
		-- 					gui.text(_x + 2,__y + 2+ added_space, tostring(val.value), color)
		-- 					index_row = index_row + 1
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- 		frame_index = frame_index+1
		-- 		current_x = _x
		-- 		current_y = _y
		-- 	end
		-- end	
	end)

	macroLuaModule.gameLoop()

	amountOfGarbage = collectgarbage("count")
	if amountOfGarbage > 15000 then
		collectgarbage("collect")
	end
end
