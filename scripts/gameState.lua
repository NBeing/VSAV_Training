
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
        cur_frame   = emu.framecount(),
        prev_frame = emu.framecount() - 1
    }
end
local debounceStarted = nil
local function debounce(func, debounceTime)
  if debounceStarted == nil then 
    debounceStarted = globals.current_frame
    func()
    return
  end
  if debounceStarted + debounceTime <  globals.current_frame then
    debounceStarted = globals.current_frame
    func()
    return
  end
end
local p1_char_palette = 0x00
gameStateModule = {
    ["registerBefore"] = function()
        globals.game_state = get_game_state()
        if not globals.game_state.match_begun then
            -- Set infinite character select time
            memory.writebyte(0xFF8400 + 0x27, 60)
            memory.writebyte(0xFF8800 + 0x27, 60)

            -- if globals.options.enable_custom_palette then
                -- local _inputs = joypad.getup()
                -- print(_inputs["P1 Start"])
                --   -- if  down["start"] == true and down["LP"] == true then 
                --   if _inputs["P1 Start"] ~= false and then 
                --     print("doint")
                --   end
              
                -- memory.writebyte(0xFF8BAE, )
                -- memory.writebyte(0xFF8BAE, globals.options.p2_char_palette)
            -- end
        end
    end
}
return gameStateModule