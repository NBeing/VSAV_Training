local prevFrameCount = 0
local frame_counter = 0
-- local random_num = nil
-- local next_should_gc = true
-- local next_delay = 0

function get_gc_table( delay )

	direction = globals.dummy.p2_facing
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
			frame_input_table[delay+2] = {"P2 Down", "P2 Left", "P2 Weak Punch", "P2 Medium Punch", "P2 Strong Punch"}
		elseif button == 'punch' then
			frame_input_table[delay+2] = {"P2 Down", "P2 Left", "P2 Weak Punch" }
		elseif button == '3kick' then
			frame_input_table[delay+2] = {"P2 Down", "P2 Left", "P2 Weak Kick", "P2 Medium Kick", "P2 Strong Kick"}
		elseif button == 'kick' then
			frame_input_table[delay+2] = {"P2 Down", "P2 Left", "P2 Weak Kick"}
		end
	end
	
	if direction == 'right' then

		frame_input_table[delay]   = {"P2 Right"}
		frame_input_table[delay+1] = {"P2 Down"}

		if button == '3punch' then
			frame_input_table[delay+2] = {"P2 Down", "P2 Right", "P2 Weak Punch", "P2 Medium Punch", "P2 Strong Punch"}
		elseif button == 'punch' then
			frame_input_table[delay+2] = {"P2 Down", "P2 Right", "P2 Weak Punch" }
		elseif button == '3kick' then
			frame_input_table[delay+2] = {"P2 Down", "P2 Right", "P2 Weak Kick", "P2 Medium Kick", "P2 Strong Kick"}
		elseif button == 'kick' then
			frame_input_table[delay+2] = {"P2 Down", "P2 Right", "P2 Weak Kick"}
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

	direction = globals.dummy.p2_facing
	frame_input_table = {}

	if delay ~= 0 then
		for i=0, delay do
			frame_input_table[i] = {}
		end	
	end
	num_frames = nil
	if type == "light" then
		frame_input_table[delay]   = {"P2 Weak Punch"}
		frame_input_table[delay+1] = {}
		frame_input_table[delay+2] = {"P2 Weak Punch"}
		frame_input_table[delay+3] = {}
		frame_input_table[delay+4] = {"P2 Weak Punch"}
		frame_input_table[delay+5] = {}
		frame_input_table[delay+6] = {"P2 Weak Punch"}
		frame_input_table[delay+7] = {}
		frame_input_table[delay+8] = {"P2 Weak Punch"}
		frame_input_table[delay+9] = {}
		frame_input_table[delay+10] = {"P2 Weak Punch"}
		frame_input_table[delay+11] = {}
		num_frames = 11
	end
	if type == "medium" then
		frame_input_table[delay]   = {"P2 Medium Punch"}
		frame_input_table[delay+1] = {}
		frame_input_table[delay+2] = {"P2 Medium Punch"}
		frame_input_table[delay+3] = {}
		frame_input_table[delay+4] = {"P2 Medium Punch"}
		frame_input_table[delay+5] = {}
		frame_input_table[delay+6] = {"P2 Medium Punch"}
		frame_input_table[delay+7] = {}
		frame_input_table[delay+8] = {"P2 Medium Punch"}
		frame_input_table[delay+9] = {}
		frame_input_table[delay+10] = {"P2 Medium Punch"}
		frame_input_table[delay+11] = {}
		num_frames = 11

	end
	if type == "heavy" then

		frame_input_table[delay]   = {"P2 Strong Punch"}
		frame_input_table[delay+1] = {}
		frame_input_table[delay+2] = {"P2 Strong Punch"}
		frame_input_table[delay+3] = {}
		frame_input_table[delay+4] = {"P2 Strong Punch"}
		frame_input_table[delay+5] = {}
		frame_input_table[delay+6] = {"P2 Strong Punch"}
		frame_input_table[delay+7] = {}
		frame_input_table[delay+8] = {"P2 Strong Punch"}
		frame_input_table[delay+9] = {}
		frame_input_table[delay+10] = {"P2 Strong Punch"}
		frame_input_table[delay+11] = {}
		num_frames = 11
	end
	if type == "ascending" then

		frame_input_table[delay]   = {"P2 Weak Punch"}
		frame_input_table[delay+1] = {"P2 Weak Kick"}
		frame_input_table[delay+2] = {"P2 Medium Punch"}
		frame_input_table[delay+3] = {"P2 Medium Kick"}
		frame_input_table[delay+4] = {"P2 Strong Punch"}
		frame_input_table[delay+5] = {"P2 Strong Kick"}
		num_frames = 5
	end
	if type == "descending" then

		frame_input_table[delay]   = {"P2 Strong Punch"}
		frame_input_table[delay+1] = {}
		frame_input_table[delay+2] = {"P2 Strong Kick"}
		frame_input_table[delay+3] = {}
		frame_input_table[delay+4] = {"P2 Medium Punch"}
		frame_input_table[delay+5] = {}
		frame_input_table[delay+6] = {"P2 Medium Kick"}
		frame_input_table[delay+7] = {}
		frame_input_table[delay+8] = {"P2 Weak Punch"}
		frame_input_table[delay+9] = {}
		frame_input_table[delay+10] = {"P2 Weak Kick"}
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
local function upback_cleanup()
	random_num = nil
	globals.dummy.setNextUpbackSeed(nil)
	globals.dummy.setNextUpbackValue()

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
		globals.dummy.p2_guarding,
		gc_cleanup,
		globals.dummy.next_should_gc
	)
