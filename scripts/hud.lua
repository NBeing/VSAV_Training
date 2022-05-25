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
local function draw_airdash_trainer()
	if globals.options.display_airdash_trainer == true then
		local p1_char = util.get_character(0xFF8400)

		if p1_char ~= "Q-Bee" and p1_char ~= "Zabel" and p1_char ~= "Lei-Lei" and p1_char ~= "Jedah" then
			return
		end

		local copy_of_table = copytable(globals.airdash_heights)
		table.sort(copy_of_table, function (left, right) return left < right end)

		local base_airdash = 50
		local average = 0
		
		for _,item in pairs(globals.airdash_heights) do average = average + item end
		average = average / #globals.airdash_heights
		if tostring(average) == "-nan(ind)"  then average = 0 end
		gui.text(10, base_airdash , "IAD Height. Avg:".. math.floor(average))
		for i = #globals.airdash_heights, 1, -1 do
			local color = "#FFFFFF"
			-- Best!
			if globals.airdash_heights[i] == copy_of_table[1] then color = "#00FF00" end
			if globals.airdash_heights[i] == copy_of_table[#copy_of_table] then
				color = "#FF0000" 
			end

			gui.text(10, base_airdash + 10 + ((#globals.airdash_heights - i) * 10), globals.airdash_heights[i], color)
		end

		-- for key = 1, util.tablelength( globals.airdash_heights ) do
		-- 	gui.text(10,base_airdash + (key * 10), globals.airdash_heights[key])
		-- end
	end
end
local function draw_controlling()
	if globals.controlling_p1 == true then 
		gui.text( 1, 1, "Controlling: P1")
	else 
		gui.text( 1, 1, "Controlling: P2")
	end
end
local hudModule = {
    ["registerStart"] = function()
    end,
    ["guiRegister"] = function()
		draw_fd()
		draw_pb_counter()
		draw_controlling()
		draw_airdash_trainer()
		if globals.options.display_recording_gui == true then
			draw_rec()
		end
    end
}
return hudModule