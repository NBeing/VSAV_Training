local function get_dummy_neutral()

	dummy_neutral_config = globals.options.dummy_neutral
	p2_towards           = globals.dummy.p2_toward_btn
	p2_away              = globals.dummy.p2_away_btn

	if dummy_neutral_config == 0  then
		state = {name = "stand", input = {} }
	elseif dummy_neutral_config == 1 then
		state = {name = "down-back", input = {"P2 Down", p2_away} }
	elseif dummy_neutral_config == 2 then
		state = {name = "down", input = {"P2 Down"} }
	elseif dummy_neutral_config == 3 then
		state = {name = "down-forward", input = {"P2 Down", p2_towards} }
	elseif dummy_neutral_config == 4 then
		state = {name = "back", input = { p2_away} }
	-- elseif dummy_neutral_config == 5 then
	-- 	state = {name = "stand-block", input = {} }
	elseif dummy_neutral_config == 5 then
		state = {name = "forward", input = { p2_towards} }
	elseif dummy_neutral_config == 6 then
		state = {name = "up-back", input = { "P2 Up", p2_away} }
	elseif dummy_neutral_config == 7 then
		state = {name = "up", input = {"P2 Up"}}
	elseif dummy_neutral_config == 8 then
		state = {name = "up-forward", input = {"P2 Up", p2_towards} }
	end
	
	return state
end


local function set_dummy_action()
	keys = joypad.get()
	dummy_state = get_dummy_neutral()
	-- p2_jump_guard_keys = jump_guard() 
	inputs = dummy_state['input']
	-- print(inputs)
	for _, input in pairs(inputs) do
		keys[input] = true
	end
	-- for _, input in pairs(p2_jump_guard_keys) do
	-- 	keys[input] = true
	-- end
	joypad.set(keys)
end

jump_started_on_frame = nil
local function is_jumping()
	p2_jump_addr   = 0xFF8806
	p2_landed_addr = 0xFF8807
	p2_hurt_addr   = 0xFF8805
	p2_hurt_value  = memory.readbyte(p2_hurt_addr) == 0x02

	if p2_hurt_value == true then
		jump_started_on_frame = nil
		return
	end

	p2_jump_value = memory.readbyte(p2_jump_addr) == 0x06
	p2_landed_value = memory.readbyte(p2_landed_addr) == 0x04

	if p2_landed_value == true then
		jump_started_on_frame = nil
	end

	if p2_jump_value == true then
		if jump_started_on_frame == nil then
			jump_started_on_frame = emu.framecount()
		end
	end 

	return p2_jump_value	
end

local _prevFrameCount = 0
dummyNeutralModule = {
	["registerBefore"] = function()

        attacking =  memory.readbyte(0xFF8505) == 0x01
        -- print("Attacking?", attacking)
        curFrameCount = emu.framecount()
        -- print("Jump started on: " , jump_started_on_frame)
		-- is_jumping()
		-- print(curFrameCount > prevFrameCount)
		-- if curFrameCount > prevFrameCount then
			-- print("Running")
            set_dummy_action()
            jumping_state = is_jumping()

            -- if jumping_state == true and jump_started_on_frame ~= nil and curFrameCount - jump_started_on_frame > 0 then
            --     keys = joypad.get()
            --     away = globals.dummy.away_btn
            --     keys[away] = true
            --     joypad.set(keys)
			-- end
		-- end
		_prevFrameCount = curFrameCount
    end
}

return dummyNeutralModule