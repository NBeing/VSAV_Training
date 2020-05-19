-- Values to write into memory
local auto_guard_addr_1 = 0xFF8BB2
local auto_guard_addr_2 = 0xFF8BE2

autoguardModule = {
    ["registerBefore"] = function()

        if globals.options.auto_guard == 0x1 then
            memory.writebyte(auto_guard_addr_1, 0x1)
            memory.writebyte(auto_guard_addr_2, 0x1)
        else
            memory.writebyte(auto_guard_addr_1, 0x0)
            memory.writebyte(auto_guard_addr_2, 0x0)
        end
    end
}
return autoguardModule