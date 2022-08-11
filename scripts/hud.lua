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

		local base_x = 0
		local offset_x = 0
		if globals.options.display_dash_interval_trainer == true then
			offset_x = 30
		end

		if x_location < 41983616 then
			base_x = 335
		else
			base_x = 10 + offset_x
		end

		if globals.options.display_dash_attack_cancel_trainer == true or globals.options.display_attack_dash_gap_trainer == true then
			base_x = 335
		end

		gui.text(base_x, 50 , "Dash\nLength")
		for i = #globals.dash_length_frames, 1, -1 do
			local color = "#FFFFFF"
			if globals.dash_length_frames[i] == copy_of_table[1] then color = "#00FF00" end
			if globals.dash_length_frames[i] == copy_of_table[#copy_of_table] then
				color = "#FF0000" 
			end
			if p1_char == "Sasquatch" then
				if globals.dash_length_frames[i] < 20 then
					gui.text(base_x, 80 + ((#globals.dash_length_frames - i) * 10), ":)", 'green')
				else
					gui.text(base_x, 80 + ((#globals.dash_length_frames - i) * 10), ":(", 'red')				
				end
			else
				gui.text(base_x, 80 + ((#globals.dash_length_frames - i) * 10), globals.dash_length_frames[i], color)
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
		
		local x_location = memory.readdword(0xFF8410)

		local base_x = 0
		offset_x = 0
		if globals.options.display_dash_length_trainer == true then
			offset_x = 30
		end

		if x_location < 41983616 then
			base_x = 335 - offset_x
		else
			base_x = 10
		end

		if globals.options.display_dash_attack_cancel_trainer == true or globals.options.display_attack_dash_gap_trainer == true then
			base_x = 305
		end

		gui.text(base_x, 50, "Time\nBTW\nDash")
	
		for i = #globals.time_between_dashes, 1, -1 do
			local color = "#FFFFFF"
			if globals.time_between_dashes[i] == copy_of_table[1] then color = "#00FF00" end
			if globals.time_between_dashes[i] == copy_of_table[#copy_of_table] then color = "#FF0000" end
			if globals.time_between_dashes[i] < 2 then color = "#FFD700" end
			gui.text(base_x, 80 + ((#globals.time_between_dashes - i) * 10), globals.time_between_dashes[i], color)
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

		local base_x = 0
		offset_x = 0
		if globals.options.display_attack_dash_gap_trainer == true then
			offset_x = 30
		end

		if x_location < 41983616 then
			base_x = 335 - offset_x
		else
			base_x = 10
		end

		if globals.options.display_dash_length_trainer == true or globals.options.display_dash_interval_trainer == true then
			base_x = 10
		end


		gui.text(base_x, 50 , "Dash\nATK\nCNCL")
		for i = #globals.time_between_dash_start_attack_start, 1, -1 do
			local color = "#FFFFFF"
			if globals.time_between_dash_start_attack_start[i] == copy_of_table[1] then color = "#00FF00" end
			if globals.time_between_dash_start_attack_start[i] == copy_of_table[#copy_of_table] then
				color = "#FF0000" 
			end
			gui.text(base_x, 85 + ((#globals.time_between_dash_start_attack_start - i) * 10), globals.time_between_dash_start_attack_start[i], color)
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

		local base_x = 0
		offset_x = 0
		if globals.options.display_dash_attack_cancel_trainer == true then
			offset_x = 30
		end

		if x_location < 41983616 then
			base_x = 335
		else
			base_x = 10 + offset_x
		end

		if globals.options.display_dash_length_trainer == true or globals.options.display_dash_interval_trainer == true then
			base_x = 40
		end

		gui.text(base_x, 50 , "Gap\nBTW\nATK\nDash")
		for i = #globals.time_between_attack_end_dash_start, 1, -1 do
			local color = "#FFFFFF"
			if globals.time_between_attack_end_dash_start[i] == copy_of_table[1] then color = "#00FF00" end
			if globals.time_between_attack_end_dash_start[i] == copy_of_table[#copy_of_table] then
				color = "#FF0000" 
			end
			gui.text(base_x, 85 + ((#globals.time_between_attack_end_dash_start - i) * 10), globals.time_between_attack_end_dash_start[i], color)
		end
	end
end
-- This function checks the frame gaps between a character recovering from hit or block and the next hit or block
local function frame_trap_trainer()
	if globals.options.display_frame_trap_trainer == true then

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
local function draw_push_dist()
	if globals and globals.options and not globals.options.show_x_distance or not globals.pushboxes then
		return
	end
	local distance = globals.dummy.distance_between_players
	local pushes = globals.pushboxes

	if not pushes.p1 or not pushes.p2 then
		return
	end

	local on_left = 'p1'

	if pushes.p1.right > pushes.p2.right then
		on_left = 'p2'		
	end 
	
	if on_left == 'p1' then
		gui.line(pushes.p1.right, 150, pushes.p2.left, 150 , "green")
		gui.text((pushes.p1.right), 58,  "X Dist: "..distance)
		
	else
		distance = globals.dummy.distance_between_players
		gui.line(pushes.p2.right, 150, pushes.p1.left, 150 , "green")
		gui.text((pushes.p2.right),  58,  "X Dist: "..distance)
		
	end
end
local function draw_bishamon_ubk_trainer()
	local p1_char = globals.getCharacter(0xFF8400)
	if globals.options.display_bishamon_ubk_trainer == true and p1_char == "Bishamon" then

		local bish_ubk_distance_object = globals.get_bishamon_ubk_ranges_by_char(0xFF8800)
		local distance = globals.dummy.distance_between_players
		local pushes = globals.pushboxes
		if not bish_ubk_distance_object or not distance then
			return
		end
		-- {
		--     charName = "AU",
		--     standingDist  = { startDist = 74, endDist = 88 },
		--     crouchingDist = { startDist = 74, enddist = 90 },
		--     overlapRange  = { startDist = 74, endDist = 88 }, 
		--     length = 14
		-- },
		if bish_ubk_distance_object.notes then
			gui.text(50,50, bish_ubk_distance_object.notes, "#FFC0CB")
		end


		midpt_x = pushes.p2.left + ((pushes.p2.right - pushes.p2.left) / 2) - 18
		midpt_y = pushes.p2.top + ((pushes.p2.bottom - pushes.p2.top) / 2) - 10

		if
			bish_ubk_distance_object.overlapRange and
			bish_ubk_distance_object.overlapRange.startDist and  
			bish_ubk_distance_object.overlapRange.endDist and  
			distance >= bish_ubk_distance_object.overlapRange.startDist and
			distance <= bish_ubk_distance_object.overlapRange.endDist   
		then
			gui.text(midpt_x, midpt_y,  "Both", "green")
			return
		end

		if 
			bish_ubk_distance_object.standingDist and
			bish_ubk_distance_object.standingDist.startDist and  
			bish_ubk_distance_object.standingDist.endDist and  
			distance >= bish_ubk_distance_object.standingDist.startDist and
			distance <= bish_ubk_distance_object.standingDist.endDist  
		then
			gui.text(midpt_x, midpt_y, "Standing", "green")
			return
		end
		if
			bish_ubk_distance_object.crouchingDist and  
			bish_ubk_distance_object.crouchingDist.startDist and  
			bish_ubk_distance_object.crouchingDist.endDist and  
			distance >= bish_ubk_distance_object.crouchingDist.startDist and
			distance <= bish_ubk_distance_object.crouchingDist.endDist   
		then
				gui.text(midpt_x, midpt_y,  "Crouching", "green")
			return
		end
		gui.text(midpt_x, midpt_y,  "NO UBK", "red")
	end
end
local function draw_framecount()
	if globals.options.draw_framecount then
		gui.text(70,1, "Frame: "..emu.framecount(), "red")
	end
end
local function toggle_super_meter()
	if globals.options.hide_super_meter == true then
		memory.writebyte(0xFFF015, 0x00)
	else
		memory.writebyte(0xFFF015, 0x20)
	end
end

local function draw_meaty_trainer()
	if globals.options.show_meaty_trainer then
		if globals.meaty_trainer.last_meaty_succeeded then
			print("got value last meaty succeeded")
			-- gui.text(10,10, globals.meaty_trainer.last_meaty_succeeded)
		end
		if globals.meaty_trainer.last_meaty_succeeded then
			print("got value last meaty succeeded")
			-- gui.text(10,10, globals.meaty_trainer.last_meaty_succeeded)
			-- gui.text(10,30, globals.meaty_trainer.last_p1_hurtbox)
		end
		if globals.meaty_trainer.last_p2_wakeup then
			print("got value")
			gui.text(10,20, globals.meaty_trainer.last_p2_wakeup)
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
-- CSS
local function draw_css_overlay()
	if globals.options.draw_help_info_on_css == true then
		gui.box(8,8,300,42, "black")
		gui.text(
			10,10, 
		"1) Pick P2 To Enter Training Mode. 2) P2 inputs must be set to something\n3) Set Volume Up and Down for Playback / Record in FBNeo Inputs\n4) Press Start to Open Menu 5)Press 4 to return to CSS at any time\n!! Hide this text in the future within the training mode menu !!")
	end
end
-- END CSS
local hudModule = {
    ["registerStart"] = function()
    end,
	["guiRegisterCSS"] = function()
		draw_css_overlay()
	end,
    ["guiRegister"] = function()
		draw_fd()
		draw_pb_counter()
		draw_airdash_trainer()
		draw_dash_trainer()
		draw_dash_length_trainer()
		draw_bishamon_ubk_trainer()
		draw_short_hop_counter()
		draw_dash_cancel_trainer()
		draw_dash_link_trainer()
		frame_trap_trainer()
		draw_push_dist()
		draw_framecount()
		toggle_super_meter()
		draw_meaty_trainer()
		if globals.options.display_recording_gui == true then
			draw_controlling()
			draw_rec()
		end
    end
}
return hudModule
