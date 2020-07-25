local start_frame = nil 
local current_frame = -1
local prevFrameCount = 0
local frame_counter = 0
local serialize  	    = require './scripts/ser'

local function reset_frames()
    start_frame = nil
    current_frame = nil
end

local function runDummyInput(inputs, numFrames, context, cleanup, should_do_action)
	if context == true then
        if start_frame == nil then
            start_frame = globals.game.cur_frame
            current_frame = -1
		end

        if globals.game.cur_frame > prevFrameCount then
            current_frame = current_frame + 1 
		end

        keys = joypad.get()

        if current_frame <= numFrames then
            if should_do_action == true then
                for _, input in ipairs(inputs[current_frame]) do
					keys[input] = true
                end
			end
		else
           cleanup()
        end
        joypad.set(keys)
    else 
        reset_frames()
    end

    prevFrameCount = globals.game.cur_frame

	return keys
end

dummyInputModule = {
    ["registerBefore"] = function()
        return runDummyInput
    end
}
return dummyInputModule