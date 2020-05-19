
local p1_char_active_addr = 0xFF8401
local p2_char_active_addr = 0xFF8801

local p1_charselect_timer_adr = 0xFF8426
local p2_charselect_timer_adr = 0xFF8826

local function match_begun()

    p1_char_active = memory.readbyte(p1_char_active_addr)
    p2_char_active = memory.readbyte(p2_char_active_addr)

    return p1_char_active == 1 and p2_char_active == 1 

end

local function get_game_state()
    return {
        match_begun = match_begun(),
        cur_frame   = emu.framecount()
    }
end
gameStateModule = {
    ["registerBefore"] = function()
        return get_game_state()
    end
}
return gameStateModule