local prevFrameCount = 0
local frame_counter = 0
-- local random_num = nil
-- local next_should_gc = true
-- local next_delay = 0

function get_gc_table( delay )

	direction = globals.dummy.facing
	button = globals.dummy.gc_button

	frame_input_table = {}

	if delay ~= 0 then
		for i=0, delay do
			frame_input_table[i] = {}
		end	
	end

	if direction == 'left' then

		frame_input_table[delay]   = {"P2 Left"}
		frame_input_table[delay+1] = {"P2 Down"}

		if button == '3punch' then
			frame_input_table[delay+2] = {"P2 Down", "P2 Left", "P2 Button 1", "P2 Button 2", "P2 Button 3"}
		elseif button == 'punch' then
			frame_input_table[delay+2] = {"P2 Down", "P2 Left", "P2 Button 1" }
		elseif button == '3kick' then
			frame_input_table[delay+2] = {"P2 Down", "P2 Left", "P2 Button 4", "P2 Button 5", "P2 Button 6"}
		elseif button == 'kick' then
			frame_input_table[delay+2] = {"P2 Down", "P2 Left", "P2 Button 4"}
		end
	end
	
	if direction == 'right' then

		frame_input_table[delay]   = {"P2 Right"}
		frame_input_table[delay+1] = {"P2 Down"}

		if button == '3punch' then
			frame_input_table[delay+2] = {"P2 Down", "P2 Right", "P2 Button 1", "P2 Button 2", "P2 Button 3"}
		elseif button == 'punch' then
			frame_input_table[delay+2] = {"P2 Down", "P2 Right", "P2 Button 1" }
		elseif button == '3kick' then
			frame_input_table[delay+2] = {"P2 Down", "P2 Right", "P2 Button 4", "P2 Button 5", "P2 Button 6"}
		elseif button == 'kick' then
			frame_input_table[delay+2] = {"P2 Down", "P2 Right", "P2 Button 4"}
		end
	end

	if delay ~= 0 then
		delay = delay + 2
	else
		delay = 2
	end

	return {
		["frame_input_table"] = frame_input_table,
		["num_frames"] = delay
	}
end


local function clear_p2_inputs(keys)
	pattern = "^P2"
	for k, v in pairs(keys) do
		if k:find(pattern) ~= nil then
			keys[k] = false
		end
	end
	return keys
end


function get_pb_table( delay, type )

	direction = globals.dummy.facing
	frame_input_table = {}

	if delay ~= 0 then
		for i=0, delay do
			frame_input_table[i] = {}
		end	
	end
	num_frames = nil
	if type == "light" then
		frame_input_table[delay]   = {"P2 Button 1"}
		frame_input_table[delay+1] = {}
		frame_input_table[delay+2] = {"P2 Button 1"}
		frame_input_table[delay+3] = {}
		frame_input_table[delay+4] = {"P2 Button 1"}
		frame_input_table[delay+5] = {}
		frame_input_table[delay+6] = {"P2 Button 1"}
		frame_input_table[delay+7] = {}
		frame_input_table[delay+8] = {"P2 Button 1"}
		frame_input_table[delay+9] = {}
		frame_input_table[delay+10] = {"P2 Button 1"}
		frame_input_table[delay+11] = {}
		num_frames = 11
	end
	if type == "medium" then
		frame_input_table[delay]   = {"P2 Button 2"}
		frame_input_table[delay+1] = {}
		frame_input_table[delay+2] = {"P2 Button 2"}
		frame_input_table[delay+3] = {}
		frame_input_table[delay+4] = {"P2 Button 2"}
		frame_input_table[delay+5] = {}
		frame_input_table[delay+6] = {"P2 Button 2"}
		frame_input_table[delay+7] = {}
		frame_input_table[delay+8] = {"P2 Button 2"}
		frame_input_table[delay+9] = {}
		frame_input_table[delay+10] = {"P2 Button 2"}
		frame_input_table[delay+11] = {}
		num_frames = 11

	end
	if type == "heavy" then

		frame_input_table[delay]   = {"P2 Button 3"}
		frame_input_table[delay+1] = {}
		frame_input_table[delay+2] = {"P2 Button 3"}
		frame_input_table[delay+3] = {}
		frame_input_table[delay+4] = {"P2 Button 3"}
		frame_input_table[delay+5] = {}
		frame_input_table[delay+6] = {"P2 Button 3"}
		frame_input_table[delay+7] = {}
		frame_input_table[delay+8] = {"P2 Button 3"}
		frame_input_table[delay+9] = {}
		frame_input_table[delay+10] = {"P2 Button 3"}
		frame_input_table[delay+11] = {}
		num_frames = 11
	end
	if type == "ascending" then

		frame_input_table[delay]   = {"P2 Button 1"}
		frame_input_table[delay+1] = {"P2 Button 4"}
		frame_input_table[delay+2] = {"P2 Button 2"}
		frame_input_table[delay+3] = {"P2 Button 5"}
		frame_input_table[delay+4] = {"P2 Button 3"}
		frame_input_table[delay+5] = {"P2 Button 6"}
		num_frames = 5
	end
	if type == "descending" then

		frame_input_table[delay]   = {"P2 Button 3"}
		frame_input_table[delay+1] = {}
		frame_input_table[delay+2] = {"P2 Button 6"}
		frame_input_table[delay+3] = {}
		frame_input_table[delay+4] = {"P2 Button 2"}
		frame_input_table[delay+5] = {}
		frame_input_table[delay+6] = {"P2 Button 5"}
		frame_input_table[delay+7] = {}
		frame_input_table[delay+8] = {"P2 Button 1"}
		frame_input_table[delay+9] = {}
		frame_input_table[delay+10] = {"P2 Button 4"}
		frame_input_table[delay+11] = {}
		num_frames = 11
	end

	if delay ~= 0 then
		num_frames = delay + num_frames
	else
		delay = num_frames
	end

	return {
		["frame_input_table"] = frame_input_table,
		["num_frames"] = num_frames
	}

