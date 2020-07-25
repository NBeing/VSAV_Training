local util = require "./scripts/utilities" 

local auto_guard_cheat_addr  = 0xFF818C
local dummy_state_cheat_addr = 0xFF818E
local GC_type_addr           = 0xFF818D
local GC_freq_addr           = 0xFF818B
local GC_delay_addr          = 0xFF818A
local roll_addr              = 0xFF80D9
local pb_addr                = 0xFF818F
local pb_type_cheat_addr     = 0xFF8190

local function get_config_matrix()
    return {

        dummy_neutral       = memory.readbyte(dummy_state_cheat_addr),
    
        gc_button           = memory.readbyte(GC_type_addr),
        gc_freq             = memory.readbyte(GC_freq_addr),
        gc_delay            = memory.readbyte(GC_delay_addr),
    
        get_roll            = memory.readbyte(roll_addr),
    
        auto_guard          = memory.readbyte(auto_guard_cheat_addr),

        guard_action        = memory.readbyte(pb_addr),
        push_block_type     = memory.readbyte(pb_type_cheat_addr)

    }
end

local function parse_config()
end
previous_config_matrix = nil

cheatConfigModule = {
    ["registerBefore"] = function()
        
        config_matrix = get_config_matrix()
        config_unchanged = util.do_tables_match(config_matrix, previous_config_matrix)
        -- print("Checking config changed", config_matrix, previous_config_matrix, config_changed)
        if config_unchanged == false then 
            print("Configuration updated", config_matrix)
            if globals.dummy then
                -- The functions of the guard cancel are stateful so they need to be manually updated
                -- print("resetting GC values")
                globals.dummy.setNextGCValue(config_matrix["gc_freq"])
                globals.dummy.setNextGCDelay(config_matrix["gc_delay"])
                globals.dummy.setNextGCSeed(nil)
                globals.dummy = globals.dummy.refresh_dummy()
                -- print("Reset gc parameters", globals.dummy.next_should_gc,globals.dummy.next_gc_delay,globals.dummy.gc_freq)
            end
            previous_config_matrix = config_matrix
        end
        if debug == true then
            gui.text(2,0,"Dummy : "..config_matrix["dummy_neutral"])
            gui.text(2,8,"GC Button : "..config_matrix["gc_button"])
            gui.text(2,16,"GC Freq : "..config_matrix["gc_freq"])
            gui.text(2,24,"GC Delay : "..config_matrix["gc_delay"]) 
            gui.text(2,32,"Roll Dir : "..config_matrix["get_roll"])
            gui.text(2,40,"Autoguard : "..config_matrix["auto_guard"])
            gui.text(2,48,"Guard Action : "..config_matrix["guard_action"]) 
            gui.text(2,56,"PB Button : "..config_matrix["push_block_type"])
            gui.text(2,56,"AutoGuard : "..config_matrix["auto_guard"])
        end
        return config_matrix
    end
}

return cheatConfigModule