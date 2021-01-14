-- Values to write into memory
local auto_guard_addr_1 = 0xFF8BB2
local auto_guard_addr_2 = 0xFF8BE2
local first_frame = nil 

local function get_block_chance()
    local block_freq_value = globals.options.p2_block_chance
    local function maybe(x) 
        if 100 * math.random() < x then 
            return true
        else 
            return false
        end  
    end    

    local should_block = false

    if block_freq_value == 0x2 then
        should_block = maybe(35)
    elseif block_freq_value == 0x3 then
        should_block = maybe(50)
    elseif block_freq_value == 0x4 then
        should_block = maybe(65)
    elseif block_freq_value == 0x5 then
        should_block = true
    elseif block_freq_value == 0x1 then
        should_block = false
    end

    return should_block    
end
local run_once_stand = nil
local run_once_crouch = nil
local block_started_frame = nil
local is_attacking = nil
local has_blocked = false

function dummy_guard(cur_keys)
    local block_chance = get_block_chance()
    -- 0x100 	Standing or crouching normal-attack indicator. 2 = crouch 
    local p1_is_crouch_attack = memory.readbyte(0xFF8400 + 0x100) == 2 
    if globals.dummy.p1_status_2 == "Jump" then
        p1_is_crouch_attack = false
    end
    -- print("is cruch?", p1_is_crouch_attack)
    local p1_x_pos = memory.readword(0xFF8400 + 0x10)
	local p2_x_pos = memory.readword(0xFF8800 + 0x10)
    local p1_proj  = memory.readword(0xFF8400 + 0x149)
    local p2_proj  = memory.readword(0xFF8800 + 0x149)

    local close_enough      = math.abs(p1_x_pos - p2_x_pos) < 0x100
    -- local should_block      = false

    if globals.controlling_p1 then
        attack_flag = globals.dummy.p1_attack_flag
        away_btn    = globals.dummy.p2_away_btn
        proj        = p1_proj
     else
        attack_flag = globals.dummy.p2_attack_flag 
        away_btn    = globals.dummy.p1_away_btn
        proj        = p2_proj
     end

    if proj ~= 0 then 
        cur_keys[ away_btn ] = true
		return cur_keys
    end
    if globals.dummy.p2_guarding == true then
        has_blocked = false
    end
    if attack_flag then
        is_attacking = true
    else 
        block_started_frame = nil
    end
    if attack_flag and close_enough then
        if not has_blocked then 
            block_started_frame = emu.framecount()
            cur_keys[ away_btn ] = true
            if p1_is_crouch_attack then  
                cur_keys["P2 Down"] = true
            end
            has_blocked = true
            return cur_keys
        elseif block_started_frame and emu.framecount() == block_started_frame + 1 then
            if p1_is_crouch_attack then  
                cur_keys[ away_btn ] = true
                cur_keys["P2 Down"] = true
            end
        end
    end
    if not attack_flag and has_blocked == true then
        attack_started_frame = nil
        has_blocked = false
        is_attacking = false
    end
    -- if attack_flag and close_enough == true then
    -- 	if run_once_stand == false and first_frame == nil then
    --         first_frame = emu.framecount()
    --          cur_keys[ away_btn ] = true
    --         return cur_keys
    --     end
    --     if p1_is_crouch_attack then
    --         -- Crouch blocking requires two frames to be bulletproof
    --         if run_once_crouch == false and first_frame == nil or (first_frame and emu.framecount() == first_frame + 1) then
    --             first_frame = emu.framecount()
    --             cur_keys[ away_btn ] = true
    --             if p1_is_crouch_attack then  
    --                 cur_keys["P2 Down"] = true
    --             end
    --             return cur_keys
    --         end
    --     end
    --     -- if  first_frame ~= nil and emu.framecount() < first_frame + 1 and block_chance then
    --     --     cur_keys[ away_btn ] = true
    --     --     if p1_is_crouch_attack then  
    --     --         cur_keys["P2 Down"] = true
    --     --     end
    --     --     return cur_keys
	-- 	-- else 
	
	-- 	-- end
    -- else
    --     run_once_stand = false
    --     run_once_crouch = false
	-- 	first_frame = nil
	-- end
    return {}
end

autoguardModule = {
    ["registerBefore"] = function(cur_keys)
        if globals.options.guard == 0x3 then
            memory.writebyte(auto_guard_addr_1, 0x1)
            memory.writebyte(auto_guard_addr_2, 0x1)
        else
            memory.writebyte(auto_guard_addr_1, 0x0)
            memory.writebyte(auto_guard_addr_2, 0x0)
        end
        if globals.options.guard == 2 then
            return dummy_guard(cur_keys)
        else
            return {}
        end
    end
}
return autoguardModule