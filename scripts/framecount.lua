local serialize  	    = require './scripts/ser'

local init_clock = 0
local fc = 0

emu.registerstart(function()
    init_clock = os.clock()
    print("starting at", init_clock)
end)
function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end
local prev_frames = {}
-- This runs every frame
emu.registerbefore(function()
    fc = fc + 1
    if fc % 60 == 0 then 
        local cur_clock = os.clock()
        print("ending at", cur_clock)
        print("It takes this amount of time to run 60 frame", cur_clock - init_clock )
        table.insert(prev_frames, 1, {cur_clock - init_clock})
        fc = 0
        init_clock = cur_clock
    end
    if tablelength(prev_frames) == 6 then
        print(serialize(prev_frames))
    end
end)