end

local function gc_cleanup()
	random_num = nil
	globals.dummy.setNextGCSeed(nil)
	globals.dummy.setNextGCValue()
	globals.dummy.setNextGCDelay()

	if memory.readbyte(0xFF8854) == 0xFF then
		memory.writebyte(0xFF8854, 0x0)
	end
end
local function runGC(run_dummy_input)
	local table = {}
	tableMetadata = get_gc_table(globals.dummy.next_gc_delay)

	inputs     = tableMetadata["frame_input_table"]
	num_frames = tableMetadata["num_frames"]

	return run_dummy_input(
		inputs, 
		num_frames, 
		globals.dummy.guarding,
		gc_cleanup,
		globals.dummy.next_should_gc
	)
end
local function runInput(run_dummy_input, context)
	local table = {}
	tableMetadata = get_gc_table(0)

	inputs     = tableMetadata["frame_input_table"]
	num_frames = tableMetadata["num_frames"]
	-- print(inputs)
	return run_dummy_input(
		inputs, 
		num_frames, 
		context,
		globals.dummy.setNextGCDelay,
		true
	)
end
local serialize  	    = require './scripts/ser'
local function runPB(run_dummy_input)
	local table = {}
	tableMetadata = get_pb_table(globals.dummy.next_gc_delay, globals.dummy.pb_type)

	inputs     = tableMetadata["frame_input_table"]
	num_frames = tableMetadata["num_frames"]

	return run_dummy_input(
		inputs, 
		num_frames, 
		globals.dummy.guarding,
		gc_cleanup,
		globals.dummy.next_should_gc
	)
end
util = require "./scripts/utilities"
frameStartedGuarding = 0
frameEndedGuarding = 0
wasJustGuarding = false
numBlockStunExitInput = 3
blockStunRunCommand = false

function string.starts(String,Start)
	return string.sub(String,1,string.len(Start))==Start
 end

