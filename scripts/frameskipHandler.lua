-- Script adapted from dammits work
--https://dammit.typepad.com/blog/2010/03/turbo-speed-frameskip.html
-- https://dammit.typepad.com/blog/2011/05/turbo-speed-frameskip-revisited.html

-- use it as such
-- predictFrameIsSkipped(emu.framecount())

local addr={count=0xFF8109,frame=0xFF810A,}
local full=109 --set timer speed to slow
local old,new={},{}

old.count=memory.readbyte(addr.count)
old.frame=memory.readbyte(addr.frame)
old.skip=old.frame

local frameskipStart = nil
local frameskipPattern = nil
local frameSkipTable = {}
local fs_index = 0 

-- util 
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

-- Create a table for viewing frameskip 
function gatherFrameSkipData(frame , isSkipFrame )
    frameSkipTable[fs_index] = isSkipFrame
    fs_index = fs_index + 1 
end

function predictFrameIsSkipped(frame)
    return (((frame - frameskipStart) - frameskipPattern) % 4) == 0
end

function determineFrameSkipPattern()
    if frameSkipTable[4] == true then
        frameskipPattern = 0
    elseif frameSkipTable[1] == true then
        frameskipPattern = 1
    elseif frameSkipTable[2] == true then
        frameskipPattern = 2
    elseif frameSkipTable[3] == true then
        frameskipPattern = 3
    end
    print("FS pattern", frameskipPattern)        
end
frameskipHandlerModule = {
    ["registerStart"] = function()
        return {
            predictFrameIsSkipped = predictFrameIsSkipped
        }
    end,
    ["registerBefore"] = function()
        -- print(emu.framecount())
        local isSkipFrame = false

        new.count=memory.readbyte(addr.count)
		new.frame=memory.readbyte(addr.frame)

        --don't lose count when the frame count resets
        if old.count>new.count then
            old.frame=old.frame+full
            old.skip=old.skip+full
        else 
            globals.skip_frame = false

        end

        local diff=old.frame-new.frame

        if diff>1 then
            new.skip=new.frame
            isSkipFrame = true
            globals.skip_frame = true
            --subtract 1 because of the lost frame
            -- print(old.skip-new.skip-1)
            old.skip=new.skip
        elseif diff<0 then
            -- print("error: diff =",diff)
        end

        old.count=new.count
        old.frame=new.frame
        if tablelength(frameSkipTable) == 0 then
            frameskipStart = emu.framecount()
        end
        if tablelength(frameSkipTable) < 5 then
            gatherFrameSkipData(emu.framecount(), isSkipFrame)
        end
        if tablelength(frameSkipTable) == 5 and frameskipPattern == nil then
            globals.frameskipReady = true
            determineFrameSkipPattern()
        end
    end
}

return frameskipHandlerModule