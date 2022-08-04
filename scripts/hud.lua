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
-- This function shows you the length of dashes in frames, and for sasquatch tells you if you got a short or long hop
local function draw_dash_length_trainer()
	if globals.options.display_dash_length_trainer == true then
		local p1_char = util.get_character(0xFF8400)
		local x_location = memory.readdword(0xFF8410)

		local copy_of_table = copytable(globals.dash_length_frames)
		table.sort(copy_of_table, function (left, right) return left < right end)

		local base_x
		if globals.options.display_dash_interval_trainer == false then
			if x_location < 41983616 then
				base_x = 360
			else
				base_x = 10
			end
		end
		if globals.options.display_dash_interval_trainer == true then
			if x_location < 41983616 then
				base_x = 345
			else
				base_x = 45
			end
		end
		local average = 0
		
		for _,item in pairs(globals.dash_length_frames) do average = average + item end
		average = average / #globals.dash_length_frames
		if tostring(average) == "-nan(ind)"  then average = 0 end
		-- gui.text(30, base_airdash , "Time In Dash. Avg:".. math.floor(average))
		for i = #globals.dash_length_frames, 1, -1 do
			local color = "#FFFFFF"
			-- Best!
			if globals.dash_length_frames[i] == copy_of_table[1] then color = "#00FF00" end
			if globals.dash_length_frames[i] == copy_of_table[#copy_of_table] then
				color = "#FF0000" 
			end
			if p1_char == "Sasquatch" then
				if globals.dash_length_frames[i] < 20 then
					gui.text(base_x, 60 + ((#globals.dash_length_frames - i) * 10), ":)", 'green')
				else
					gui.text(base_x, 60 + ((#globals.dash_length_frames - i) * 10), ":(", 'red')				
				end
			else
				gui.text(base_x, 60 + ((#globals.dash_length_frames - i) * 10), globals.dash_length_frames[i], color)
			end
		end
	end
end
-- This function tells you how many frames between each hop, with fewer frames between hops being more optimal
local function draw_dash_trainer()
	if globals.options.display_dash_interval_trainer == true then
		local p1_char = util.get_character(0xFF8400)

		local copy_of_table = copytable(globals.time_between_dashes)
		table.sort(copy_of_table, function (left, right) return left < right end)
		

		local average = 0
		local x_location = memory.readdword(0xFF8410)
		
		for _,item in pairs(globals.time_between_dashes) do average = average + item end
		average = average / #globals.time_between_dashes
		if tostring(average) == "-nan(ind)"  then average = 0 end
		if x_location < 41983616 then
			gui.text(280, 50 , "Time Btw Dashes Avg: ".. math.floor(average))
		else
			gui.text(10, 50 , "Time Btw Dashes Avg: ".. math.floor(average))
		end
		for i = #globals.time_between_dashes, 1, -1 do
			local color = "#FFFFFF"
			if globals.time_between_dashes[i] == copy_of_table[1] then color = "#00FF00" end
			if globals.time_between_dashes[i] == copy_of_table[#copy_of_table] then color = "#FF0000" end
			if globals.time_between_dashes[i] < 2 then color = "#FFD700" end
			if x_location < 41983616 then
				gui.text(310, 60 + ((#globals.time_between_dashes - i) * 10), globals.time_between_dashes[i], color)
			else
				gui.text(10, 60 + ((#globals.time_between_dashes - i) * 10), globals.time_between_dashes[i], color)
			end
		end
	end
end
-- this function creates a counter that tracks how many short hops you can successfully do in a row
local function draw_short_hop_counter()
	if globals.options.display_short_hop_counter == true then
		local p1_char = util.get_character(0xFF8400)

		if  p1_char ~= "Sasquatch"
		then
			return
		end

		local color = "#000000"
		local x = 161
		local y = 53
		local count = 0
		gui.rect(x, y, x+61, y+8, color)
		gui.text( x + 2, y + 1, "Short hops: 0", "#FF0000")
		local copy_of_table = copytable(globals.short_hop_counter)
		table.sort(copy_of_table, function (left, right) return left < right end)

		for i = #globals.short_hop_counter, 1, -1 do
			if globals.short_hop_counter[i] < 20 then
				gui.text( x + 2, y + 1, "Short hops: ".. count + 1, "#00FF00")
				count = count + 1
			else
				return				
			end
		end
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
			if globals.airdash_heights[i] == copy_of_table[1] then color = "#00FF00" end
			if globals.airdash_heights[i] == copy_of_table[#copy_of_table] then
				color = "#FF0000" 
			end
			gui.text(10, base_airdash + 10 + ((#globals.airdash_heights - i) * 10), globals.airdash_heights[i], color)
		end
	end
end
-- This function tracks time between dash startup and cancleing dash with attack
local function draw_dash_cancel_trainer()
	if globals.options.display_dash_attack_cancel_trainer == true then
		local p1_char = util.get_character(0xFF8400)

		local copy_of_table = copytable(globals.time_between_dash_start_attack_start)
		table.sort(copy_of_table, function (left, right) return left < right end)

		local x_location = memory.readdword(0xFF8410)
		local offset_x = 0
		if globals.options.display_attack_dash_gap_trainer == false then
			offset_x = 20
		end
		if x_location < 41983616 then
			gui.text(325 + offset_x, 50 , "C\nA\nT\nK")
		else
			gui.text(10, 50 , "C\nA\nT\nK")
		end
		for i = #globals.time_between_dash_start_attack_start, 1, -1 do
			local color = "#FFFFFF"
			if globals.time_between_dash_start_attack_start[i] == copy_of_table[1] then color = "#00FF00" end
			if globals.time_between_dash_start_attack_start[i] == copy_of_table[#copy_of_table] then
				color = "#FF0000" 
			end
			if x_location < 41983616 then
				gui.text(325 + offset_x, 85 + ((#globals.time_between_dash_start_attack_start - i) * 10), globals.time_between_dash_start_attack_start[i], color)
			else
				gui.text(10, 85 + ((#globals.time_between_dash_start_attack_start - i) * 10), globals.time_between_dash_start_attack_start[i], color)
			end
		end
	end
end
-- This function tracks the gap between attack ending and dash starting
local function draw_dash_link_trainer()
	if globals.options.display_attack_dash_gap_trainer == true then
		local p1_char = util.get_character(0xFF8400)

		local copy_of_table = copytable(globals.time_between_attack_end_dash_start)
		table.sort(copy_of_table, function (left, right) return left < right end)

		local x_location = memory.readdword(0xFF8410)
		local base_x
		if globals.options.display_dash_attack_cancel_trainer == false then
			if x_location < 41983616 then
				base_x = 360
			else
				base_x = 10
			end
		end
		if globals.options.display_dash_attack_cancel_trainer == true then
			if x_location < 41983616 then
				base_x = 345
			else
				base_x = 30
			end
		end

		if globals.options.display_dash_attack_cancel_trainer == false then
				gui.text(base_x, 50 , "D\nG\nA\nP")
			else
				gui.text(base_x, 50 , "D\nG\nA\nP")
			end
		for i = #globals.time_between_attack_end_dash_start, 1, -1 do
			local color = "#FFFFFF"
			if globals.time_between_attack_end_dash_start[i] == copy_of_table[1] then color = "#00FF00" end
			if globals.time_between_attack_end_dash_start[i] == copy_of_table[#copy_of_table] then
				color = "#FF0000" 
			end
			if globals.options.display_dash_attack_cancel_trainer == false then
				gui.text(base_x, 85 + ((#globals.time_between_attack_end_dash_start - i) * 10), globals.time_between_attack_end_dash_start[i], color)
			else
				gui.text(base_x, 85 + ((#globals.time_between_attack_end_dash_start - i) * 10), globals.time_between_attack_end_dash_start[i], color)
			end
		end
	end
end
-- This function checks the frame gaps between a character recovering from hit or block and the next hit or block
local function frame_trap_trainer()
	if globals.options.frame_trap_trainer == true then

		local copy_of_table = copytable(globals.frames_between_attacks)
		table.sort(copy_of_table, function (left, right) return left < right end)

		local average = 0
		local x_location = memory.readdword(0xFF8410)

		if x_location < 41983616 then
			gui.text(310, 50 , "Frame Gap")
		else
			gui.text(10, 50 , "Frame Gap")
		end
		for i = #globals.frames_between_attacks, 1, -1 do
			local color = "#FFFFFF"
			if globals.frames_between_attacks[i] == copy_of_table[1] then color = "#00FF00" end
			if globals.frames_between_attacks[i] == copy_of_table[#copy_of_table] then
				color = "#FF0000" 
			end
			if x_location < 41983616 then
				gui.text(310, 60 + ((#globals.frames_between_attacks - i) * 10), globals.frames_between_attacks[i], color)
			else
				gui.text(10, 60 + ((#globals.frames_between_attacks - i) * 10), globals.frames_between_attacks[i], color)
			end
		end
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
		draw_dash_trainer()
		draw_dash_length_trainer()
		draw_short_hop_counter()
		draw_dash_cancel_trainer()
		draw_dash_link_trainer()
		frame_trap_trainer()
		if globals.options.display_recording_gui == true then
			draw_rec()
		end
    end
}
return hudModule