local function guardCancelCheck(run_dummy_input)
	block_stun_timer_addr = 0xFF8558 + 0x400 
	block_stun_timer = memory.readbyte(block_stun_timer_addr)
	block_stop_addr = 0xFF8820 
	block_state_addr = 0xFF8806 
	block_stop = string.starts(util.to_hex(memory.readbyte(block_stop_addr)), "f") == true
	block_state = memory.readbyte(block_state_addr)
	reversal_timer_addr = 0xFF8800 + 0x174
	reversal_timer = memory.readbyte(reversal_timer_addr)
	player_state_addr = 0xFF8800 + 0x04
	player_state = memory.readword(player_state_addr)




	-- CODE FOR REVERSAL BEGIN --
	-- if wasJustGuarding == false and reversal_timer ~= 0 then
	-- 	wasJustGuarding = true
	-- 	frameStartedGuarding = globals.game.cur_frame
	-- end
	-- if block_stun_timer ~= 0 then
	-- 	-- print("in guard stun")
	-- end
	-- if wasJustGuarding == true and block_stun_timer == 0 and block_stop ~= true then
	-- 	frameEndedGuarding = globals.game.cur_frame
	-- 	-- print("Done guarding", frameEndedGuarding)

	-- 	wasJustGuarding = false
	-- end
	-- if globals.game.cur_frame < (numBlockStunExitInput + frameEndedGuarding) then 
	-- 	-- print("Should run frameEndedGuarding frames", globals.game.cur_frame)
	-- 	blockStunRunCommand = true
	-- else 
	-- 	blockStunRunCommand = false
	-- end
	-- return runInput(run_dummy_input, blockStunRunCommand)
	-- CODE FOR REVERSAL END --




	-- if wasJustGuarding == false and block_stun_timer ~= 0 then
	-- 	wasJustGuarding = true
	-- 	frameStartedGuarding = globals.game.cur_frame
	-- 	print("Blocking started on", globals.game.cur_frame)
	-- end
	-- if block_stun_timer ~= 0 then
	-- 	-- print("in guard stun")
	-- end
	-- if wasJustGuarding == true and block_stun_timer == 0 and block_stop ~= true then
	-- 	frameEndedGuarding = globals.game.cur_frame
	-- 	print("Done guarding", frameEndedGuarding)

	-- 	wasJustGuarding = false
	-- end
	-- if globals.game.cur_frame < (numBlockStunExitInput + frameEndedGuarding) then 
	-- 	print("Should run frameEndedGuarding frames", globals.game.cur_frame)
	-- 	blockStunRunCommand = true
	-- else 
	-- 	blockStunRunCommand = false
	-- end
	-- return runInput(run_dummy_input, blockStunRunCommand)

	-- if wasJustGuarding then
	-- 	print("Guarded")
	-- 	if numBlockStunExitInput > 0 then
	-- 		print("running it", numBlockStunExitInput)
	-- 		if globals.game.cur_frame > prevFrameCount then
	-- 			print("dec")
	-- 			numBlockStunExitInput = numBlockStunExitInput -1 
	-- 		end
	-- 		prevFrameCount = globals.game.cur_frame
	-- 		return runInput(run_dummy_input)
	-- 	else
	-- 		print("done")
	-- 		wasJustGuarding = false
	-- 		numBlockStunExitInput = 3
	-- 	end 
	-- end

	prevFrameCount = globals.game.cur_frame
	if globals.dummy.guard_action == 'none' then
		return
	elseif 	globals.options.gc_freq == 0 then
		print("Not running Guard Action. There is no frequency set")
		return
	elseif globals.dummy.guard_action == 'gc' then
		if globals.dummy.gc_button == nil  or globals.dummy.gc_button == "none" then
			print("Not running GC, please set Guard Cancel type")
			return
		end
		return runGC(run_dummy_input)
	elseif globals.dummy.guard_action == 'pb' then
		if globals.dummy.pb_type == nil  or globals.dummy.pb_type == "none" then
			print("Not running PB, please set Guard Cancel type")
			return
		end

		return runPB(run_dummy_input)
	end

	-- block_now_value = memory.readbyte(0xFF8522)
	-- -- print("Block now", block_now_value)
	-- block_now = block_now_value ~= 0x0
	-- keys = joypad.get()
	-- if block_now == true then 
	-- 	facing = get_p2_facing()
	-- 	if facing == 'right' then
	-- 		keys["P2 Left"] = true
	-- 	else 
	-- 		keys["P2 Right"] = true
	-- 	end
	-- end
	-- joypad.set(keys)


	-- if globals.dummy.gc_button == 'none' or globals.dummy.gc_button == nil then
	-- 	return
	-- end

	-- curFrameCount = emu.framecount()

	-- if globals.dummy.guarding == true then
	-- 	if start_frame == nil then
	-- 		start_frame = curFrameCount
	-- 		current_frame = -1
	-- 	end

	-- 	if curFrameCount > prevFrameCount then
	-- 		current_frame = current_frame + 1 
	-- 	end

	-- 	local table = {}
	-- 	if globals.dummy.next_gc_delay == nil then
	-- 		print("It was nil setting to 0")
	-- 	end
	-- 	tableMetadata = get_gc_table(globals.dummy.next_gc_delay)
	-- 	-- tableMetadata = get_pb_table(next_delay, "two")
	-- 	table = tableMetadata["frame_input_table"]
	-- 	table_frames = tableMetadata["num_frames"]
	-- 	keys = joypad.get()

	-- 	if current_frame <= table_frames then
	-- 		if dummy.next_should_gc == true then
	-- 			for _, input in ipairs(table[current_frame]) do
	-- 				keys[input] = true
	-- 			end
	-- 		end
	-- 	else

	-- 		-- random_num = nil
	-- 		dummy.setNextGCSeed(nil)
	-- 		dummy.setNextGCValue()
	-- 		dummy.setNextGCDelay()

	-- 		if memory.readbyte(0xFF8854) == 0xFF then
	-- 			memory.writebyte(0xFF8854, 0x0)
	-- 		end
	-- 	end

	-- 	joypad.set(keys)

	-- else 
	-- 	start_frame = nil
	-- 	current_frame = nil
		
	-- end

	-- prevFrameCount = curFrameCount

	-- return current_keys
end

guardCancelModule = {
	["registerBefore"] = function(run_dummy_input)
        return guardCancelCheck(run_dummy_input)
    end
}
return guardCancelModule