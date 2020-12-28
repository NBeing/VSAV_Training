
local last_hit_frame = 0
local last_hurt = false
local last_red = 0
local last_white = 0
local last_meter = 0
local healthAndMeter = {
    ["registerBefore"] = function()
        function hurt(addr) 
            return memory.readbyte(addr + 0x005) == 0x02 
        end
        local max_life = globals.options.max_life
        local is_hurt = hurt(0xFF8800)
        local meter = memory.readword(0xFF8800 + 0x10A)
        local refill_timer = globals.options.refill_timer
        local seconds_before_refil = 60 * refill_timer
        local red_health = memory.readword(0xFF8800 + 0x52)
        local white_health = memory.readword(0xFF8800 + 0x50)

        local red_health_delta = globals.options.max_life - last_red
        local white_health_delta = globals.options.max_life - last_white

        globals.dmg_calc.red_life = red_health_delta
        globals.dmg_calc.white_life = white_health_delta

        if red_health_delta ~= max_lief and 
            white_health_delta ~= max_life and 
            globals.options.show_damage_calc == true
        then
            gui.text( 23, 87, "Red Dmg  : "..globals.dmg_calc.red_life)
            gui.text( 23, 95, "White Dmg: "..globals.dmg_calc.white_life)
        end
        if is_hurt == true then
            last_hurt = true
        elseif last_hurt == true and is_hurt == false then
            last_hit_frame = emu.framecount()
            last_hurt = false
            last_white = white_health 
            last_red = red_health
            -- calc_meter_diff 

        end
        if last_hit_frame ~= nil 
            and refill_timer ~= 0
            and (last_hit_frame + seconds_before_refil) == emu.framecount() 
        then
            memory.writeword(0xFF8800 + 0x50, globals.options.max_life)
            memory.writeword(0xFF8800 + 0x52, globals.options.max_life)
        end
    end
}
return healthAndMeter