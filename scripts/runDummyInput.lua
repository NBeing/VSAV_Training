local start_frame = nil 
local current_frame = -1
local frame_counter = 0

local function reset_frames()
    start_frame = nil
    current_frame = nil
end

local function runDummyInput(inputs, numFrames, context, cleanup, should_do_action, do_not_do_if)
    if do_not_do_if == 1 then
        return joypad.get()
    end

	if context == true then
        if start_frame == nil then
            start_frame = globals.game.cur_frame
            current_frame = -1
		end

        current_frame = current_frame + 1 

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

	return keys
end

dummyInputModule = {
    ["registerBefore"] = function()
        return runDummyInput
    end
}
return dummyInputModule