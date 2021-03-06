local function maybe(x) 
	if 100 * math.random() < x then 
		return true
	else 
		return false
	end  
end 
local function shouldGC()
	local GC_freq_value = globals.options.gc_freq
    local function maybe(x) 
        if 100 * math.random() < x then 
            return true
        else 
            return false
        end  
    end    

	local should_GC = false

	if GC_freq_value == 0x2 then
        should_GC = maybe(35)
    elseif GC_freq_value == 0x3 then
        should_GC = maybe(50)
	elseif GC_freq_value == 0x4 then
		should_GC = maybe(65)
	elseif GC_freq_value == 0x5 then
        should_GC = true
    elseif GC_freq_value == 0x1 then
		should_GC = false
    end

    return should_GC
end
local function run_one_frame_special()
	-- 1f specials/supers
	-- Allocate the strength at 0xFF8502, where  
	-- 0x00 = Light, 0x02 = Medium, 0x04 = Heavy & 0x06 = ES
	-- Allocate the specific move at 0xFF8506 - see tweets per character
	-- Write WORD at FF8406 to value 0x0E00
	-- Add dark force reversals using this ram address 0x110
	local move_value = globals.dummy.p2_char_specific_reversal.value
	local move_strength = globals.dummy.p2_reversal_strength
	memory.writebyte(0xFF8902, move_strength)
	memory.writebyte(0xFF8906, move_value)
	-- whenever strength is es or ex then specify pallete effect
	-- 0x14E 	Palette Effects & Curse , ES/EX, etc
	-- ES Value is 1E
	-- EX Value is 1C
	-- if move_strength == 0x06 then 
	-- 	memory.writebyte(0xFF8800 + 0x14E , 0x1E)
	-- end
	-- if isEX then
	-- 	memory.writebyte(0xFF8800 + 0x14E , 0x1C)
	-- elseif move_strength == 0x06 then 
	-- 	memory.writebyte(0xFF8800 + 0x14E , 0x1E)
	-- end
	-- -- Write WORD at FF8406 to value 0x0E00
	memory.writeword(0xFF8806, 0x0E00)
	memory.writebyte(0xFF87B5, 0x0C)
end
util = require "./scripts/utilities"
local frameStartedGuarding = 0
local frameEndedGuarding = 0
local wasJustGuarding = false
local numBlockStunExitInput = 3
local blockStunRunCommand = false

