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
function gatherFrameSkipData(frame , isNextSkipFrame )
    frameSkipTable[fs_index] = isNextSkipFrame
    fs_index = fs_index + 1 
end
-- When we start gathering data get the current frame 1
local function createFskipDataTable(frame, isNextSkipFrame)
    -- if frame 1 is a nextSkipFrame what happens?
    -- we set 2 to true
    return {
        [frame]     = false,
        [frame + 1] = isNextSkipFrame,
        [frame + 2] = false,
        [frame + 3] = false,
        [frame + 4] = false
    }
end
local function updateFskipDataTable(frame, isNextSkipFrame)
    frameSkipTable[frame + 1] = isNextSkipFrame
end

function predictFrameIsSkipped(frameToPredict)
    -- return (((frame - frameskipStart) - frameskipPattern) % 4) == 0
    -- find how many frames have passed since the frameskip pattern was generated
    local frames_passed_since_fskip_start = frameToPredict - frameskipStart
    -- e.g. if frameskipstarted on frame 20
    -- And it is frame 50
    -- Then 30 frames have passed
    -- If 30 frames have passed, in theory we should be on the same value that 
    -- frameskipstarted was because we cycle every 3?
    -- print("current_frame", frameToPredict)
    -- print("frames_passed_since_fskip_start" , frames_passed_since_fskip_start)
    -- print("frameskipPattern", frameskipPattern)
    local result = ((frames_passed_since_fskip_start - frameskipPattern) % 3) == 0
    -- print("result", result)
    return result
end

function determineFrameSkipPattern()
    -- print("Frameskip start was", frameskipStart)
    -- [ 1 = false , 2 = true,  3 = false, 4 = false, 5 = true ] = pattern 1
    -- [ 1 = false , 2 = false, 3 = true,  4 = false, 5 = false] = pattern 2
    -- [ 1 = false , 2 = false, 3 = false, 4 = true,  5 = false] = pattern 0

    -- [ 58 = false, 59 = false, 60 = false, 61 = true , 62  = false]
    if frameSkipTable[frameskipStart + 3] == true then
        -- print("Pattern 0? ", frameskipStart , frameSkipTable[frameskipStart + 3])
        frameskipPattern = 0
        return
    elseif frameSkipTable[frameskipStart + 1] == true then
        -- print("Pattern 1? ", frameskipStart , frameSkipTable[frameskipStart + 1])

        frameskipPattern = 1
        return
    elseif frameSkipTable[frameskipStart + 2] == true then
        -- print("Pattern 2? ", frameskipStart , frameSkipTable[frameskipStart + 2])

        frameskipPattern = 2
        return
    else
        print("Something got real messed up and ur dumb")
        return
    end

end

frameskipHandlerModule = {
    ["registerStart"] = function()
        return {
            predictFrameIsSkipped = predictFrameIsSkipped
        }
    end,
    ["registerBefore"] = function()
        -- print(emu.framecount())
        if globals.frameskipPattern ~= nil then
            return
        end
        local isNextSkipFrame = memory.readbyte(0xFF8000 + 0x118) ~= 0
        -- [true, false, false] = pattern 0 == means that this is the frame AFTER one was skipped
        -- [false, true, false ] = pattern 1 
        -- [false, false, true ] = pattern 2
        -- Lets say we started the emulator and the frameskip flag was true
        -- We saw that when the frameskip flag is true, the NEXT frame skips
        if fs_index == 0 then
            frameskipStart = emu.framecount()
            frameSkipTable = createFskipDataTable(frameskipStart, isNextSkipFrame)
            -- print(serialize(frameSkipTable))
        end
        if fs_index >= 1 and fs_index < 5 then
            -- updateFskipDataTable(frame, isNextSkipFrame)
            updateFskipDataTable(emu.framecount(), isNextSkipFrame)
            -- print(serialize(frameSkipTable))
        end
        if fs_index == 5 and frameskipPattern == nil then
            globals.frameskipReady = true
            globals.frameskipPattern = frameskipPattern

            determineFrameSkipPattern()
            -- local frameToPredict = emu.framecount() + 1
            
            -- print("Predicting", frameToPredict)
            -- print(predictFrameIsSkipped(frameToPredict))

            -- print("Predicting", frameToPredict + 1)
            -- print(predictFrameIsSkipped(frameToPredict + 1))

            -- print("Predicting", frameToPredict + 2)
            -- print(predictFrameIsSkipped(frameToPredict + 2))

        end
        fs_index = fs_index + 1
    end
}

return frameskipHandlerModule