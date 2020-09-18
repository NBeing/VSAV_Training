-- Values to write into memory
local auto_guard_addr_1 = 0xFF8BB2
local auto_guard_addr_2 = 0xFF8BE2
first_frame = nil 

function dummy_guard()
 
    local p1_x_pos = memory.readword(0xFF8400 + 0x10)
	local p2_x_pos = memory.readword(0xFF8800 + 0x10)
    local p1_proj  = memory.readword(0xFF8400 + 0x149)
    local p2_proj  = memory.readword(0xFF8800 + 0x149)

    local close_enough      = math.abs(p1_x_pos - p2_x_pos) < 0x100
	local should_block      = false
	local cur_keys          = joypad.get()
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
        joypad.set(cur_keys)
		return
	end


    if attack_flag and close_enough == true then
    	if run_once == false and first_frame == nil then
			first_frame = emu.framecount()
		end

        if emu.framecount() < first_frame + 1 then
			cur_keys[ away_btn ] = true
			joypad.set(cur_keys)
		else 
	
		end
	else
		run_once = false
		first_frame = nil
	end

end

autoguardModule = {
    ["registerBefore"] = function()

        if globals.options.guard == 0x2 then
            memory.writebyte(auto_guard_addr_1, 0x1)
            memory.writebyte(auto_guard_addr_2, 0x1)
        else
            memory.writebyte(auto_guard_addr_1, 0x0)
            memory.writebyte(auto_guard_addr_2, 0x0)
        end
        if globals.options.guard == 1 then
            dummy_guard()
        end
    end
}
return autoguardModule