local function guardCancelCheck(run_dummy_input, macroLua_funcs)
	-- This is the randomness check i.e. "should happen 0%-100% of the time"
	local should_perform = shouldGC()
	if not should_perform then return {} end

	if 
		not last_dummy_dict or
		not last_dummy_dict[globals.current_frame] or
		not last_dummy_dict[globals.current_frame - 1]
	then
		return {} 
	end

	_defender = player_objects[2]

	local current = last_dummy_dict[globals.current_frame]
	local prev    = last_dummy_dict[globals.current_frame - 1]
	local state_minus_2  = last_dummy_dict[globals.current_frame - 2]
	local state_minus_3  = last_dummy_dict[globals.current_frame - 3]
	local delay = globals.options.gc_delay
	local delay_type = "delay_before"
	local _stick
	local _button
	local block_stop_timer = memory.readbyte(0xFF8558 + 0x400 )
	local use_true_reversal = globals.options.true_reversal
	local true_reversal = prev.p2_reversal_frame and not current.p2_reversal_frame
	local bulletproof_reversal = current.p2_reversal > 0 and prev.p2_reversal == 0 and
									(prev.p2_status_1 == "Hurt or Block" or state_minus_2.p2_status_1 == "Hurt or Block")

	local should_reversal = false
	if use_true_reversal and true_reversal then should_reversal = true end
	if not use_true_reversal and bulletproof_reversal then should_reversal = true end 
	
	if wasJustGuarding == false and block_stop_timer ~= 0 then
		wasJustGuarding = true
		frameStartedGuarding = globals.game_state.cur_frame
	end

	local should_counter = false
	local counter_condition = player_objects[2].guard_ended and wasJustGuarding == true
	if use_true_reversal and counter_condition and should_reversal then should_counter = true end
	if not use_true_reversal and counter_condition then should_counter = true end 


	if globals.dummy.guard_action == 'none' then
		return {}
	elseif 	globals.options.gc_freq == 0 then
		emu.message("Not running Guard Action. There is no frequency set")
		return {}
	elseif globals.dummy.guard_action == 'gc' then
		if player_objects[2].started_guarding then 
			_defender.counter.attack_frame = globals.current_frame
			_stick = "DPF"
			_button = get_gc_button()
			_defender.counter.sequence = make_input_sequence(_stick, _button, delay_type, delay)
		else
			_defender.counter.sequence = nil
		end

	elseif globals.dummy.guard_action == 'pb' then
		if player_objects[2].started_guarding then 
			_defender.counter.attack_frame = globals.current_frame
			_stick = "PB-"..globals.dummy.pb_type
			_button = ""
			_defender.counter.sequence = make_input_sequence(_stick, _button, delay_type, delay)
		else
			_defender.counter.sequence = nil
		end

	elseif globals.dummy.guard_action == 'counter' then
		if should_counter then
			_defender.counter.attack_frame = frameEndedGuarding
			_stick = globals.dummy.counter_attack_stick
			_button = globals.dummy.counter_attack_button
			_defender.counter.sequence = make_input_sequence(_stick, _button, delay_type, delay)
			wasJustGuarding = false
		else
			_defender.counter.sequence = nil
		end
	elseif globals.dummy.guard_action == "recording on counter" then
		if wasJustGuarding == false and block_stun_timer ~= 0 then
			wasJustGuarding = true
			frameStartedGuarding = globals.game_state.cur_frame
		end

		if should_counter then
			if not globals.macroLua.playing then  
				globals.macroLua.playcontrol()
			end
			wasJustGuarding = false
		else
			_defender.counter.sequence = nil
			_defender.pending_input_sequence = nil
		end

	elseif globals.dummy.guard_action == 'reversal' then
		if should_reversal then
			_defender.counter.attack_frame = globals.current_frame
			_stick = globals.dummy.counter_attack_stick
			_button = globals.dummy.counter_attack_button
			_defender.counter.sequence = make_input_sequence(_stick, _button, delay_type, delay)
		else
			_defender.counter.sequence = nil
		end

	elseif globals.dummy.guard_action == 'recording on reversal' then
		if should_reversal then 
			if not globals.macroLua.playing then  
				globals.macroLua.playcontrol()
			end
		else
			_defender.counter.sequence = nil
			_defender.pending_input_sequence = nil
		end
	elseif globals.dummy.guard_action == 'Character Specific Reversal' then
		if should_reversal then 
			print("running one frame special rev")
			run_one_frame_special()
		else
			_defender.counter.sequence = nil
		end
	elseif globals.dummy.guard_action == 'Character Specific Counter' then
		if should_counter then 
			print("running one frame special counter")
			run_one_frame_special()
		else
			_defender.counter.sequence = nil
		end
	else 
		return {}
	end


	if _defender.counter.sequence then
		local _frames_remaining = _defender.counter.attack_frame - globals.current_frame
		if _debug then
		  print(_frames_remaining)
		end
		if _frames_remaining <= (#_defender.counter.sequence + 1) then
		  if _debug then
			print(frame_number.." - queue ca")
		  end
		  queue_input_sequence(_defender, _defender.counter.sequence)
		  _defender.counter.sequence = nil
		  _defender.counter.attack_frame = -1
		end
	end
end

guardCancelModule = {
	["registerBefore"] = function(run_dummy_input, macroLua_funcs)
        return guardCancelCheck(run_dummy_input, macroLua_funcs)
    end
}
return guardCancelModule