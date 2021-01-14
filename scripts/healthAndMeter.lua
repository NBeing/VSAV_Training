
local p2_last_hit_frame = 0
local p1_last_hit_frame = 0
local p2_last_hurt = false
local last_red = 0
local last_white = 0
local last_meter = 0
local healthAndMeter = {
    ["registerBefore"] = function()
        -- Meter
        function hurt(addr) 
            return memory.readbyte(addr + 0x005) == 0x02 
        end
        local p2_max_life = globals.options.p2_max_life
        local p2_is_hurt = hurt(0xFF8800)
        local p1_is_hurt = hurt(0xFF8400)
        local meter = memory.readword(0xFF8800 + 0x10A)

        local p1_refill_timer = globals.options.p1_refill_timer
        local p2_refill_timer = globals.options.p2_refill_timer

        local p1_seconds_before_refill = 60 * p1_refill_timer
        local p2_seconds_before_refill = 60 * p2_refill_timer

        local p1_red_health = memory.readword(0xFF8400 + 0x52)
        local p1_white_health = memory.readword(0xFF8400 + 0x50)

        local p2_red_health = memory.readword(0xFF8800 + 0x52)
        local p2_white_health = memory.readword(0xFF8800 + 0x50)

        local p2_red_health_delta = p2_max_life - last_red
        local p2_white_health_delta = p2_max_life- last_white

        globals.dmg_calc.p2_red_life = p2_red_health_delta
        globals.dmg_calc.p2_white_life = p2_white_health_delta

        if p2_red_health_delta ~= p2_max_life and 
            p2_white_health_delta ~= p2_max_life and
            globals.dmg_calc.red_life ~= 0 and
            globals.dmg_calc.white_life ~= 0 and 
            globals.options.show_damage_calc == true
        then
            gui.text( 23, 87, "Red Dmg  : "..globals.dmg_calc.p2_red_life)
            gui.text( 23, 95, "White Dmg: "..globals.dmg_calc.p2_white_life)
        end
        
        if p2_is_hurt == true then
            p2_last_hurt = true
        elseif p2_last_hurt == true and p2_is_hurt == false then
            p2_last_hit_frame = emu.framecount()
            p2_last_hurt = false
            last_white = p2_white_health 
            last_red = p2_red_health
        end
        if p1_is_hurt == true then
            p1_last_hurt = true
        elseif p1_last_hurt == true and p1_is_hurt == false then
            p1_last_hit_frame = emu.framecount()
            p1_last_hurt = false
        end

        if p2_last_hit_frame ~= nil 
            and (p2_last_hit_frame + p2_seconds_before_refill) == emu.framecount() 
        then
            memory.writeword(0xFF8800 + 0x50, globals.options.p2_max_life)
            memory.writeword(0xFF8800 + 0x52, globals.options.p2_max_life)
        end

        if p1_last_hit_frame ~= nil 
            and (p1_last_hit_frame + p1_seconds_before_refill) == emu.framecount() 
        then
            memory.writeword(0xFF8400 + 0x50, globals.options.p1_max_life)
            memory.writeword(0xFF8400 + 0x52, globals.options.p1_max_life)
        end


        -- Dark Force
        if globals.options.p1_infinite_df then
            memory.writeword(0xFF8400 + 0x176, 0x60)
        elseif globals.options.p2_infinite_df then
            memory.writeword(0xFF8800 + 0x176, 0x60)
        end
    end
}
return healthAndMeter