end

local function maybe(x) 
	if 100 * math.random() < x then 
		return true
	else 
		return false
	end  
end 
function get_counter_table( delay, type )

	direction = globals.dummy.p2_facing
	frame_input_table = {}
	type = globals.options.counter_attack

	if delay ~= 0 then
		for i=0, delay do
			frame_input_table[i] = {}
		end	
	end
	num_frames = 0
	if type == 1 then
		frame_input_table[delay]   = {"P2 Weak Punch"}
	elseif type == 2 then
		frame_input_table[delay]   = {"P2 Weak Kick"}
	elseif type == 3 then
		frame_input_table[delay]   = {"P2 Medium Punch"}
	elseif type == 4 then
		frame_input_table[delay]   = {"P2 Medium Kick"}
	elseif type == 5 then
		frame_input_table[delay]   = {"P2 Strong Punch"}
	elseif type == 6 then
		frame_input_table[delay]   = {"P2 Strong Kick"}
	elseif type == 7 then
		if direction == 'left' then
			frame_input_table[delay]   = {"P2 Right", "P2 Up"}
		else
			frame_input_table[delay]   = {"P2 Left", "P2 Up"}
		end	
	elseif type == 8 then
		frame_input_table[delay]   = {"P2 Down", "P2 Weak Punch"}
	elseif type == 9 then
		frame_input_table[delay]   = {"P2 Down", "P2 Weak Kick"}
	elseif type == 10 then
		frame_input_table[delay]   = {"P2 Down", "P2 Medium Punch"}
	elseif type == 11 then
		frame_input_table[delay]   = {"P2 Down", "P2 Medium Kick"}
	elseif type == 12 then
		frame_input_table[delay]   = {"P2 Down", "P2 Strong Punch"}
	elseif type == 13 then
		frame_input_table[delay]   = {"P2 Down", "P2 Strong Kick"}
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
local function runInput(run_dummy_input, context)
	local table = {}
	tableMetadata = get_counter_table(0)
	inputs     = tableMetadata["frame_input_table"]
	num_frames = tableMetadata["num_frames"]

	return run_dummy_input(
		inputs, 
		num_frames, 
		context,
		gc_cleanup,
		globals.dummy.next_should_gc
	)
end
local function runUpback(run_dummy_input, context)
	-- print("run it")
	local table = {}
	tableMetadata = get_counter_table(0)
	inputs     = tableMetadata["frame_input_table"]
	num_frames = tableMetadata["num_frames"]
	-- print(globals.dummy.next_should_upback)
	return run_dummy_input(
		inputs, 
		num_frames, 
		context,
		upback_cleanup,
		globals.dummy.next_should_gc
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
		globals.dummy.p2_guarding,
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
	-- run_escr(run_dummy_input)
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

	prevFrameCount = globals.game.cur_frame
	-- print("Guard action",globals.dummy.guard_action )
	if globals.dummy.guard_action == 'none' then
		return
	elseif 	globals.options.gc_freq == 0 then
		emu.message("Not running Guard Action. There is no frequency set")
		return
	elseif globals.dummy.guard_action == 'gc' then
		if globals.dummy.gc_button == nil  or globals.dummy.gc_button == "none" then
			emu.message("Not running GC, please set Guard Cancel type")
			return
		end
		return runGC(run_dummy_input)
	elseif globals.dummy.guard_action == 'pb' then
		if globals.dummy.pb_type == nil  or globals.dummy.pb_type == "none" then
			emu.message("Not running PB, please set Guard Cancel type")
			return
		end

		return runPB(run_dummy_input)
	elseif globals.dummy.guard_action == 'counter' then
		if globals.options.counter_attack == 0 then
			emu.message("Not running counter, please set counter type")
			return
		end
		if wasJustGuarding == false and block_stun_timer ~= 0 then
			wasJustGuarding = true
			frameStartedGuarding = globals.game.cur_frame
			-- print("Blocking started on", globals.game.cur_frame)
		end

		-- if block_stun_timer ~= 0 then
			-- print("in guard stun", block_stun_timer)
		-- end

		if wasJustGuarding == true and block_stun_timer == 0 and block_stop ~= true then
			frameEndedGuarding = globals.game.cur_frame
			-- print("Done guarding", frameEndedGuarding)

			wasJustGuarding = false
		end
		if globals.game.cur_frame < (numBlockStunExitInput + frameEndedGuarding) then 
			blockStunRunCommand = true
		else 
			blockStunRunCommand = false
		end

		return runUpback(run_dummy_input, blockStunRunCommand)
	elseif globals.dummy.guard_action == 'reversal' then
		if globals.options.counter_attack == 0 then
			emu.message("Not running counter, please set counter type")
			return
		end
		p2_reversal = memory.readbyte(0xFF8800 + 0x174)
		p1_reversal = memory.readbyte(0xFF8400 + 0x174)	

		-- print("Rev Timer is: ", p2_reversal)
		return runInput(run_dummy_input, p2_reversal > 0)

	end

end

guardCancelModule = {
	["registerBefore"] = function(run_dummy_input)
        return guardCancelCheck(run_dummy_input)
    end
}
return guardCancelModule