local timers = {
    p1_pushblock_counter = 0
}
local record_tech_hit_results = false
timerModule = {
    ["registerBefore"] = function()
        local p1_pushblock_counter = memory.readbyte(0xFF8400 + 0x170)
        local p1_tech_hit_timer = memory.readbyte(0xFF8400 + 0x1AB) 
        if p1_tech_hit_timer > 0 then
            record_tech_hit_results = true
            timers.p1_pushblock_counter = p1_pushblock_counter
        elseif p1_tech_hit_timer == 0 and record_tech_hit_results == true then
            record_tech_hit_results = false
            timers.p1_pushblock_counter = p1_pushblock_counter
        end
        return timers
    end
}

return timerModule