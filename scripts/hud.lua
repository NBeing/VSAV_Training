local function draw_fd()
	mid_width = 23
	mid_height = 47
	if globals.last_fd ~= "" and globals.last_fd ~= nil then
		gui.text( mid_width, mid_height, globals.last_fd)
	end
end
local function draw_rec()
    if globals == nil 
        or globals.macroLua == nil
        or globals.options == nil
    then
		return;
	end
	local recording = globals.macroLua.recording
	local playing = globals.macroLua.playing
	local slot = globals.options.recording_slot - 1

	mid_width =  23
	mid_height = 38
	if recording and playing then
		gui.rect(mid_width - 2, mid_height - 1, mid_width + 125, mid_height + 7, "#ff0000")
		gui.text( mid_width, mid_height, "Slot "..slot..": Recording While Playing")
	elseif recording == true and playing ~= true then
		gui.rect(mid_width - 2, mid_height - 1, mid_width + 68, mid_height + 7, "#ff0000")
		gui.text( mid_width, mid_height, "Slot "..slot..": Recording")
	elseif recording ~= true and playing == true then 
		gui.rect(mid_width - 2, mid_height - 1, mid_width + 65, mid_height + 7, "#00ff00")
		gui.text( mid_width, mid_height, "Slot "..slot..": Playing")
	elseif recording ~= true and playing ~= true then
		gui.rect(mid_width - 2, mid_height - 1, mid_width + 65, mid_height + 7, "#000000")
		gui.text( mid_width, mid_height, "Slot "..slot..": Paused")
	end 
end
local last_tech_success = false

local function draw_pb_counter()
	if globals.options.display_pb_counter == true then
		if globals == nil then return;	end
		local color = "#0000ff"
		if globals.timers.p1_pushblock_counter == 0 then
			color = "#FF0000"
		end

		local x = 21
		local y = 27
		gui.rect(x, y, x+50, y+8, color)
		if globals and globals.timers and globals.timers.p1_pushblock_counter then
			gui.text( x + 2, y + 1, "PB Count: "..globals.timers.p1_pushblock_counter)
		end
	else 
		globals.timers.p1_pushblock_counter = 0
	end
end
local function draw_controlling()
	if globals.controlling_p1 == true then 
		gui.text( 2, 2, "Controlling: P1")
	else 
		gui.text( 2, 2, "Controlling: P2")
	end
end
local hudModule = {
    ["registerStart"] = function()
    end,
    ["guiRegister"] = function()
		draw_fd()
		draw_pb_counter()
		draw_controlling()
		if globals.options.display_recording_gui == true then
			draw_rec()
		end
    end
}
return hudModule