current_keys = nil
start_frame = nil 
current_frame = -1
prevFrameCount = 0
frame_counter = 0
local serialize  	    = require './scripts/ser'

-- local function cleanup()
--     print("Cleaning up")
-- end
local function reset_frames()
    -- print("Resetting frames start frame and current frame are now nil")
    start_frame = nil
    current_frame = nil
end

local function runDummyInput(inputs, numFrames, context, cleanup, should_do_action)
    -- print(globals.game.cur_frame)
    -- print(inputs, numFrames, context, cleanup, should_do_action)
	if context == true then
        if start_frame == nil then
            start_frame = globals.game.cur_frame
            current_frame = -1
            print("Were starting", "Start frame is", start_frame, "current frame", current_frame)

		end

		if globals.game.cur_frame > prevFrameCount then
            current_frame = current_frame + 1 
            print("Incrementing frame to", current_frame)
		end

        keys = joypad.get()
        print("Cur frame check: " ,current_frame, numFrames)
        if current_frame <= numFrames then
            -- print(inputs)

            print("Executing", current_frame, should_do_action)
            if should_do_action == true then
                print("Ser:", serialize(inputs[current_frame]))
                for _, input in ipairs(inputs[current_frame]) do
                    print("Setting")
					keys[input] = true
                end
			end
		else
           cleanup()
        end
        print("joypad set")
        joypad.set(keys)

    else 
        -- print("Frame reset")
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