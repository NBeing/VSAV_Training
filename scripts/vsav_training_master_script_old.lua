for _,var in ipairs({playbackfile, use_last_recording,
					path,playkey,recordkey,togglepausekey,toggleloopkey,longwait,longpress,longline,framemame, 
					 display_hud, display_movelist, 
					 use_hb_config, hb_config_blank_screen, hb_config_draw_axis, hb_config_draw_pushboxes, hb_config_draw_throwable_boxes, hb_config_no_alpha,
					 mo_enable_frame_data}) do
	var = nil
end
dofile("macro-options.lua", "r") --load the globals
dofile("macro-modules.lua", "r")


------------------------
--Values
------------------------
p2=0x000400

local function projectile_onscreen(hud)
	local color
	if memory.readbyte(0xFF84ac) > 0 then
			color = (0xFF0000FF)
		else
			color = (0x00FF00FF)
		end
return color
end	

--Movelist font color 0xRRBBGGAA Red, Blue, Green, Alpha 
fontcolor1 = (0xffffffff)
fontcolor2 = (0x000000ff)


resourcepath = "scrolling-input" .. "/"
recordpath = "scrolling-input" .. "/"
emu = emu or gens

-------------------------------------------
--General Display
-------------------------------------------

local function hud()
--Player 1
	gui.text(18,16,"Red Life: " .. memory.readword(0xFF8452),0xFF0000FF)
	gui.text(99,16,"White Life: " .. memory.readword(0xFF8450))
	gui.text(34,207,"Meter: ".. memory.readword(0xFF850A))
	gui.text(34,198,"Place: " .. memory.readdword(0xFF8410) .. "," .. memory.readdword(0xFF8414))
	gui.text(0,0,"Taunts: " .. memory.readbyte(0xFF8579))
		
		-- Status
		if memory.readword(0xff854e) == 0x0808 then
		gui.text(18,8,"CURSED " .. memory.readword(0xff8556))
		end
		
		if p1_projectile == true then
		gui.box(60,30,66,34, projectile_onscreen())
		end
		
		-- Darkforce
		if memory.readword(0xFF8510) > 0 then
		gui.text(64,36,"Darkforce timer: " .. memory.readbyte(0xFF8577))
		end
		
		--Tech Hit
		if memory.readbyte(0xff85ab) > 0 then
		gui.text(130,198,"Timer: " .. memory.readbyte(0xff85ab))
		gui.text(130,190,"Mash: " .. memory.readbyte(0xff8570))
		end
		
--Player 2
	gui.text(315,16,"Red Life: " .. memory.readword(0xFF8852),0xFF0000FF)
	gui.text(226,16,"White Life: " .. memory.readword(0xFF8850))
	gui.text(312,207,"Meter: ".. memory.readword(0xFF890A))
	gui.text(260,198,"Place: " .. memory.readdword(0xFF8810) .. "," .. memory.readdword(0xFF8814))
	gui.text(344,0,"Taunts: " .. memory.readbyte(0xFF8979))
		
		-- Status
		if memory.readword(0xff894e) == 0x0808 then
		gui.text(208,198,"CURSED " .. memory.readword(0xff8956))
		
		elseif memory.readword(0xff8846) == 0x4000 then
		gui.text(208,198,"Bubble " .. memory.readword(0xff895c))
		end
		
		if memory.readword(0xFF8910) > 0 then
		gui.text(242,36,"Darkforce timer: " .. memory.readbyte(0xFF8977))
		end
		
		--Tech Hit
		if memory.readbyte(0xff89ab) > 0 then
		gui.text(208,198,"Timer: " .. memory.readbyte(0xff89ab))
		gui.text(208,190,"Mash: " .. memory.readbyte(0xff8970))
		end
end


------------------------------------------------------------------
-- Frame Data by Dammit9x
------------------------------------------------------------------

------------------------------------------------------------------
--Move List
------------------------------------------------------------------

local function movelist()
if memory.readbyte(0xff8782) == 0x00 then
	--Bulleta
	gui.text(58,44,"Smile & Missile (H)",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8700) == 0x00 then
		gui.text(74,52,"4,6 + Punch",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x100 and memory.readbyte(0xFF8704) < 0x3c then
		gui.text(74,52,"4,6 + Punch",0x00FF00FF)
		end
	
		elseif memory.readbyte(0xFF8700) == 0x02 then
		gui.text(74,52,"4",0xFFFF00FF)
		gui.text(78,52,",6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8700) == 0x04 then
		gui.text(74,52,"4",0x00FF00FF)
		gui.text(78,52,",6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8700) == 0x06 then
		gui.text(74,52,"4",0x00FF00FF)
		gui.text(78,52,",6",0xFFFF00FF)
		gui.text(86,52," + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8700) == 0x08 then
		gui.text(74,52,"4,6",0x00FF00FF)
		gui.text(90,52,"+ Punch",fontcolor1,fontcolor2)
		end
	
	gui.text(140,44,"Smile & Missile (L)",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8708) == 0x00 then
		gui.text(156,52,"4,6 + Kick",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x102 and memory.readbyte(0xFF870C) < 0x3c then
		gui.text(156,52,"4,6 + Kick",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8708) == 0x02 then
		gui.text(156,52,"4",0xFFFF00FF)
		gui.text(160,52,",6 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8708) == 0x04 then
		gui.text(156,52,"4",0x00FF00FF)
		gui.text(160,52,",6 + Kick",fontcolor1,fontcolor2)

		elseif memory.readbyte(0xFF8708) == 0x06 then
		gui.text(156,52,"4",0x00FF00FF)
		gui.text(160,52,",6",0xFFFF00FF)
		gui.text(168,52," + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8708) == 0x08 then
		gui.text(156,52,"4,6",0x00FF00FF)
		gui.text(172,52,"+ Kick",fontcolor1,fontcolor2)
		end
	
	gui.text(230,44,"Cheer & Fire",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8711) == 0x00 then
		gui.text(228,52,"6,2,3 + Punch",fontcolor1,fontcolor2)
	
			if memory.readword(0xFF8505) == 0x104 and memory.readbyte(0xFF8714) > 0 then -- To check if move is being done, Added to the middle to make it harder to be a false postive. I need a better special move check.
			gui.text(228,52,"6,2,3 + Punch",0x00FF00FF)
			end
	
		elseif memory.readbyte(0xFF8711) == 0x02 then
		gui.text(228,52,"6",0x00FF00FF)
		gui.text(232,52,",2,3 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8711) == 0x04 then
		gui.text(228,52,"6,2",0x00FF00FF)
		gui.text(240,52,",3 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8711) == 0x06 then
		gui.text(228,52,"6,2,3",0x00FF00FF)
		gui.text(248,52," + Punch",fontcolor1,fontcolor2)
		end

	gui.text(300,44,"Shyness & Strike",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8719) == 0x00 then
		gui.text(306,52,"2,1,4 + Punch",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x106 and memory.readbyte(0xFF871C) > 0 then
		gui.text(306,52,"2,1,4 + Punch",0x00FF00FF)
		end
	
		elseif memory.readbyte(0xFF8719) == 0x02 then
		gui.text(306,52,"2",0x00FF00FF)
		gui.text(310,52,",1,4 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8719) == 0x04 then
		gui.text(306,52,"2,1",0x00FF00FF)
		gui.text(318,52,",4 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8719) == 0x06 then
		gui.text(306,52,"2,1,4",0x00FF00FF)
		gui.text(326,52," + Punch",fontcolor1,fontcolor2)
		end
			
	gui.text(58,64,"Jealousy & Fake",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8741) == 0x00 then
		gui.text(64,72,"6,2,3 + Kick",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x104 and memory.readbyte(0xFF8744) > 0 then
		gui.text(64,72,"6,2,3 + Kick",0x00FF00FF)
		end
	
		elseif memory.readbyte(0xFF8741) == 0x02 then
		gui.text(64,72,"6",0x00FF00FF)
		gui.text(68,72,",2,3 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8741) == 0x04 then
		gui.text(64,72,"6,2",0x00FF00FF)
		gui.text(76,72,",3 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8741) == 0x06 then
		gui.text(64,72,"6,2,3",0x00FF00FF)
		gui.text(84,72," + Kick",fontcolor1,fontcolor2)
		end
	
	gui.text(140,64,"Sentimental Typhoon",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8739) == 0x00 then
		gui.text(148,72,"6,3,2,4 + Punch",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x0110 and memory.readbyte(0xFF873C) > 0 then
		gui.text(148,72,"6,3,2,4 + Punch",0x00FF00FF)
		end
	
		elseif memory.readbyte(0xFF8739) == 0x02 then
		gui.text(148,72,"6",0x00FF00FF)
		gui.text(152,72,",3,2,4 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8739) == 0x04 then
		gui.text(148,72,"6,3",0x00FF00FF)
		gui.text(160,72,",2,4 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8739) == 0x06 then
		gui.text(148,72,"6,3,2",0x00FF00FF)
		gui.text(168,72,",4 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8739) == 0x08 then
		gui.text(148,72,"6,3,2,4",0x00FF00FF)
		gui.text(176,72," + Punch",fontcolor1,fontcolor2)
		end
	
	gui.text(230,64,"Hop & Missile",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8728) == 0x00 then
		gui.text(234,72,"2,8 + Punch",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x010C and memory.readbyte(0xFF872C) > 0 then
		gui.text(234,72,"2,8 + Punch",0x00FF00FF)
		end
	
		elseif memory.readbyte(0xFF8728) == 0x02 then
		gui.text(234,72,"2",0xFFFF00FF)
		gui.text(238,72,",8 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8728) == 0x04 then
		gui.text(234,72,"2",0x00FF00FF)
		gui.text(238,72,",8 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8728) == 0x06 then
		gui.text(234,72,"2",0x00FF00FF)
		gui.text(238,72,",8",0xFFFF00FF)
		gui.text(246,72," + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8728) == 0x08 then
		gui.text(234,72,"2,8",0x00FF00FF)
		gui.text(250,72,"+ Punch",fontcolor1,fontcolor2)
		end
	
	gui.text(300,64,"Cool Hunting",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8749) == 0x00 then
		gui.text(300,72,"4,1,2,3 + PP",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x0114 and memory.readbyte(0xFF874C) > 0 then
		gui.text(300,72,"4,1,2,3 + PP",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8749) == 0x02 then
		gui.text(300,72,"4",0x00FF00FF)
		gui.text(304,72,",1,2,3 + PP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8749) == 0x04 then
		gui.text(300,72,"4,1",0x00FF00FF)
		gui.text(312,72,",2,3 + PP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8749) == 0x06 then
		gui.text(300,72,"4,1,2",0x00FF00FF)
		gui.text(320,72,",3 + PP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8749) == 0x08 then
		gui.text(300,72,"4,1,2,3",0x00FF00FF)
		gui.text(328,72," + PP",fontcolor1,fontcolor2)
		end
	
	gui.text(100,84,"Beautiful Memory",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8731) == 0x00 then
		gui.text(108,92,"4,1,2,3 + KK",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x010E and memory.readbyte(0xFF8734) > 0 then
		gui.text(108,92,"4,1,2,3 + KK",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8731) == 0x02 then
		gui.text(108,92,"4",0x00FF00FF)
		gui.text(112,92,",1,2,3 + KK",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8731) == 0x04 then
		gui.text(108,92,"4,1",0x00FF00FF)
		gui.text(120,92,",2,3 + KK",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8731) == 0x06 then
		gui.text(108,92,"4,1,2",0x00FF00FF)
		gui.text(128,92,",3 + KK",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8731) == 0x08 then
		gui.text(108,92,"4,1,2,3",0x00FF00FF)
		gui.text(136,92," + KK",fontcolor1,fontcolor2)
		end
	
	gui.text(260,84,"Apple For You",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8721) == 0x00 then
		gui.text(262,92,"6,3,2,4 + KK",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x0108 and memory.readbyte(0xFF8724) > 0 then
		gui.text(262,92,"6,3,2,4 + KK",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8721) == 0x02 then
		gui.text(262,92,"6",0x00FF00FF)
		gui.text(266,92,",3,2,4 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x04 then
		gui.text(262,92,"6,3",0x00FF00FF)
		gui.text(274,92,",2,4 + KK",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8721) == 0x06 then
		gui.text(262,92,"6,3,2",0x00FF00FF)
		gui.text(282,92,",4 + KK",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8721) == 0x08 then
		gui.text(262,92,"6,3,2,4",0x00FF00FF)
		gui.text(290,92," + KK",fontcolor1,fontcolor2)
		end
	
	p1_projectile = true
	return

elseif memory.readbyte(0xff8782) == 0x01 then
	--Demitri
	gui.text(58,44,"Chaos Flare",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8701) == 0x00 then
		gui.text(54,52,"2,3,6 + Punch",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x100 and memory.readbyte(0xFF8704) > 0 then
		gui.text(54,52,"2,3,6 + Punch",0x00FF00FF)
		end
	
		elseif memory.readbyte(0xFF8701) == 0x02 then
		gui.text(54,52,"2",0x00FF00FF)
		gui.text(58,52,",3,6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8701) == 0x04 then
		gui.text(54,52,"2,3",0x00FF00FF)
		gui.text(66,52,",6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8701) == 0x06 then
		gui.text(54,52,"2,3,6",0x00FF00FF)
		gui.text(74,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(120,44,"Demon Cradle",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8709) == 0x00 then
		gui.text(118,52,"6,2,3 + Punch",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x104 and memory.readbyte(0xFF870C) > 0 then
		gui.text(118,52,"6,2,3 + Punch",0x00FF00FF)
		end
	
		elseif memory.readbyte(0xFF8709) == 0x02 then
		gui.text(118,52,"6",0x00FF00FF)
		gui.text(122,52,",2,3 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8709) == 0x04 then
		gui.text(118,52,"6,2",0x00FF00FF)
		gui.text(130,52,",3 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8709) == 0x06 then
		gui.text(118,52,"6,2,3",0x00FF00FF)
		gui.text(138,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(186,44,"Bat Spin",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8719) == 0x00 then
		gui.text(178,52,"2,1,4 + Kick",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x10C and memory.readbyte(0xFF871c) > 0 then
		gui.text(178,52,"2,1,4 + Kick",0x00FF00FF)
		end
	
		elseif memory.readbyte(0xFF8719) == 0x02 then
		gui.text(178,52,"2",0x00FF00FF)
		gui.text(182,52,",1,4 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8719) == 0x04 then
		gui.text(178,52,"2,1",0x00FF00FF)
		gui.text(190,52,",4 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8719) == 0x06 then
		gui.text(178,52,"2,1,4",0x00FF00FF)
		gui.text(198,52," + Kick",fontcolor1,fontcolor2)
			
		end
		
	gui.text(232,44,"Negative Stolen",fontcolor1,fontcolor2)
		gui.box(240,52,282,54,0x00000000,0x000000FF)
		gui.text(240,55,"360 + Punch",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8710) == 0x02 then
		gui.box(240,52,250.5,54,0xFF0000FF,0x00000000)
		
		if memory.readword(0xFF8505) == 0x108 and memory.readbyte(0xFF8714) > 0 then
		gui.text(240,55,"360 + Punch",0x00FF00FF)
		end
			
		elseif memory.readbyte(0xFF8710) == 0x04 then
		gui.box(240,52,261,54,0xFFFF00FF,0x00000000)
		
		elseif memory.readbyte(0xFF8710) == 0x06 then
		gui.box(240,52,271.5,54,0xFFFF00FF,0x00000000)
		
		elseif memory.readbyte(0xFF8710) == 0x08 then
		gui.box(240,52,282,54,0x00FF00FF,0x00000000)
		end
	
	gui.text(300,44,"Midnight Bliss",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8729) == 0x00 then
		gui.text(308,52,"2,6,3 + PP",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x110 and memory.readbyte(0xFF872C) > 0 then
		gui.text(308,52,"2,6,3 + PP",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8729) == 0x02 then
		gui.text(308,52,"2",0x00FF00FF)
		gui.text(312,52,",6,3 + PP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8729) == 0x04 then
		gui.text(308,52,"2,6",0x00FF00FF)
		gui.text(320,52,",3 + PP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8729) == 0x06 then
		gui.text(308,52,"2,6,3",0x00FF00FF)
		gui.text(328,52," + PP",fontcolor1,fontcolor2)
		end
	
	gui.text(118,68,"Demon Pillion",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8721) == 0x00 then
		gui.text(124,76,"2,6,3 + KK",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x10E and memory.readbyte(0xFF8724) > 0 then
		gui.text(124,76,"2,6,3 + KK",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8721) == 0x02 then
		gui.text(124,76,"2",0x00FF00FF)
		gui.text(128,76,",6,3 + KK",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8721) == 0x04 then
		gui.text(124,76,"2,6",0x00FF00FF)
		gui.text(136,76,",3 + KK",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8721) == 0x06 then
		gui.text(124,76,"2,6,3",0x00FF00FF)
		gui.text(144,76," + KK",fontcolor1,fontcolor2)
		end
		
	gui.text(228,68,"Midnight Pleasure",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8731) == 0x00 then
		gui.text(236,76,"LP,MP,6,MK,MK",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x114 and memory.readbyte(0xFF8734) > 0 then
		gui.text(236,76,"LP,MP,6,MK,MK",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8731) == 0x02 then
		gui.text(236,76,"LP",0x00FF00FF)
		gui.text(244,76,",MP,6,MK,MK",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8731) == 0x04 then
		gui.text(236,76,"LP,MP",0x00FF00FF)
		gui.text(256,76,",6,MK,MK",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8731) == 0x06 then
		gui.text(236,76,"LP,MP,6",0x00FF00FF)
		gui.text(264,76,",MK,MK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x08 then
		gui.text(236,76,"LP,MP,6,MK,",0x00FF00FF)
		gui.text(280,76,"MK",fontcolor1,fontcolor2)
		end
	
	p1_projectile = true
	return


elseif memory.readbyte(0xff8782) == 0x02 then
	--Gallon
	gui.text(56,44,"Beast Cannon",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8721) == 0x00 then
		gui.text(54,52,"2,3,6 + Punch",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x0108 and memory.readbyte(0xFF8724) > 0 then
		gui.text(54,52,"2,3,6 + Punch",0x00FF00FF)
		end

		elseif memory.readbyte(0xFF8721) == 0x02 then
		gui.text(54,52,"2",0x00FF00FF)
		gui.text(58,52,",3,6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8721) == 0x04 then
		gui.text(54,52,"2,3",0x00FF00FF)
		gui.text(66,52,",6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8721) == 0x06 then
		gui.text(54,52,"2,3,6",0x00FF00FF)
		gui.text(74,52," + Punch",fontcolor1,fontcolor2)
		end

	gui.text(118,44,"Beast Cannon (D)",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8729) == 0x00 then
		gui.text(124,52,"6,2,3 + Punch",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x010A and memory.readbyte(0xFF872C) > 0 then
		gui.text(124,52,"6,2,3 + Punch",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8729) == 0x02 then
		gui.text(124,52,"6",0x00FF00FF)
		gui.text(128,52,",2,3 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8729) == 0x04 then
		gui.text(124,52,"6,2",0x00FF00FF)
		gui.text(136,52,",3 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8729) == 0x06 then
		gui.text(124,52,"6,2,3",0x00FF00FF)
		gui.text(144,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(194,44,"Climb Razor",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8700) == 0x00 then
		gui.text(196,52,"2,8 + Kick",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x0100 and memory.readbyte(0xFF8704) < 0x00 then
		gui.text(196,52,"2,8 + Kick",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8700) == 0x02 then
		gui.text(196,52,"2",0xFFFF00FF)
		gui.text(200,52,",8 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8700) == 0x04 then
		gui.text(196,52,"2",0x00FF00FF)
		gui.text(200,52,",8 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8700) == 0x06 then
		gui.text(196,52,"2",0x00FF00FF)
		gui.text(200,52,",8",0xFFFF00FF)
		gui.text(208,52," + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8700) == 0x08 then
		gui.text(196,52,"2,8",0x00FF00FF)
		gui.text(212,52,"+ Kick",fontcolor1,fontcolor2)
		end
		
	gui.text(248,44,"Million Flicker",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8709) == 0x00 then
		gui.text(252,52,"2,1,4 + Punch",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x0102 and memory.readbyte(0xFF870C) > 0 then
		gui.text(252,52,"2,1,4 + Punch",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8709) == 0x02 then
		gui.text(252,52,"2",0x00FF00FF)
		gui.text(256,52,",1,4 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8709) == 0x04 then
		gui.text(252,52,"2,1",0x00FF00FF)
		gui.text(264,52,",4 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8709) == 0x06 then
		gui.text(252,52,"2,1,4",0x00FF00FF)
		gui.text(272,52," + Punch",fontcolor1,fontcolor2)
		end

	gui.text(318,44,"Wild Circular",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8739) == 0x00 then
		gui.text(316,52,"6,3,2,4 + Kick",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x0114 and memory.readbyte(0xFF873C) > 0 then
		gui.text(316,52,"6,3,2,4 + Kick",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8739) == 0x02 then
		gui.text(316,52,"6",0x00FF00FF)
		gui.text(320,52,",3,2,4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8739) == 0x04 then
		gui.text(316,52,"6,3",0x00FF00FF)
		gui.text(328,52,",2,4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8739) == 0x06 then
		gui.text(316,52,"6,3,2",0x00FF00FF)
		gui.text(336,52,",4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8739) == 0x08 then
		gui.text(316,52,"6,3,2,4",0x00FF00FF)
		gui.text(344,52," + Kick",fontcolor1,fontcolor2)
		end
		
	gui.text(124,64,"Dragon Cannon",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8711) == 0x00 then
		gui.text(126,72,"4,1,2,3 + KK",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x0104 and memory.readbyte(0xFF8714) > 0 then
		gui.text(126,72,"4,1,2,3 + KK",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8711) == 0x02 then
		gui.text(126,72,"4",0x00FF00FF)
		gui.text(130,72,",1,2,3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8711) == 0x04 then
		gui.text(126,72,"4,1",0x00FF00FF)
		gui.text(138,72,",2,3 + KK",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8711) == 0x06 then
		gui.text(126,72,"4,1,2",0x00FF00FF)
		gui.text(146,72,",3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8711) == 0x08 then
		gui.text(126,72,"4,1,2,3",0x00FF00FF)
		gui.text(154,72," + KK",fontcolor1,fontcolor2)
		end
		
	gui.text(254,64,"Moment Slice",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8741) == 0x00 then
		gui.text(252,72,"LP,MP,6,LK,MK",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x0106 and memory.readbyte(0xFF8744) > 0 then
		gui.text(252,72,"LP,MP,6,LK,MK",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8741) == 0x02 then
		gui.text(252,72,"LP",0x00FF00FF)
		gui.text(260,72,",MP,6,LK,MK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8741) == 0x04 then
		gui.text(252,72,"LP,MP",0x00FF00FF)
		gui.text(272,72,",6,LK,MK",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8741) == 0x06 then
		gui.text(252,72,"LP,MP,6",0x00FF00FF)
		gui.text(280,72,",LK,MK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8741) == 0x08 then
		gui.text(252,72,"LP,MP,6,LK",0x00FF00FF)
		gui.text(292,72,",MK",fontcolor1,fontcolor2)
		end
	
	p1_projectile = false
	return

elseif memory.readbyte(0xff8782) == 0x03 then
 	--Victor
	gui.text(58,44,"Mega Shock",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8729) == 0x00 then
		gui.text(54,52,"2,3,6 + Kick",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x010A and memory.readbyte(0xFF872C) > 0 then
		gui.text(54,52,"2,3,6 + Kick",0x00FF00FF)
		end
	
		elseif memory.readbyte(0xFF8729) == 0x02 then
		gui.text(54,52,"2",0x00FF00FF)
		gui.text(58,52,",3,6 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8729) == 0x04 then
		gui.text(54,52,"2,3",0x00FF00FF)
		gui.text(66,52,",6 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8729) == 0x06 then
		gui.text(54,52,"2,3,6",0x00FF00FF)
		gui.text(74,52," + Kick",fontcolor1,fontcolor2)
		end
			
	gui.text(120,44,"Mega Spike",fontcolor1,fontcolor2)
		gui.box(118,52,160,54,0x00000000,0x000000FF)
		gui.text(118,55,"360 + Punch",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8720) == 0x02 then
		gui.box(118,52,128.5,54,0xFF0000FF,0x00000000)
		
		if memory.readword(0xFF8505) == 0x010e and memory.readbyte(0xFF8724) > 0 then
		gui.text(118,55,"360 + Punch",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8720) == 0x04 then
		gui.box(118,52,139,54,0xFFFF00FF,0x00000000)
		
		elseif memory.readbyte(0xFF8720) == 0x06 then
		gui.box(118,52,149.5,54,0xFFFF00FF,0x00000000)
		
		elseif memory.readbyte(0xFF8720) == 0x08 then
		gui.box(118,52,160,54,0x00FF00FF,0x00000000)
		end
	
	gui.text(178,44,"Giga Stake",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8748) == 0x00 then
		gui.text(176,52,"2,8 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0114 and memory.readbyte(0xFF874C) > 0 then
		gui.text(176,52,"2,8 + Punch",0x00FF00FF)
		end

		elseif memory.readbyte(0xFF8748) == 0x02 then
		gui.text(176,52,"2",0xFFFF00FF)
		gui.text(180,52,",8 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8748) == 0x04 then
		gui.text(176,52,"2",0x00FF00FF)
		gui.text(180,52,",8 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8748) == 0x06 then
		gui.text(176,52,"2",0x00FF00FF)
		gui.text(180,52,",8",0xFFFF00FF)
		gui.text(188,52," + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8748) == 0x08 then
		gui.text(176,52,"2,8",0x00FF00FF)
		gui.text(192,52,"+ Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(228,44,"Giga Forehead",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8740) == 0x00 then
		gui.text(232,52,"4,6 + Punch",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x0112 and memory.readbyte(0xFF8744) > 0 then
		gui.text(232,52,"4,6 + Punch",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8740) == 0x02 then
		gui.text(232,52,"4",0xFFFF00FF)
		gui.text(236,52,",6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8740) == 0x04 then
		gui.text(232,52,"4",0x00FF00FF)
		gui.text(236,52,",6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8740) == 0x06 then
		gui.text(232,52,"4",0x00FF00FF)
		gui.text(236,52,",6",0xFFFF00FF)
		gui.text(244,52," + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8740) == 0x08 then
		gui.text(232,52,"4,6",0x00FF00FF)
		gui.text(248,52,"+ Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(300,44,"Giga Burn",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8709) == 0x00 then
		gui.text(294,52,"6,2,3 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0102 and memory.readbyte(0xFF870C) > 0 then
		gui.text(294,52,"6,2,3 + Kick",0x00FF00FF)--0x0102
		end

		elseif memory.readbyte(0xFF8709) == 0x02 then
		gui.text(294,52,"6",0x00FF00FF)
		gui.text(298,52,",2,3 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8709) == 0x04 then
		gui.text(294,52,"6,2",0x00FF00FF)
		gui.text(306,52,",3 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8709) == 0x06 then
		gui.text(294,52,"6,2,3",0x00FF00FF)
		gui.text(314,52," + Kick",fontcolor1,fontcolor2)
		end
		
	gui.text(60,64,"Gyro Crush",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8701) == 0x00 then
		gui.text(54,72,"2,1,4 + Punch",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x0100 and memory.readbyte(0xFF8704) > 0 then
		gui.text(54,72,"2,1,4 + Punch",0x00FF00FF)
		end
	
		elseif memory.readbyte(0xFF8701) == 0x02 then
		gui.text(54,72,"2",0x00FF00FF)
		gui.text(58,72,",1,4 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8701) == 0x04 then
		gui.text(54,72,"2,1",0x00FF00FF)
		gui.text(66,72,",4 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8701) == 0x06 then
		gui.text(54,72,"2,1,4",0x00FF00FF)
		gui.text(74,72," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(172,64,"Thunder Break",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8738) == 0x00 then
		gui.text(182,72,"2,8 + KK",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x0110 and memory.readbyte(0xFF873C) > 0 then
		gui.text(182,72,"2,8 + KK",0x00FF00FF)
		end
	
		elseif memory.readbyte(0xFF8738) == 0x02 then
		gui.text(182,72,"2",0xFFFF00FF)
		gui.text(186,72,",8 + KK",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8738) == 0x04 then
		gui.text(182,72,"2",0x00FF00FF)
		gui.text(186,72,",8 + KK",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8738) == 0x06 then
		gui.text(182,72,"2",0x00FF00FF)
		gui.text(186,72,",8",0xFFFF00FF)
		gui.text(194,72," + KK",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8738) == 0x08 then
		gui.text(182,72,"2,8",0x00FF00FF)
		gui.text(198,72,"+ KK",fontcolor1,fontcolor2)
		end
		
	gui.text(294,64,"Gerdenheim 3",fontcolor1,fontcolor2)
		gui.box(296,72,338,74,0x00000000,0x000000FF)
		gui.text(302,75,"720 + KK",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8758) == 0x02 then
		gui.box(296,72,306.5,74,0xFF0000FF,0x00000000)
		
		if memory.readword(0xFF8505) == 0x0118 and memory.readbyte(0xFF875C) > 0 then
		gui.text(302,75,"720 + KK",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8758) == 0x04 then
		gui.box(296,72,317,74,0xFF8800FF,0x00000000)
		
		elseif memory.readbyte(0xff8758) == 0x06 then
		gui.box(296,72,327.5,74,0xFFFF00FF,0x00000000)
	
		elseif memory.readbyte(0xff8758) == 0x08 then
		gui.box(296,72,338,74,0x00FF00FF,0x00000000)
		
		end

	p1_projectile = false
	return

elseif memory.readbyte(0xff8782) == 0x04 then
	--Zabel
	gui.text(58,44,"Death Hurricane",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8709) == 0x00 then
		gui.text(64,52,"2,1,4 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0102 and memory.readbyte(0xFF870C) > 0 then
		gui.text(64,52,"2,1,4 + Kick",0x00FF00FF)		
		end
		
		elseif memory.readbyte(0xFF8709) == 0x02 then
		gui.text(64,52,"2",0x00FF00FF)
		gui.text(68,52,",1,4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8709) == 0x04 then
		gui.text(64,52,"2,1",0x00FF00FF)
		gui.text(76,52,",4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8709) == 0x06 then
		gui.text(64,52,"2,1,4",0x00FF00FF)
		gui.text(84,52," + Kick",fontcolor1,fontcolor2)
		end
			
	gui.text(130,44,"Skull Sting",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8700) == 0x00 then
		gui.text(132,52,"2,8 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0100 and memory.readbyte(0xFF8704) < 0 then
		gui.text(132,52,"2,8 + Kick",0x00FF00FF)
		end

		elseif memory.readbyte(0xFF8700) == 0x02 then
		gui.text(132,52,"2",0xFFFF00FF)
		gui.text(136,52,",8 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8700) == 0x04 then
		gui.text(132,52,"2",0x00FF00FF)
		gui.text(136,52,",8 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8700) == 0x06 then
		gui.text(132,52,"2",0x00FF00FF)
		gui.text(136,52,",8",0xFFFF00FF)
		gui.text(148,52,"+ Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8700) == 0x08 then
		gui.text(132,52,"2,8",0x00FF00FF)
		gui.text(144,52," + Kick",fontcolor1,fontcolor2)
		end
		
	gui.text(200,44,"Hell Gate",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8729) == 0x00 then
		gui.text(190,52,"4,1,2,3 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010C and memory.readbyte(0xFF872C) > 0 then
		gui.text(190,52,"4,1,2,3 + Kick",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8729) == 0x02 then
		gui.text(190,52,"4",0x00FF00FF)
		gui.text(194,52,",1,2,3 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x04 then
		gui.text(190,52,"4,1",0x00FF00FF)
		gui.text(202,52,",2,3 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x06 then
		gui.text(190,52,"4,1,2",0x00FF00FF)
		gui.text(210,52,",3 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x08 then
		gui.text(190,52,"4,1,2,3",0x00FF00FF)
		gui.text(222,52,"+ Kick",fontcolor1,fontcolor2)
		end
		
	gui.text(260,44,"Death Phrase",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8739) == 0x00 then
		gui.text(260,52,"6,2,3 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0110 and memory.readbyte(0xFF872C) > 0 then
		gui.text(260,52,"6,2,3 + Kick",0x00FF00FF)
		end
				
		elseif memory.readbyte(0xFF8739) == 0x02 then
		gui.text(260,52,"6",0x00FF00FF)
		gui.text(264,52,",2,3 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8739) == 0x04 then
		gui.text(260,52,"6,2",0x00FF00FF)
		gui.text(272,52,",3 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8739) == 0x06 then
		gui.text(260,52,"6,2,3",0x00FF00FF)
		gui.text(280,52," + Kick",fontcolor1,fontcolor2)
		end
		
	gui.text(94,64,"Evil Scream",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8718) == 0x00 then
		gui.text(100,72,"6,4 + PP",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0108 and memory.readbyte(0xFF871C) > 0 then
		gui.text(100,72,"6,4 + PP",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8718) == 0x02 then
		gui.text(100,72,"6",0xFFFF00FF)
		gui.text(104,72,",4 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8718) == 0x04 then
		gui.text(100,72,"6",0x00FF00FF)
		gui.text(104,72,",4 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8718) == 0x06 then
		gui.text(100,72,"6",0x00FF00FF)
		gui.text(104,72,",4",0xFFFF00FF)
		gui.text(112,72," + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8718) == 0x08 then
		gui.text(100,72,"6,4",0x00FF00FF)
		gui.text(112,72," + PP",fontcolor1,fontcolor2)
		end
		
	gui.text(165,64,"Death Voltage",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8711) == 0x00 then
		gui.text(167,72,"6,3,2,4 + KK",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0104 and memory.readbyte(0xFF8714) > 0 then
		gui.text(167,72,"6,3,2,4 + KK",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8711) == 0x02 then
		gui.text(167,72,"6",0x00FF00FF)
		gui.text(171,72,",3,2,4 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8711) == 0x04 then
		gui.text(167,72,"6,3",0x00FF00FF)
		gui.text(179,72,",2,4 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8711) == 0x06 then
		gui.text(167,72,"6,3,2",0x00FF00FF)
		gui.text(187,72,",4 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8711) == 0x08 then
		gui.text(167,72,"6,3,2,4",0x00FF00FF)
		gui.text(195,72," + KK",fontcolor1,fontcolor2)
		end
		
	gui.text(230,64,"Hell Dunk",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8739) == 0x00 then
		gui.text(228,72,"6,2,3 + PP",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010A and memory.readbyte(0xFF873C) > 0 then
		gui.text(228,72,"6,2,3 + PP",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8739) == 0x02 then
		gui.text(228,72,"6",0x00FF00FF)
		gui.text(232,72,",2,3 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8739) == 0x04 then
		gui.text(228,72,"6,2",0x00FF00FF)
		gui.text(240,72,",3 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8739) == 0x06 then
		gui.text(228,72,"6,2,3",0x00FF00FF)
		gui.text(248,72," + PP",fontcolor1,fontcolor2)
		end

	p1_projectile = false
	return

elseif memory.readbyte(0xff8782) == 0x05 then
	--Morrigan
	gui.text(66,44,"Soul Fist",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8709) == 0x00 then
		gui.text(58,52,"2,3,6 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0104 and memory.readbyte(0xFF870C) > 0 or
		memory.readword(0xFF8505) == 0x0106 and memory.readbyte(0xFF870C) > 0 then -- Air Fireball
		gui.text(58,52,"2,3,6 + Punch",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8709) == 0x02 then
		gui.text(58,52,"2",0x00FF00FF)
		gui.text(62,52,",3,6 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8709) == 0x04 then
		gui.text(58,52,"2,3",0x00FF00FF)
		gui.text(70,52,",6 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8709) == 0x06 then
		gui.text(58,52,"2,3,6",0x00FF00FF)
		gui.text(78,52," + Punch",fontcolor1,fontcolor2)
		end
	
	gui.text(122,44,"Shadow Blade",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8719) == 0x00 then
		gui.text(120,52,"6,2,3 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0102 and memory.readbyte(0xFF871C) > 0 then
		gui.text(120,52,"6,2,3 + Punch",0x00FF00FF)
		end		
		
		elseif memory.readbyte(0xFF8719) == 0x02 then
		gui.text(120,52,"6",0x00FF00FF)
		gui.text(124,52,",2,3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8719) == 0x04 then
		gui.text(120,52,"6,2",0x00FF00FF)
		gui.text(132,52,",3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8719) == 0x06 then
		gui.text(120,52,"6,2,3",0x00FF00FF)
		gui.text(140,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(186,44,"Vector Drain",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8721) == 0x00 then
		gui.text(180,52,"6,3,2,4 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010E and memory.readbyte(0xFF8724) > 0 then
		gui.text(180,52,"6,3,2,4 + Punch",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8721) == 0x02 then
		gui.text(180,52,"6",0x00FF00FF)
		gui.text(184,52,",3,2,4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x04 then
		gui.text(180,52,"6,3",0x00FF00FF)
		gui.text(192,52,",2,4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x06 then
		gui.text(180,52,"6,3,2",0x00FF00FF)
		gui.text(200,52,",4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x08 then
		gui.text(180,52,"6,3,2,4",0x00FF00FF)
		gui.text(208,52," + Punch",fontcolor1,fontcolor2)
		end

	gui.text(256,44,"Valkyrie Turn",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8739) == 0x00 then
		gui.text(250,52,"6,3,2,1,4 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010C and memory.readbyte(0xFF873C) > 0 then
		gui.text(250,52,"6,3,2,1,4 + Kick",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8739) == 0x02 then
		gui.text(250,52,"6",0x00FF00FF)
		gui.text(254,52,",3,2,1,4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8739) == 0x04 then
		gui.text(250,52,"6,3",0x00FF00FF)
		gui.text(262,52,",2,1,4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8739) == 0x06 then
		gui.text(250,52,"6,3,2",0x00FF00FF)
		gui.text(270,52,",1,4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8739) == 0x08 then
		gui.text(250,52,"6,3,2,1",0x00FF00FF)
		gui.text(278,52,",4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8739) == 0x0A then
		gui.text(250,52,"6,3,2,1,4",0x00FF00FF)
		gui.text(286,52," + Kick",fontcolor1,fontcolor2)
		end
		
	gui.text(58,64,"Darkness Illusion",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8731) == 0x00 then
		gui.text(66,72,"LP,LP,6,LK,HP",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0108 and memory.readbyte(0xFF8734) > 0 then
		gui.text(66,72,"LP,LP,6,LK,HP",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8731) == 0x02 then
		gui.text(66,72,"LP",0x00FF00FF)
		gui.text(74,72,",LP,6,LK,HP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x04 then
		gui.text(66,72,"LP,LP",0x00FF00FF)
		gui.text(86,72,",6,LK,HP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x06 then
		gui.text(66,72,"LP,LP,6",0x00FF00FF)
		gui.text(94,72,",LK,HP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x08 then
		gui.text(66,72,"LP,LP,6,LK",0x00FF00FF)
		gui.text(106,72,",HP",fontcolor1,fontcolor2)
		end

	gui.text(134,64,"Finishing Shower",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8701) == 0x00 then
		gui.text(140,72,"MP,LP,4,LK,MK",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0100 and memory.readbyte(0xFF8704) > 0 then
		gui.text(140,72,"MP,LP,4,LK,MK",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8701) == 0x02 then
		gui.text(140,72,"MP",0x00FF00FF)
		gui.text(148,72,",LP,4,LK,MK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8701) == 0x04 then
		gui.text(140,72,"MP,LP",0x00FF00FF)
		gui.text(160,72,",4,LK,MK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8701) == 0x06 then
		gui.text(140,72,"MP,LP,4",0x00FF00FF)
		gui.text(168,72,",LK,MK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8701) == 0x08 then
		gui.text(140,72,"MP,LP,4,LK",0x00FF00FF)
		gui.text(180,72,",MK",fontcolor1,fontcolor2)
		end
		
	gui.text(206,64,"Cryptic Needle",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8741) == 0x00 then
		gui.text(210,72,"6,HP,MP,LP,6",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010A and memory.readbyte(0xFF8744) > 0 then
		gui.text(210,72,"6,HP,MP,LP,6",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8741) == 0x02 then
		gui.text(210,72,"6",0x00FF00FF)
		gui.text(214,72,",HP,MP,LP,6",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8741) == 0x04 then
		gui.text(210,72,"6,HP",0x00FF00FF)
		gui.text(226,72,",MP,LP,6",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8741) == 0x06 then
		gui.text(210,72,"6,HP,MP",0x00FF00FF)
		gui.text(238,72,",LP,6",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8741) == 0x08 then
		gui.text(210,72,"6,HP,MP,LP",0x00FF00FF)
		gui.text(250,72,",6",fontcolor1,fontcolor2)
		end	
	
	p1_projectile = true
	return

elseif memory.readbyte(0xff8782) == 0x06 then
	--Anakaris
	gui.text(58,44,"The Dance of Coffins",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8701) == 0x00 then
		gui.text(66,52,"2,2 + Any Attack",fontcolor1,fontcolor2) -- .. memory.readbyte(0xFF8701),fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x0100 and memory.readbyte(0xFF8704) > 0 then
		gui.text(66,52,"2,2 + Any Attack",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8701) == 0x02 then
		gui.text(66,52,"2",0x00FF00FF)
		gui.text(70,52,",2 + Any Attack",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8701) == 0x04 then
		gui.text(66,52,"2,2",0x00FF00FF)
		gui.text(82,52,"+ Any Attack",fontcolor1,fontcolor2)
		end
	
	gui.text(144,44,"Royal Judgement",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8719) == 0x00 then
		gui.text(148,52,"2,3,6 + Punch",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x0106 and memory.readbyte(0xFF871c) > 0 then
		gui.text(148,52,"2,3,6 + Punch",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8719) == 0x02 then
		gui.text(148,52,"2",0x00FF00FF)
		gui.text(152,52,",3,6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8719) == 0x04 then
		gui.text(148,52,"2,3",0x00FF00FF)
		gui.text(160,52,",6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8719) == 0x06 then
		gui.text(148,52,"2,3,6",0x00FF00FF)
		gui.text(168,52," + Punch",fontcolor1,fontcolor2)
		end
			
	gui.text(216,44,"Mummy Drop",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8729) == 0x00 then
		gui.text(210,52,"2,3,6 + Punch",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x010A and memory.readbyte(0xFF871c) > 0 then
		gui.text(210,52,"2,3,6 + Punch",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8729) == 0x02 then
		gui.text(210,52,"2",0x00FF00FF)
		gui.text(214,52,",3,6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8729) == 0x04 then
		gui.text(210,52,"2,3",0x00FF00FF)
		gui.text(222,52,",6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8729) == 0x06 then
		gui.text(210,52,"2,3,6",0x00FF00FF)
		gui.text(230,52," + Punch",fontcolor1,fontcolor2)
		end
	
	gui.text(270,44,"Spell of Turning(Eat)",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8709) == 0x00 then
		gui.text(288,52,"2,1,4 + Kick",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x102 and memory.readbyte(0xFF870c) > 0 then
		gui.text(288,52,"2,1,4 + Kick",0x00FF00FF)
		end
	
		elseif memory.readbyte(0xFF8709) == 0x02 then
		gui.text(288,52,"2",0x00FF00FF)
		gui.text(292,52,",1,4 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8709) == 0x04 then
		gui.text(288,52,"2,1",0x00FF00FF)
		gui.text(300,52,",4 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8709) == 0x06 then
		gui.text(288,52,"2,1,4",0x00FF00FF)
		gui.text(308,52," + Kick",fontcolor1,fontcolor2)
		end
	
	gui.text(270,64,"Spell of Turning(Spit)",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8711) == 0x00 then
		gui.text(288,72,"2,3,6 + Kick",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x104 and memory.readbyte(0xFF8714) > 0 then
		gui.text(288,72,"2,3,6 + Kick",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8711) == 0x02 then
		gui.text(288,72,"2",0x00FF00FF)
		gui.text(292,72,",3,6 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8711) == 0x04 then
		gui.text(288,72,"2,3",0x00FF00FF)
		gui.text(300,72,",6 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8711) == 0x06 then
		gui.text(288,72,"2,3,6",0x00FF00FF)
		gui.text(308,72," + Kick",fontcolor1,fontcolor2)
		end
	
	gui.text(68,64,"Cobra Blow",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8720) == 0x00 then
		gui.text(66,72,"4,6 + Punch",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x108 and memory.readbyte(0xFF8724) > 0 then
		gui.text(66,72,"4,6 + Punch",0x00FF00FF)
		end

		elseif memory.readbyte(0xFF8720) == 0x02 then
		gui.text(66,72,"4",0xFFFF00FF)
		gui.text(70,72,",6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8720) == 0x04 then
		gui.text(66,72,"4",0x00FF00FF)
		gui.text(70,72,",6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8720) == 0x06 then
		gui.text(66,72,"4",0x00FF00FF)
		gui.text(70,72,",6",0xFFFF00FF)
		gui.text(78,72," + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8720) == 0x08 then
		gui.text(66,72,"4,6",0x00FF00FF)
		gui.text(82,72,"+ Punch",fontcolor1,fontcolor2)
		end
	
	gui.text(118,64,"The Word of Truth",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8731) == 0x00 then
		gui.text(128,72,"6,2,3 + PP",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x118 and memory.readbyte(0xFF8734) > 0 then
		gui.text(128,72,"6,2,3 + PP",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8731) == 0x02 then
		gui.text(128,72,"6",0x00FF00FF)
		gui.text(132,72,",2,3 + PP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8731) == 0x04 then
		gui.text(128,72,"6,2",0x00FF00FF)
		gui.text(140,72,",3 + PP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8731) == 0x06 then
		gui.text(128,72,"6,2,3",0x00FF00FF)
		gui.text(148,72," + PP",fontcolor1,fontcolor2)
		end
	
	gui.text(196,64,"The Pit of Blame",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8751) == 0x00 then
		gui.text(208,72,"6,2,3 + Kick",fontcolor1,fontcolor2)

		if memory.readword(0xFF8505) == 0x0116 and memory.readbyte(0xFF8754) > 0 then
		gui.text(208,72,"6,2,3 + Kick",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8751) == 0x02 then
		gui.text(208,72,"6",0x00FF00FF)
		gui.text(212,72,",2,3 + Kick",fontcolor1,fontcolor2)

		elseif memory.readbyte(0xFF8751) == 0x04 then
		gui.text(208,72,"6,2",0x00FF00FF)
		gui.text(220,72,",3 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8751) == 0x06 then
		gui.text(208,72,"6,2,3",0x00FF00FF)
		gui.text(228,72," + Kick",fontcolor1,fontcolor2)
		end
	
	gui.text(56,82,"The Pit to the Underworld",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8739) == 0x00 then
		gui.text(78,90,"4,1,2,3 + Kick",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x010E and memory.readbyte(0xFF873C) > 0 then
		gui.text(78,90,"4,1,2,3 + Kick",0x00FF00FF)
		end	
	
		elseif memory.readbyte(0xFF8739) == 0x02 then
		gui.text(78,90,"4",0x00FF00FF)
		gui.text(82,90,",1,2,3 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8739) == 0x04 then
		gui.text(78,90,"4,1",0x00FF00FF)
		gui.text(90,90,",2,3 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8739) == 0x06 then
		gui.text(78,90,"4,1,2",0x00FF00FF)
		gui.text(98,90,",3 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8739) == 0x08 then
		gui.text(78,90,"4,1,2,3",0x00FF00FF)
		gui.text(106,90," + Kick",fontcolor1,fontcolor2)
		end
	
	gui.text(162,82,"Pharaoh Magic",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8741) == 0x00 then
		gui.text(162,90,"MK,LP,2,LK,MP",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x0110 and memory.readbyte(0xFF8744) > 0 then
		gui.text(162,90,"MK,LP,2,LK,MP",0x00FF00FF)
		end	
	
		elseif memory.readbyte(0xFF8741) == 0x02 then
		gui.text(162,90,"MK",0x00FF00FF)
		gui.text(170,90,",LP,2,LK,MP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8741) == 0x04 then
		gui.text(162,90,"MK,LP",0x00FF00FF)
		gui.text(182,90,",2,LK,MP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8741) == 0x06 then
		gui.text(162,90,"MK,LP,2",0x00FF00FF)
		gui.text(190,90,",LK,MP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8741) == 0x08 then
		gui.text(162,90,"MK,LP,2,LK",0x00FF00FF)
		gui.text(202,90,",MP",fontcolor1,fontcolor2)
		end
	
	gui.text(220,82,"Pharaoh Salvation",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8749) == 0x00 then
		gui.text(228,90,"HK,MP,2,MK,HP",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x0114 and memory.readbyte(0xFF874C) > 0 then
		gui.text(228,90,"HK,MP,2,MK,HP",0x00FF00FF)
		end

		elseif memory.readbyte(0xFF8749) == 0x02 then
		gui.text(228,90,"HK",0x00FF00FF)
		gui.text(236,90,",MP,2,MK,HP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8749) == 0x04 then
		gui.text(228,90,"HK,MP",0x00FF00FF)
		gui.text(248,90,",2,MK,HP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8749) == 0x06 then
		gui.text(228,90,"HK,MP,2",0x00FF00FF)
		gui.text(256,90,",MK,HP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8749) == 0x08 then
		gui.text(228,90,"HK,MP,2,MK",0x00FF00FF)
		gui.text(268,90,",HP",fontcolor1,fontcolor2)
		end

	gui.text(296,82,"Pharaoh Decoration",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8759) == 0x00 then
		gui.text(294,90,"HK,MP,LK,2,LP,MK,HP",fontcolor1,fontcolor2)
	
		if memory.readword(0xFF8505) == 0x011C and memory.readbyte(0xFF875C) > 0 then
		gui.text(294,90,"HK,MP,LK,2,LP,MK,HP",0x00FF00FF)
		end
	
		elseif memory.readbyte(0xFF8759) == 0x02 then
		gui.text(294,90,"HK",0x00FF00FF)
		gui.text(302,90,",MP,LK,2,LP,MK,HP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8759) == 0x04 then
		gui.text(294,90,"HK,MP",0x00FF00FF)
		gui.text(314,90,",LK,2,LP,MK,HP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8759) == 0x06 then
		gui.text(294,90,"HK,MP,LK",0x00FF00FF)
		gui.text(326,90,",2,LP,MK,HP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8759) == 0x08 then
		gui.text(294,90,"HK,MP,LK,2",0x00FF00FF)
		gui.text(334,90,",LP,MK,HP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8759) == 0x0A then
		gui.text(294,90,"HK,MP,LK,2,LP",0x00FF00FF)
		gui.text(346,90,",MK,HP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8759) == 0x0C then
		gui.text(294,90,"HK,MP,LK,2,LP,MK",0x00FF00FF)
		gui.text(358,90,",HP",fontcolor1,fontcolor2)
		end
	
	p1_projectile = true
	return

elseif memory.readbyte(0xff8782) == 0x07 then
	--Felicia
	gui.text(58,44,"Rolling Bunkler",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8709) == 0x00 then
		gui.text(62,52,"2,3,6 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0104 and memory.readbyte(0xFF870C) > 0 then
		gui.text(62,52,"2,3,6 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8709) == 0x02 then
		gui.text(62,52,"2",0x00FF00FF)
		gui.text(66,52,",3,6 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8709) == 0x04 then
		gui.text(62,52,"2,3",0x00FF00FF)
		gui.text(74,52,",6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8709) == 0x06 then
		gui.text(62,52,"2,3,6",0x00FF00FF)
		gui.text(82,52," + Punch",fontcolor1,fontcolor2)
		end
			
	gui.text(132,44,"Cat Spike",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8719) == 0x00 then
		gui.text(126,52,"6,2,3 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0108 and memory.readbyte(0xFF871C) > 0 then
		gui.text(126,52,"6,2,3 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8719) == 0x02 then
		gui.text(126,52,"6",0x00FF00FF)
		gui.text(130,52,",2,3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8719) == 0x04 then
		gui.text(126,52,"6,2",0x00FF00FF)
		gui.text(138,52,",3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8719) == 0x06 then
		gui.text(126,52,"6,2,3",0x00FF00FF)
		gui.text(146,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(192,44,"Delta Kick",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8711) == 0x00 then
		gui.text(188,52,"6,2,3 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0106 and memory.readbyte(0xFF8714) > 0 then
		gui.text(188,52,"6,2,3 + Kick",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8711) == 0x02 then
		gui.text(188,52,"6",0x00FF00FF)
		gui.text(192,52,",2,3 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8711) == 0x04 then
		gui.text(188,52,"6,2",0x00FF00FF)
		gui.text(200,52,",3 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8711) == 0x06 then
		gui.text(188,52,"6,2,3",0x00FF00FF)
		gui.text(208,52," + Kick",fontcolor1,fontcolor2)
		end
		
	gui.text(260,44,"Hell Cat",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8721) == 0x00 then
		gui.text(248,52,"6,3,2,4 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010A and memory.readbyte(0xFF8724) > 0 then
		gui.text(248,52,"6,3,2,4 + Kick",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8721) == 0x02 then
		gui.text(248,52,"6",0x00FF00FF)
		gui.text(252,52,",3,2,4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x04 then
		gui.text(248,52,"6,3",0x00FF00FF)
		gui.text(260,52,",2,4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x06 then
		gui.text(248,52,"6,3,2",0x00FF00FF)
		gui.text(268,52,",4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x08 then
		gui.text(248,52,"6,3,2,4",0x00FF00FF)
		gui.text(276,52," + Kick",fontcolor1,fontcolor2)
		end
		
	gui.text(318,44,"Dancing Flash",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8729) == 0x00 then
		gui.text(320,52,"4,1,2,3 + PP",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010C and memory.readbyte(0xFF872C) > 0 then
		gui.text(320,52,"4,1,2,3 + PP",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8729) == 0x02 then
		gui.text(320,52,"4",0x00FF00FF)
		gui.text(324,52,",1,2,3 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x04 then
		gui.text(320,52,"4,1",0x00FF00FF)
		gui.text(332,52,",2,3 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x06 then
		gui.text(320,52,"4,1,2",0x00FF00FF)
		gui.text(340,52,",3 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x08 then
		gui.text(320,52,"4,1,2,3",0x00FF00FF)
		gui.text(348,52," + PP",fontcolor1,fontcolor2)
		end
		
	gui.text(58,64,"Please Help Me",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8731) == 0x00 then
		gui.text(62,72,"4,1,2,3 + KK",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010E and memory.readbyte(0xFF8734) > 0 then
		gui.text(62,72,"4,1,2,3 + KK",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8731) == 0x02 then
		gui.text(62,72,"4",0x00FF00FF)
		gui.text(66,72,",1,2,3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x04 then
		gui.text(62,72,"4,1",0x00FF00FF)
		gui.text(74,72,",2,3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x06 then
		gui.text(62,72,"4,1,2",0x00FF00FF)
		gui.text(82,72,",3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x08 then
		gui.text(62,72,"4,1,2,3",0x00FF00FF)
		gui.text(90,72," + KK",fontcolor1,fontcolor2)
		end
		
	p1_projectile = true
	return

elseif memory.readbyte(0xff8782) == 0x08 then
	--Bishamon
	gui.text(66,44,"Karame Dama",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8719) == 0x00 then
		gui.text(58,52,"4,1,2,3 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0108 and memory.readbyte(0xFF871C) > 0 then
		gui.text(58,52,"4,1,2,3 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8719) == 0x02 then
		gui.text(58,52,"4",0x00FF00FF)
		gui.text(62,52,",1,2,3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8719) == 0x04 then
		gui.text(58,52,"4,1",0x00FF00FF)
		gui.text(70,52,",2,3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8719) == 0x06 then
		gui.text(58,52,"4,1,2",0x00FF00FF)
		gui.text(78,52,",3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8719) == 0x08 then
		gui.text(58,52,"4,1,2,3",0x00FF00FF)
		gui.text(86,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(130,44,"Tsuji Hayate",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8731) == 0x00 then
		gui.text(128,52,"2,3,6 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0116 and memory.readbyte(0xFF8734) > 0 or
		memory.readword(0xFF8505) == 0x0118 and memory.readbyte(0xFF8734) > 0 then 
		gui.text(128,52,"2,3,6 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8731) == 0x02 then
		gui.text(128,52,"2",0x00FF00FF)
		gui.text(132,52,",3,6 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x04 then
		gui.text(128,52,"2,3",0x00FF00FF)
		gui.text(140,52,",6 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x06 then
		gui.text(128,52,"2,3,6",0x00FF00FF)
		gui.text(148,52," + Punch",fontcolor1,fontcolor2)
		end
	
	gui.text(190,44,"Iai Giri (H)",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8708) == 0x00 then
		gui.text(194,52,"4,6 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0102 and memory.readbyte(0xFF870C) > 0 then
		gui.text(194,52,"4,6 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8708) == 0x02 then
		gui.text(194,52,"4",0xFFFF00FF)
		gui.text(198,52,",6 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8708) == 0x04 then
		gui.text(194,52,"4",0x00FF00FF)
		gui.text(198,52,",6 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8708) == 0x06 then
		gui.text(194,52,"4",0x00FF00FF)
		gui.text(198,52,",6",0xFFFF00FF)
		gui.text(206,52," + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8708) == 0x08 then
		gui.text(194,52,"4,6",0x00FF00FF)
		gui.text(206,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(246,44,"Iai Giri (L)",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8710) == 0x00 then
		gui.text(250,52,"4,6 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0104 and memory.readbyte(0xFF8714) > 0 then
		gui.text(250,52,"4,6 + Kick",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8710) == 0x02 then
		gui.text(250,52,"4",0xFFFF00FF)
		gui.text(254,52,",6 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8710) == 0x04 then
		gui.text(250,52,"4",0x00FF00FF)
		gui.text(254,52,",6 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8710) == 0x06 then
		gui.text(250,52,"4",0x00FF00FF)
		gui.text(254,52,",6",0xFFFF00FF)
		gui.text(262,52," + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8710) == 0x08 then
		gui.text(250,52,"4,6",0x00FF00FF)
		gui.text(262,52," + Kick",fontcolor1,fontcolor2)
		end
		
	gui.text(312,44,"Kienzan",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8701) == 0x00 then
		gui.text(300,52,"6,2,3 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0100 and memory.readbyte(0xFF8704) > 0 then
		gui.text(300,52,"6,2,3 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8701) == 0x02 then
		gui.text(300,52,"6",0x00FF00FF)
		gui.text(304,52,",2,3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8701) == 0x04 then
		gui.text(300,52,"6,2",0x00FF00FF)
		gui.text(312,52,",3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8701) == 0x06 then
		gui.text(300,52,"6,2,3",0x00FF00FF)
		gui.text(320,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(58,64,"Kirisute Gomen",fontcolor1,fontcolor2)
		gui.box(64,72,106,74,0x00000000,0x000000FF)
		gui.text(64,75,"360 + Punch",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8720) == 0x02 then
		gui.box(64,72,74.5,74,0xFF0000FF,0x00000000)
		
		if memory.readword(0xFF8505) == 0x010A and memory.readbyte(0xFF8724) > 0 then
		gui.text(64,75,"360 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8720) == 0x04 then
		gui.box(64,72,85,74,0xFFFF00FF,0x00000000)
		
		elseif memory.readbyte(0xFF8720) == 0x06 then
		gui.box(64,72,95.5,74,0xFFFF00FF,0x00000000)
		
		elseif memory.readbyte(0xFF8720) == 0x08 then
		gui.box(64,72,106,74,0x00FF00FF,0x00000000)
		end
		
	gui.text(130,64,"Togakubi Sarashi",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8739) == 0x00 then
		gui.text(148,72,"2,2 + PP",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0112 and memory.readbyte(0xFF873C) > 0 then
		gui.text(148,72,"2,2 + PP",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8739) == 0x02 then
		gui.text(148,72,"2",0x00FF00FF)
		gui.text(152,72,",2 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8739) == 0x04 then
		gui.text(148,72,"2,2",0x00FF00FF)
		gui.text(160,72," + PP",fontcolor1,fontcolor2)
		end
		
	gui.text(200,64,"Oni Kubi Hineri",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8749) == 0x00 then
		gui.text(206,72,"6,3,2,4 + PP",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010C and memory.readbyte(0xFF874C) > 0 then
		gui.text(206,72,"6,3,2,4 + PP",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8749) == 0x02 then
		gui.text(206,72,"6",0x00FF00FF)
		gui.text(210,72,",3,2,4 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8749) == 0x04 then
		gui.text(206,72,"6,3",0x00FF00FF)
		gui.text(218,72,",2,4 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8749) == 0x06 then
		gui.text(206,72,"6,3,2",0x00FF00FF)
		gui.text(226,72,",4 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8749) == 0x08 then
		gui.text(206,72,"6,3,2,4",0x00FF00FF)
		gui.text(234,72," + PP",fontcolor1,fontcolor2)
		end
	
	gui.text(274,64,"Enma Seki",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8741) == 0x00 then
		gui.text(270,72,"4,1,2,3 + KK",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010E and memory.readbyte(0xFF8744) > 0 then
		gui.text(270,72,"4,1,2,3 + KK",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8741) == 0x02 then
		gui.text(270,72,"4",0x00FF00FF)
		gui.text(274,72,",1,2,3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8741) == 0x04 then
		gui.text(270,72,"4,1",0x00FF00FF)
		gui.text(282,72,",2,3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8741) == 0x06 then
		gui.text(270,72,"4,1,2",0x00FF00FF)
		gui.text(290,72,",3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8741) == 0x08 then
		gui.text(270,72,"4,1,2,3",0x00FF00FF)
		gui.text(298,72," + KK",fontcolor1,fontcolor2)
		end
		
	p1_projectile = true
	return

elseif memory.readbyte(0xff8782) == 0x09 then
	--Aulbath
	gui.text(60,44,"Sonic Wave",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8700) == 0x00 then
		gui.text(58,52,"4,6 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0100 and memory.readbyte(0xFF8704) > 0 then
		gui.text(58,52,"4,6 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8700) == 0x02 then
		gui.text(58,52,"4",0xFFFF00FF)
		gui.text(62,52,",6 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8700) == 0x04 then
		gui.text(58,52,"4",0x00FF00FF)
		gui.text(62,52,",6 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8700) == 0x06 then
		gui.text(58,52,"4",0x00FF00FF)
		gui.text(62,52,",6",0xFFFF00FF)
		gui.text(70,52," + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8700) == 0x08 then
		gui.text(58,52,"4,6",0x00FF00FF)
		gui.text(70,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(120,44,"Poison Cloud",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8708) == 0x00 then
		gui.text(124,52,"4,6 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0102 and memory.readbyte(0xFF870C) > 0 then
		gui.text(124,52,"4,6 + Kick",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8708) == 0x02 then
		gui.text(124,52,"4",0xFFFF00FF)
		gui.text(128,52,",6 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8708) == 0x04 then
		gui.text(124,52,"4",0x00FF00FF)
		gui.text(128,52,",6 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8708) == 0x06 then
		gui.text(124,52,"4",0x00FF00FF)
		gui.text(128,52,",6",0xFFFF00FF)
		gui.text(136,52," + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8708) == 0x08 then
		gui.text(124,52,"4,6",0x00FF00FF)
		gui.text(136,52," + Kick",fontcolor1,fontcolor2)
		end
		
	gui.text(184,44,"Cyrstal Lancer",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8711) == 0x00 then
		gui.text(182,52,"6,3,2,4 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0110 and memory.readbyte(0xFF8714) > 0 then
		gui.text(182,52,"6,3,2,4 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8711) == 0x02 then
		gui.text(182,52,"6",0x00FF00FF)
		gui.text(186,52,",3,2,4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8711) == 0x04 then
		gui.text(182,52,"6,3",0x00FF00FF)
		gui.text(194,52,",2,4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8711) == 0x06 then
		gui.text(182,52,"6,3,2",0x00FF00FF)
		gui.text(202,52,",4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8711) == 0x08 then
		gui.text(182,52,"6,3,2,4",0x00FF00FF)
		gui.text(210,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(264,44,"Gems Anger",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8719) == 0x00 then
		gui.text(256,52,"6,3,2,4 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010E and memory.readbyte(0xFF871C) > 0 then
		gui.text(256,52,"6,3,2,4 + Kick",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8719) == 0x02 then
		gui.text(256,52,"6",0x00FF00FF)
		gui.text(260,52,",3,2,4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8719) == 0x04 then
		gui.text(256,52,"6,3",0x00FF00FF)
		gui.text(268,52,",2,4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8719) == 0x06 then
		gui.text(256,52,"6,3,2",0x00FF00FF)
		gui.text(276,52,",4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8719) == 0x08 then
		gui.text(256,52,"6,3,2,4",0x00FF00FF)
		gui.text(284,52," + Kick",fontcolor1,fontcolor2)
		end
		
	gui.text(324,44,"Trick Fish",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8749) == 0x00 then
		gui.text(320,52,"6,2,3 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0112 and memory.readbyte(0xFF874C) > 0 then
		gui.text(320,52,"6,2,3 + Kick",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8749) == 0x02 then
		gui.text(320,52,"6",0x00FF00FF)
		gui.text(324,52,",2,3 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8749) == 0x04 then
		gui.text(320,52,"6,2",0x00FF00FF)
		gui.text(332,52,",3 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8749) == 0x06 then
		gui.text(320,52,"6,2,3",0x00FF00FF)
		gui.text(340,52," + Kick",fontcolor1,fontcolor2)
		end
		
	gui.text(58,64,"Water Jail",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8741) == 0x00 then
		gui.text(58,72,"6,2,3 + PP",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010A and memory.readbyte(0xFF8744) > 0 then
		gui.text(58,72,"6,2,3 + PP",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8741) == 0x02 then
		gui.text(58,72,"6",0x00FF00FF)
		gui.text(62,72,",2,3 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8741) == 0x04 then
		gui.text(58,72,"6,2",0x00FF00FF)
		gui.text(70,72,",3 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8741) == 0x06 then
		gui.text(58,72,"6,2,3",0x00FF00FF)
		gui.text(78,72," + PP",fontcolor1,fontcolor2)
		end
		
	gui.text(112,64,"Aqua Spread(P)",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8729) == 0x00 then
		gui.text(120,72,"6,3,2 + PP",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0106 and memory.readbyte(0xFF872C) > 0 then
		gui.text(120,72,"6,3,2 + PP",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8729) == 0x02 then
		gui.text(120,72,"6",0x00FF00FF)
		gui.text(124,72,",3,2 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x04 then
		gui.text(120,72,"6,3",0x00FF00FF)
		gui.text(132,72,",2 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x06 then
		gui.text(120,72,"6,3,2",0x00FF00FF)
		gui.text(140,72," + PP",fontcolor1,fontcolor2)
		end
		
	gui.text(180,64,"Aqua Spread(K)",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8721) == 0x00 then
		gui.text(188,72,"6,3,2 + KK",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0104 and memory.readbyte(0xFF8724) > 0 then
		gui.text(188,72,"6,3,2 + KK",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8721) == 0x02 then
		gui.text(188,72,"6",0x00FF00FF)
		gui.text(192,72,",3,2 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x04 then
		gui.text(188,72,"6,3",0x00FF00FF)
		gui.text(200,72,",2 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x06 then
		gui.text(188,72,"6,3,2",0x00FF00FF)
		gui.text(208,72," + KK",fontcolor1,fontcolor2)
		end
		
	gui.text(254,64,"Sea Rage",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8739) == 0x00 then
		gui.text(246,72,"4,1,2,3 + PP",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0108 and memory.readbyte(0xFF873C) > 0 then
		gui.text(246,72,"4,1,2,3 + PP",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8739) == 0x02 then
		gui.text(246,72,"4",0x00FF00FF)
		gui.text(250,72,",1,2,3 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8739) == 0x04 then
		gui.text(246,72,"4,1",0x00FF00FF)
		gui.text(258,72,",2,3 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8739) == 0x06 then
		gui.text(246,72,"4,1,2",0x00FF00FF)
		gui.text(266,72,",3 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8739) == 0x08 then
		gui.text(246,72,"4,1,2,3",0x00FF00FF)
		gui.text(274,72," + PP",fontcolor1,fontcolor2)
		end
		
	p1_projectile = true
	return

elseif memory.readbyte(0xff8782) == 0x0A then
	--Sasquatch
	gui.text(68,44,"Big Brunch",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8711) == 0x00 then
		gui.text(58,52,"6,3,2,4 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0110 and memory.readbyte(0xFF8714) > 0 then
		gui.text(58,52,"6,3,2,4 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8711) == 0x02 then
		gui.text(58,52,"6",0x00FF00FF)
		gui.text(62,52,",3,2,4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8711) == 0x04 then
		gui.text(58,52,"6,3",0x00FF00FF)
		gui.text(70,52,",2,4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8711) == 0x06 then
		gui.text(58,52,"6,3,2",0x00FF00FF)
		gui.text(78,52,",4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8711) == 0x08 then
		gui.text(58,52,"6,3,2,4",0x00FF00FF)
		gui.text(86,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(126,44,"Big Swing",fontcolor1,fontcolor2)
		gui.box(124,52,162,54,0x00000000,0x000000FF)
		gui.text(124,55,"360 + Kick",fontcolor1,fontcolor2)
			if memory.readword(0xFF8505) == 0x010C and memory.readbyte(0xFF871C) > 0 then
		gui.text(124,55,"360 + Kick",0x00FF00FF)
		end	
			if memory.readbyte(0xFF8718) == 0x02 then
		gui.box(124,52,133.5,54,0xFF0000FF,0x000000FF)
			
		elseif memory.readbyte(0xFF8718) == 0x04 then
		gui.box(124,52,143,54,0xFF6600FF,0x000000FF)
			
		elseif memory.readbyte(0xFF8718) == 0x06 then
		gui.box(124,52,152.5,54,0xFFFF00FF,0x000000FF)
			
		elseif memory.readbyte(0xFF8718) == 0x08 then
		gui.box(124,52,162,54,0x00FF00FF,0x000000FF)
		end
		
	gui.text(180,44,"Big Typhoon",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8709) == 0x00 then
		gui.text(178,52,"6,2,3 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0108 and memory.readbyte(0xFF870C) > 0 then
		gui.text(178,52,"6,2,3 + Kick",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8709) == 0x02 then
		gui.text(178,52,"6",0x00FF00FF)
		gui.text(182,52,",2,3 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8709) == 0x04 then
		gui.text(178,52,"6,2",0x00FF00FF)
		gui.text(190,52,",3 + Kick",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8709) == 0x06 then
		gui.text(178,52,"6,2,3",0x00FF00FF)
		gui.text(198,52," + Kick",fontcolor1,fontcolor2)
		end
	
	gui.text(240,44,"Big Breath",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8739) == 0x00 then
		gui.text(234,52,"2,3,6 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0100 and memory.readbyte(0xFF873C) > 0 then
		gui.text(234,52,"2,3,6 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8739) == 0x02 then
		gui.text(234,52,"2",0x00FF00FF)
		gui.text(238,52,",3,6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8739) == 0x04 then
		gui.text(234,52,"2,3",0x00FF00FF)
		gui.text(246,52,",6 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8739) == 0x06 then
		gui.text(234,52,"2,3,6",0x00FF00FF)
		gui.text(254,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(302,44,"Big Towers",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8701) == 0x00 then
		gui.text(300,52,"2,2 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0106 and memory.readbyte(0xFF8704) > 0 then
		gui.text(300,52,"2,2 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8701) == 0x02 then
		gui.text(300,52,"2",0x00FF00FF)
		gui.text(304,52,",2 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8701) == 0x04 then
		gui.text(300,52,"2,2",0x00FF00FF)
		gui.text(312,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(68,64,"Big Blow",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8741) == 0x00 then
		gui.text(58,72,"6,2,3 + Punch",fontcolor1,fontcolor2)
			if memory.readword(0xFF8505) == 0x0104 and memory.readbyte(0xFF8744) > 0 then
			gui.text(58,72,"6,2,3 + Punch",0x00FF00FF)
			end	
		elseif memory.readbyte(0xFF8741) == 0x02 then
		gui.text(58,72,"6",0x00FF00FF)
		gui.text(62,72,",2,3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8741) == 0x04 then
		gui.text(58,72,"6,2",0x00FF00FF)
		gui.text(70,72,",3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8741) == 0x06 then
		gui.text(58,72,"6,2,3",0x00FF00FF)
		gui.text(78,72," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(120,64,"Big Sledge",fontcolor1,fontcolor2)
		gui.box(120,72,158,74,0x00000000,0x000000FF)
		gui.text(122,75,"720 + KK",fontcolor1,fontcolor2)
		if memory.readword(0xFF8505) == 0x010E and memory.readbyte(0xFF874C) > 0 then
		gui.text(122,75,"720 + KK",0x00FF00FF)
		end	
		if memory.readbyte(0xFF8748) == 0x02 then
		gui.box(120,72,129.5,74,0xFF0000FF,0x000000FF)
		
		elseif memory.readbyte(0xFF8748) == 0x04 then
		gui.box(120,72,139,74,0xFF0000FF,0x000000FF)
			
		elseif memory.readbyte(0xFF8748) == 0x06 then
		gui.box(120,72,148.5,74,0x44FF00FF,0x000000FF)
			
		elseif memory.readbyte(0xFF8748) == 0x08 then
		gui.box(120,72,158,74,0x00FF00FF,0x000000FF)
		end
		
	gui.text(174,64,"Big Freezer",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8721) == 0x00 then
		gui.text(172,72,"4,1,2,3 + PP",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010A and memory.readbyte(0xFF8724) > 0 then
		gui.text(172,72,"4,1,2,3 + PP",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8721) == 0x02 then
		gui.text(172,72,"4",0x00FF00FF)
		gui.text(176,72,",1,2,3 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x04 then
		gui.text(172,72,"4,1",0x00FF00FF)
		gui.text(184,72,",2,3 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x06 then
		gui.text(172,72,"4,1,2",0x00FF00FF)
		gui.text(192,72,",3 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x08 then
		gui.text(172,72,"4,1,2,3",0x00FF00FF)
		gui.text(200,72," + PP",fontcolor1,fontcolor2)
		
		end

	gui.text(234,64,"Big Eisbahn",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8729) == 0x00 then
		gui.text(232,72,"4,1,2,3 + KK",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0112 and memory.readbyte(0xFF872C) > 0 then
		gui.text(232,72,"4,1,2,3 + KK",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8729) == 0x02 then
		gui.text(232,72,"4",0x00FF00FF)
		gui.text(236,72,",1,2,3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x04 then
		gui.text(232,72,"4,1",0x00FF00FF)
		gui.text(244,72,",2,3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x06 then
		gui.text(232,72,"4,1,2",0x00FF00FF)
		gui.text(252,72,",3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x08 then
		gui.text(232,72,"4,1,2,3",0x00FF00FF)
		gui.text(260,72," + KK",fontcolor1,fontcolor2)
		
		end
		
	gui.text(318,64,"Banana",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8729) == 0x00 then
		gui.text(294,72,"4,1,2,3,6 + Taunt",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0102 and memory.readbyte(0xFF872C) > 0 then
		gui.text(294,72,"4,1,2,3,6 + Taunt",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8729) == 0x02 then
		gui.text(294,72,"4",0x00FF00FF)
		gui.text(298,72,",1,2,3,6 + Taunt",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x04 then
		gui.text(294,72,"4,1",0x00FF00FF)
		gui.text(306,72,",2,3,6 + Taunt",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x06 then
		gui.text(294,72,"4,1,2",0x00FF00FF)
		gui.text(314,72,",3,6 + Taunt",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x08 then
		gui.text(294,72,"4,1,2,3",0x00FF00FF)
		gui.text(322,72,",6 + Taunt",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x0A then
		gui.text(294,72,"4,1,2,3,6",0x00FF00FF)
		gui.text(330,72," + Taunt",fontcolor1,fontcolor2)
		
		end
		
	p1_projectile = true
	return

elseif memory.readbyte(0xff8782) == 0x0C then
	--Q-Bee
	gui.text(78,44,"C>R",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8719) == 0x00 then
		gui.text(58,52,"4,1,2,3 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0106 and memory.readbyte(0xFF871C) > 0 then
		gui.text(58,52,"4,1,2,3 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8719) == 0x02 then
		gui.text(58,52,"4",0x00FF00FF)
		gui.text(62,52,",1,2,3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8719) == 0x04 then
		gui.text(58,52,"4,1",0x00FF00FF)
		gui.text(70,52,",2,3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8719) == 0x06 then
		gui.text(58,52,"4,1,2",0x00FF00FF)
		gui.text(78,52,",3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8719) == 0x08 then
		gui.text(58,52,"4,1,2,3",0x00FF00FF)
		gui.text(86,52," + Punch",fontcolor1,fontcolor2)
		end
	
	gui.text(140,44,"Delta A",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8701) == 0x00 then
		gui.text(130,52,"2,1,4 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0100 and memory.readbyte(0xFF8704) > 0 then
		gui.text(130,52,"2,1,4 + Kick",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8701) == 0x02 then
		gui.text(130,52,"2",0x00FF00FF)
		gui.text(134,52,",1,4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8701) == 0x04 then
		gui.text(130,52,"2,1",0x00FF00FF)
		gui.text(142,52,",4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8701) == 0x06 then
		gui.text(130,52,"2,1,4",0x00FF00FF)
		gui.text(150,52," + Kick",fontcolor1,fontcolor2)
		end
	
	gui.text(204,44,"SxP",fontcolor1,fontcolor2) 
		gui.text(190,52,"Mash Kicks",fontcolor1,fontcolor2)
		-- Box Outlines
		gui.box(190,60,228,63,0x00000000,0x000000FF) --Light
		gui.box(190,64,228,67,0x00000000,0x000000FF) --Medium
		gui.box(190,68,228,71,0x00000000,0x000000FF) --Hard
	--Light
		if memory.readbyte(0xFF870B) == 0x01 then
		gui.box(190,60,199.5,63,0x00ffffFF,0x000000FF)
		
		elseif memory.readbyte(0xFF870B) == 0x02 then
		gui.box(190,60,209,63,0x00ffffFF,0x000000FF)
		
		elseif memory.readbyte(0xFF870B) == 0x03 then
		gui.box(190,60,218.5,63,0x00ffffFF,0x000000FF)
		
		elseif memory.readbyte(0xFF870B) == 0x04 then
		gui.box(190,60,228,63,0x00ffffFF,0x000000FF)
		end
	
	--Medium
		if memory.readbyte(0xFF870D) == 0x01 then
		gui.box(190,64,199.5,67,0xFFff00FF,0x000000FF)
		
		elseif memory.readbyte(0xFF870D) == 0x02 then
		gui.box(190,64,209,67,0xFFff00FF,0x000000FF)
		
		elseif memory.readbyte(0xFF870D) == 0x03 then
		gui.box(190,64,218.5,67,0xFFff00FF,0x000000FF)
		
		elseif memory.readbyte(0xFF870D) == 0x04 then
		gui.box(190,64,228,67,0xFFff00FF,0x000000FF)
		end
	
	--Hard
		if memory.readbyte(0xFF870F) == 0x01 then
		gui.box(190,68,199.5,71,0xFF0000FF,0x000000FF)
		
		elseif memory.readbyte(0xFF870F) == 0x02 then
		gui.box(190,68,209,71,0xFF0000FF,0x000000FF)
		
		elseif memory.readbyte(0xFF870F) == 0x03 then
		gui.box(190,68,218.5,71,0xFF0000FF,0x000000FF)
		
		elseif memory.readbyte(0xFF870F) == 0x04 then
		gui.box(190,68,228,71,0xFF0000FF,0x000000FF)
		end
		
	gui.text(256,44,"R.M.",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8731) == 0x00 then
		gui.text(240,52,"6,2,3 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0110 and memory.readbyte(0xFF8734) > 0 then
		gui.text(240,52,"6,2,3 + Kick",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8731) == 0x02 then
		gui.text(240,52,"6",0x00FF00FF)
		gui.text(244,52,",2,3 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x04 then
		gui.text(240,52,"6,2",0x00FF00FF)
		gui.text(252,52,",3 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x06 then
		gui.text(240,52,"6,2,3",0x00FF00FF)
		gui.text(260,52," + Kick",fontcolor1,fontcolor2)
		
		end
		
	gui.text(322,44,"O.M.",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8711) == 0x00 then
		gui.text(300,52,"6,3,2,4 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0104 and memory.readbyte(0xFF8714) > 0 then
		gui.text(300,52,"6,3,2,4 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8711) == 0x02 then
		gui.text(300,52,"6",0x00FF00FF)
		gui.text(304,52,",3,2,4 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8711) == 0x04 then
		gui.text(300,52,"6,3",0x00FF00FF)
		gui.text(312,52,",2,4 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8711) == 0x06 then
		gui.text(300,52,"6,3,2",0x00FF00FF)
		gui.text(320,52,",4 + Punch",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8711) == 0x08 then
		gui.text(300,52,"6,3,2,4",0x00FF00FF)
		gui.text(328,52," + Punch",fontcolor1,fontcolor2)
	
		end
	
	gui.text(116,64,"QJ",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8721) == 0x00 then
		gui.text(100,72,"6,2,3 + PP",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010A and memory.readbyte(0xFF8724) > 0 then
		gui.text(100,72,"6,2,3 + PP",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8721) == 0x02 then
		gui.text(100,72,"6",0x00FF00FF)
		gui.text(104,72,",2,3 + PP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8721) == 0x04 then
		gui.text(100,72,"6,2",0x00FF00FF)
		gui.text(112,72,",3 + PP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8721) == 0x06 then
		gui.text(100,72,"6,2,3",0x00FF00FF)
		gui.text(120,72," + PP",fontcolor1,fontcolor2)
	
		end
		
	gui.text(280,64,"+B",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8729) == 0x00 then
		gui.text(260,72,"4,1,2,3 + KK",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010C and memory.readbyte(0xFF872C) > 0 then
		gui.text(260,72,"4,1,2,3 + KK",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8729) == 0x02 then
		gui.text(260,72,"4",0x00FF00FF)
		gui.text(264,72,",1,2,3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x04 then
		gui.text(260,72,"4,1",0x00FF00FF)
		gui.text(272,72,",2,3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x06 then
		gui.text(260,72,"4,1,2",0x00FF00FF)
		gui.text(280,72,",3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x08 then
		gui.text(260,72,"4,1,2,3",0x00FF00FF)
		gui.text(288,72," + KK",fontcolor1,fontcolor2)
		end
		
	p1_projectile = true
	return

elseif memory.readbyte(0xff8782) == 0x0D then
	--Lei-Lei
	gui.text(70,44,"Ankihou",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8701) == 0x00 then
		gui.text(58,52,"2,3,6 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0102 and memory.readbyte(0xFF8704) > 0 then
		gui.text(58,52,"2,3,6 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8701) == 0x02 then
		gui.text(58,52,"2",0x00FF00FF)
		gui.text(62,52,",3,6 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8701) == 0x04 then
		gui.text(58,52,"2,3",0x00FF00FF)
		gui.text(70,52,",6 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8701) == 0x06 then
		gui.text(58,52,"2,3,6",0x00FF00FF)
		gui.text(78,52," + Punch",fontcolor1,fontcolor2)
		end
	
	gui.text(128,44,"Henkyouki",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8709) == 0x00 then
		gui.text(120,52,"2,1,4 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0104 and memory.readbyte(0xFF870C) > 0 then
		gui.text(120,52,"2,1,4 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8709) == 0x02 then
		gui.text(120,52,"2",0x00FF00FF)
		gui.text(124,52,",1,4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8709) == 0x04 then
		gui.text(120,52,"2,1",0x00FF00FF)
		gui.text(132,52,",4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8709) == 0x06 then
		gui.text(120,52,"2,1,4",0x00FF00FF)
		gui.text(140,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(190,44,"Senpuubu",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8711) == 0x00 then
		gui.text(180,52,"6,2,3 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0106 and memory.readbyte(0xFF8714) > 0 then
		gui.text(180,52,"6,2,3 + Punch",0x00FF00FF)
		end
		
		elseif memory.readbyte(0xFF8711) == 0x02 then
		gui.text(180,52,"6",0x00FF00FF)
		gui.text(184,52,",2,3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8711) == 0x04 then
		gui.text(180,52,"6,2",0x00FF00FF)
		gui.text(192,52,",3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8711) == 0x06 then
		gui.text(180,52,"6,2,3",0x00FF00FF)
		gui.text(200,52," + Punch",fontcolor1,fontcolor2)
		end
	
	gui.text(250,44,"Houtengeki",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8721) == 0x00 then
		gui.text(240,52,"6,3,2,4 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0108 and memory.readbyte(0xFF8724) > 0 then
		gui.text(240,52,"6,3,2,4 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8721) == 0x02 then
		gui.text(240,52,"6",0x00FF00FF)
		gui.text(244,52,",3,2,4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x04 then
		gui.text(240,52,"6,3",0x00FF00FF)
		gui.text(252,52,",2,4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x06 then
		gui.text(240,52,"6,3,2",0x00FF00FF)
		gui.text(260,52,",4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x08 then
		gui.text(240,52,"6,3,2,4",0x00FF00FF)
		gui.text(268,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(316,44,"Chireitou",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8729) == 0x00 then
		gui.text(310,52,"4,1,2,3 + KK",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010A and memory.readbyte(0xFF872C) > 0 then
		gui.text(310,52,"4,1,2,3 + KK",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8729) == 0x02 then
		gui.text(310,52,"4",0x00FF00FF)
		gui.text(314,52,",1,2,3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x04 then
		gui.text(310,52,"4,1",0x00FF00FF)
		gui.text(322,52,",2,3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x06 then
		gui.text(310,52,"4,1,2",0x00FF00FF)
		gui.text(330,52,",3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x08 then
		gui.text(310,52,"4,1,2,3",0x00FF00FF)
		gui.text(338,52," + KK",fontcolor1,fontcolor2)
		end
		
	gui.text(130,64,"Tenraiha",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8731) == 0x00 then
		gui.text(120,72,"LK,HK,MP,MP,8",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010C and memory.readbyte(0xFF8734) > 0 then
		gui.text(120,72,"LK,HK,MP,MP,8",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8731) == 0x02 then
		gui.text(120,72,"LK",0x00FF00FF)
		gui.text(128,72,",HK,MP,MP,8",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x04 then
		gui.text(120,72,"LK,HK",0x00FF00FF)
		gui.text(140,72,",MP,MP,8",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x06 then
		gui.text(120,72,"LK,HK,MP",0x00FF00FF)
		gui.text(152,72,",MP,8",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x08 then
		gui.text(120,72,"LK,HK,MP,MP",0x00FF00FF)
		gui.text(164,72,",8",fontcolor1,fontcolor2)
		end
		
	gui.text(252,64,"Chuukadan",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8719) == 0x00 then
		gui.text(246,72,"4,1,2,3 + PP",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010E and memory.readbyte(0xFF871C) > 0 then
		gui.text(246,72,"4,1,2,3 + PP",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8719) == 0x02 then
		gui.text(246,72,"4",0x00FF00FF)
		gui.text(250,72,",1,2,3 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8719) == 0x04 then
		gui.text(246,72,"4,1",0x00FF00FF)
		gui.text(258,72,",2,3 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8719) == 0x06 then
		gui.text(246,72,"4,1,2",0x00FF00FF)
		gui.text(266,72,",3 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8719) == 0x08 then
		gui.text(246,72,"4,1,2,3",0x00FF00FF)
		gui.text(274,72," + PP",fontcolor1,fontcolor2)
		end
		
	p1_projectile = true
	return

elseif memory.readbyte(0xff8782) == 0x0E then
	--Lilith
	gui.text(64,44,"Soul Flash",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8701) == 0x00 then
		gui.text(58,52,"2,3,6 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0102 and memory.readbyte(0xFF8704) > 0 or
		memory.readword(0xFF8505) == 0x0104 and memory.readbyte(0xFF8704) > 0 then
		gui.text(58,52,"2,3,6 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8701) == 0x02 then
		gui.text(58,52,"2",0x00FF00FF)
		gui.text(62,52,",3,6 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8701) == 0x04 then
		gui.text(58,52,"2,3",0x00FF00FF)
		gui.text(70,52,",6 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8701) == 0x06 then
		gui.text(58,52,"2,3,6",0x00FF00FF)
		gui.text(78,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(120,44,"Shining Flash",fontcolor1,fontcolor2)
		if memory.readbyte(0xff8711) == 0x00 then
		gui.text(120,52,"6,2,3 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0100 and memory.readbyte(0xFF8714) > 0 then
		gui.text(120,52,"6,2,3 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xff8711) == 0x02 then
		gui.text(120,52,"6",0x00FF00FF)
		gui.text(124,52,",2,3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xff8711) == 0x04 then
		gui.text(120,52,"6,2",0x00FF00FF)
		gui.text(132,52,",3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xff8711) == 0x06 then
		gui.text(120,52,"6,2,3",0x00FF00FF)
		gui.text(140,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(184,44,"Merry Turn",fontcolor1,fontcolor2)
		if memory.readbyte(0xff8719) == 0x00 then
		gui.text(180,52,"2,1,4 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0106 and memory.readbyte(0xFF871C) > 0 then
		gui.text(180,52,"2,1,4 + Kick",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xff8719) == 0x02 then
		gui.text(180,52,"2",0x00FF00FF)
		gui.text(184,52,",1,4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xff8719) == 0x04 then
		gui.text(180,52,"2,1",0x00FF00FF)
		gui.text(192,52,",4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xff8719) == 0x06 then
		gui.text(180,52,"2,1,4",0x00FF00FF)
		gui.text(200,52," + Kick",fontcolor1,fontcolor2)
		end
		
	gui.text(240,44,"Mystic Arrow",fontcolor1,fontcolor2)
		if memory.readbyte(0xff8731) == 0x00 then
		gui.text(234,52,"6,3,2,4 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010C and memory.readbyte(0xFF8734) > 0 then
		gui.text(234,52,"6,3,2,4 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xff8731) == 0x02 then
		gui.text(234,52,"6",0x00FF00FF)
		gui.text(238,52,",3,2,4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xff8731) == 0x04 then
		gui.text(234,52,"6,3",0x00FF00FF)
		gui.text(246,52,",2,4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xff8731) == 0x06 then
		gui.text(234,52,"6,3,2",0x00FF00FF)
		gui.text(254,52,",4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xff8731) == 0x08 then
		gui.text(234,52,"6,3,2,4",0x00FF00FF)
		gui.text(262,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(300,44,"Gloomy Puppet Show",fontcolor1,fontcolor2)
		if memory.readbyte(0xff8741) == 0x00 then
		gui.text(312,52,"4,1,2,3 + KK",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0116 and memory.readbyte(0xFF8744) > 0 then
		gui.text(312,52,"4,1,2,3 + KK",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xff8741) == 0x02 then
		gui.text(312,52,"4",0x00FF00FF)
		gui.text(316,52,",1,2,3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xff8741) == 0x04 then
		gui.text(312,52,"4,1",0x00FF00FF)
		gui.text(324,52,",2,3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xff8741) == 0x06 then
		gui.text(312,52,"4,1,2",0x00FF00FF)
		gui.text(332,52,",3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xff8741) == 0x08 then
		gui.text(312,52,"4,1,2,3",0x00FF00FF)
		gui.text(340,52," + KK",fontcolor1,fontcolor2)
		end
		
	gui.text(120,64,"Splendor Love",fontcolor1,fontcolor2)
		if memory.readbyte(0xff8721) == 0x00 then
		gui.text(126,72,"6,2,3 + KK",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0108 and memory.readbyte(0xFF8724) > 0 then
		gui.text(126,72,"6,2,3 + KK",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xff8721) == 0x02 then
		gui.text(126,72,"6",0x00FF00FF)
		gui.text(130,72,",2,3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xff8721) == 0x04 then
		gui.text(126,72,"6,2",0x00FF00FF)
		gui.text(138,72,",3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xff8721) == 0x06 then
		gui.text(126,72,"6,2,3",0x00FF00FF)
		gui.text(146,72," + KK",fontcolor1,fontcolor2)
		end
		
	gui.text(232,64,"Luminous Illiuson",fontcolor1,fontcolor2)
		if memory.readbyte(0xff8749) == 0x00 then
		gui.text(240,72,"LP,LP,6,LK,HP",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0118 and memory.readbyte(0xFF874C) > 0 then
		gui.text(240,72,"LP,LP,6,LK,HP",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xff8749) == 0x02 then
		gui.text(240,72,"LP",0x00FF00FF)
		gui.text(248,72,",LP,6,LK,HP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xff8749) == 0x04 then
		gui.text(240,72,"LP,LP",0x00FF00FF)
		gui.text(260,72,",6,LK,HP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xff8749) == 0x06 then
		gui.text(240,72,"LP,LP,6",0x00FF00FF)
		gui.text(268,72,",LK,HP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xff8749) == 0x08 then
		gui.text(240,72,"LP,LP,6,LK",0x00FF00FF)
		gui.text(280,72,",HP",fontcolor1,fontcolor2)
		
		end
		
	p1_projectile = true
	return

elseif memory.readbyte(0xff8782) == 0x0F then
	--Jedah
	gui.text(66,44,"Dio Sehga",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8701) == 0x00 then
		gui.text(58,52,"2,3,6 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0100 and memory.readbyte(0xFF8704) > 0 then
		gui.text(58,52,"2,3,6 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8701) == 0x02 then
		gui.text(58,52,"2",0x00FF00FF)
		gui.text(62,52,",3,6 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8701) == 0x04 then
		gui.text(58,52,"2,3",0x00FF00FF)
		gui.text(70,52,",6 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8701) == 0x06 then
		gui.text(58,52,"2,3,6",0x00FF00FF)
		gui.text(78,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(124,44,"Nero Fatica",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8729) == 0x00 then
		gui.text(120,52,"2,1,4 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010C and memory.readbyte(0xFF872C) > 0 then
		gui.text(120,52,"2,1,4 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8729) == 0x02 then
		gui.text(120,52,"2",0x00FF00FF)
		gui.text(124,52,",1,4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x04 then
		gui.text(120,52,"2,1",0x00FF00FF)
		gui.text(132,52,",4 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8729) == 0x06 then
		gui.text(120,52,"2,1,4",0x00FF00FF)
		gui.text(140,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(180,44,"Ira Spinta (A)",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8721) == 0x00 then
		gui.text(180,52,"6,3,2,4 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010A and memory.readbyte(0xFF8724) > 0 then
		gui.text(180,52,"6,3,2,4 + Kick",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8721) == 0x02 then
		gui.text(180,52,"6",0x00FF00FF)
		gui.text(184,52,",3,2,4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x04 then
		gui.text(180,52,"6,3",0x00FF00FF)
		gui.text(192,52,",2,4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x06 then
		gui.text(180,52,"6,3,2",0x00FF00FF)
		gui.text(200,52,",4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8721) == 0x08 then
		gui.text(180,52,"6,3,2,4",0x00FF00FF)
		gui.text(208,52," + Kick",fontcolor1,fontcolor2)
		end
		
	gui.text(254,44,"Splecio",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8709) == 0x00 then
		gui.text(242,52,"6,2,3 + Punch",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0104 and memory.readbyte(0xFF87C) > 0 then
		gui.text(242,52,"6,2,3 + Punch",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8709) == 0x02 then
		gui.text(242,52,"6",0x00FF00FF)
		gui.text(246,52,",2,3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8709) == 0x04 then
		gui.text(242,52,"6,2",0x00FF00FF)
		gui.text(254,52,",3 + Punch",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8709) == 0x06 then
		gui.text(242,52,"6,2,3",0x00FF00FF)
		gui.text(262,52," + Punch",fontcolor1,fontcolor2)
		end
		
	gui.text(306,44,"San Bassale",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8731) == 0x00 then
		gui.text(300,52,"6,3,2,4 + Kick",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0110 and memory.readbyte(0xFF8734) > 0 then
		gui.text(300,52,"6,3,2,4 + Kick",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8731) == 0x02 then
		gui.text(300,52,"6",0x00FF00FF)
		gui.text(304,52,",3,2,4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x04 then
		gui.text(300,52,"6,3",0x00FF00FF)
		gui.text(312,52,",2,4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x06 then
		gui.text(300,52,"6,3,2",0x00FF00FF)
		gui.text(320,52,",4 + Kick",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x08 then
		gui.text(300,52,"6,3,2,4",0x00FF00FF)
		gui.text(328,52," + Kick",fontcolor1,fontcolor2)
		end
		
	gui.text(120,64,"Prova di Servo",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8711) == 0x00 then
		gui.text(124,72,"4,1,2,3 + KK",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0108 and memory.readbyte(0xFF8714) > 0 then
		gui.text(124,72,"4,1,2,3 + KK",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8711) == 0x02 then
		gui.text(124,72,"4",0x00FF00FF)
		gui.text(128,72,",1,2,3 + KK",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8711) == 0x04 then
		gui.text(124,72,"4,1",0x00FF00FF)
		gui.text(136,72,",2,3 + KK",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8711) == 0x06 then
		gui.text(124,72,"4,1,2",0x00FF00FF)
		gui.text(144,72,",3 + KK",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8711) == 0x08 then
		gui.text(124,72,"4,1,2,3",0x00FF00FF)
		gui.text(152,72," + KK",fontcolor1,fontcolor2)
		end
	
	gui.text(240,64,"Finale Rosso",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8719) == 0x00 then
		gui.text(248,72,"2,2 + PP",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x0106 and memory.readbyte(0xFF871C) > 0 then
		gui.text(248,72,"2,2 + PP",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8719) == 0x02 then
		gui.text(248,72,"2",0x00FF00FF)
		gui.text(252,72,",2 + PP",fontcolor1,fontcolor2)
	
		elseif memory.readbyte(0xFF8719) == 0x04 then
		gui.text(248,72,"2,2",0x00FF00FF)
		gui.text(260,72," + PP",fontcolor1,fontcolor2)
		end
	
	p1_projectile = true
	return

end
end

------------------------------------------------------------------
--Special Properties
------------------------------------------------------------------
-- Anak's Food
function ate(special)
	local text
	if memory.readword(0xFF84A6) == 0xFFFF then
		text = "None"
	elseif memory.readword(0xff84a6) == 0x0000 then
		text = "Mine"
	elseif memory.readword(0xff84a6) == 0x0200 then
		text = "Missle"
	elseif memory.readword(0xff84a6) == 0x0401 then
		text = "Chaos Flare"
	elseif memory.readword(0xff84a6) == 0x0B05 then
		text = "Soul Fist"
	elseif memory.readword(0xff84a6) == 0x1206 then
		text = "Royal Judgement"	
	elseif memory.readword(0xff84a6) == 0x1E09 then
		text = "Sonic Wave"	
	-- Lei Lei 0x??0D
	-- Soul Flash 0x??0E
	elseif memory.readword(0xff84a6) == 0x380F then
		text = "Dio Sehga"		
	else
		text = "Unknown"
	end
return text
end

function charaspecfic()
--Anak swallowed projectile.
if memory.readbyte(0xff8782) == 0x06 then
gui.text(34,190,"Ate Projectile: " .. ate())

--Aulbath's Direct Scissors display and check.
elseif memory.readbyte(0xFF8782) == 0x09 and memory.readbyte(0xff87ae) < 0x02 then
gui.text(306,64,"Direct Scissors",fontcolor1,fontcolor2)
		if memory.readbyte(0xFF8731) == 0x00 then
		gui.text(320,72,"2,2 + PP",fontcolor1,fontcolor2)
		
		if memory.readword(0xFF8505) == 0x010C and memory.readbyte(0xFF8734) > 0 then
		gui.text(320,72,"2,2 + PP",0x00FF00FF)
		end	
		
		elseif memory.readbyte(0xFF8731) == 0x02 then
		gui.text(320,72,"2",0x00FF00FF)
		gui.text(324,72,",2 + PP",fontcolor1,fontcolor2)
		
		elseif memory.readbyte(0xFF8731) == 0x04 then
		gui.text(320,72,"2,2",0x00FF00FF)
		gui.text(332,72," + PP",fontcolor1,fontcolor2)
		
		end
	
--Lei Lei projectile, There is nothing at the moment.
--elseif memory.readbyte(0xff8782) == 0x0D then
--gui.text(34,190,"Projectile")


end
end

------------------------------------------------------------------
--Distance Difference
------------------------------------------------------------------

------------------------------------------------------------------
--Scrolling Input Display Originally by Dammit9x
------------------------------------------------------------------

iconfile     = "capcom-8.png"  --file containing the icons to be shown

buffersize   = 12     --how many lines to show
margin_p1x   = 0.1   --space from the top of the screen, in tiles, for player 1
margin_p2x   = 3	 --for player 2
margin_y     = 4.5    --space from the left side of the screen, in tiles
timeout      = 240    --how many idle frames until old lines are cleared on the next input
screenwidth = 356

gamekeys = {
	{ set =
		{ "capcom",              fba,       mame },
		{      "l",           "Left",     "Left" },
		{      "r",          "Right",    "Right" },
		{      "u",             "Up",       "Up" },
		{      "d",           "Down",     "Down" },
		{     "ul"},
		{     "ur"},
		{     "dl"},
		{     "dr"},
		{     "LP",     "Weak Punch", "Button 1" },
		{     "MP",   "Medium Punch", "Button 2" },
		{     "HP",   "Strong Punch", "Button 3" },
		{     "LK",      "Weak Kick", "Button 4" },
		{     "MK",    "Medium Kick", "Button 5" },
		{     "HK",    "Strong Kick", "Button 6" },
		{      "S",          "Start",    "Start" },
	}
}

local recordpath =  "scrolling-input" .. "/" .. "framedump" .. "/" --(relative to resourcepath)

require "gd"
print("Got to require....")
local minimum_tile_size, maximum_tile_size = 8, 8
local icon_size, image_icon_size = minimum_tile_size
local thisframe, lastframe, module, keyset, changed = {}, {}
local margin, recording, display, start, effective_width = {}, true, true
local draw = { [1] = true, [2] = true }
local inp  = { [1] =   {}, [2] =   {} }
local idle = { [1] =    0, [2] =    0 }

for m, scheme in ipairs(gamekeys) do --Detect what set to use.
	if string.find(iconfile:lower(), scheme.set[1]:lower()) then
		module = scheme
		for k, emu in pairs(scheme.set) do --Detect what emulator this is.
			if k > 1 and emu then
				keyset = k
				break
			end
		end
		break
	end
end
if not module then error("There's no module available for " .. iconfile, 0) end
if not keyset then error("The '" .. module.set[1] .. "' module isn't prepared for this emulator.", 0) end

----------------------------------------------------------------------------------------------------
-- image-string conversion functions

local function hexdump_to_string(hexdump)
	local str = ""
	for n = 1, hexdump:len(), 2 do
		str = str .. string.char("0x" .. hexdump:sub(n,n+1))
	end
	return str
end

local function string_to_hexdump(str)
	local hexdump = ""
	for n = 1, str:len() do
		hexdump = hexdump .. string.format("%02X",str:sub(n,n):byte())
	end
	return hexdump
end
--example usage:
--local image = gd.createFromPng("image.png")
--local str = image:pngStr()
--local hexdump = string_to_hexdump(str)

local blank_img_hexdump = 
"89504E470D0A1A0A0000000D49484452000000400000002001030000009853ECC700000003504C5445000000A77A3DDA00" ..
"00000174524E530040E6D8660000000D49444154189563601805F8000001200001BFC1B1A80000000049454E44AE426082"
local blank_img_string = hexdump_to_string(blank_img_hexdump)

----------------------------------------------------------------------------------------------------
-- display functions

local function text(x, y, row)
	gui.text(x, y, module[row][1])
end

local function image(x, y, row)
	if scrolling_input == true then
		gui.gdoverlay(x, y, module[row].img:gdStr())
	end
end

display = image
if not io.open(resourcepath .. iconfile, "rb") then
	print("Icon file " .. iconfile .. " not found.")
	print("Falling back on text mode.")
	display = text
end

local function readimages()
	local scaled_width = icon_size
	if rescale_icons and emu.screenwidth and emu.screenheight then
		scaled_width = icon_size * emu.screenwidth()/emu.screenheight() / (4/3)
	end
	if display == image then
		local sourceimg = gd.createFromPng(resourcepath .. iconfile)
		image_icon_size = sourceimg:sizeX()/2
		for n, key in ipairs(module) do
			key.img = gd.createFromPngStr(blank_img_string)
			gd.copyResampled(key.img, sourceimg, 0, 0, 0,(n-1)*image_icon_size, scaled_width, icon_size, image_icon_size, image_icon_size)
		end
	end
	effective_width = scaled_width
end
readimages()


----------------------------------------------------------------------------------------------------
-- update functions

local function filterinput(p, frame)
	for pressed, state in pairs(joypad.getdown(p)) do --Check current controller state >
		for row, name in pairs(module) do               --but ignore non-gameplay buttons.
			if pressed == name[keyset]
		--Arcade does not distinguish joypads, so inputs must be filtered by "P1" and "P2".
			or pressed == "P" .. p .. " " .. tostring(name[keyset])
		--MAME also has unusual names for the start buttons.
			or pressed == p .. (p == 1 and " Player " or " Players ") .. tostring(name[keyset]) then
				frame[row] = state
				break
			end
		end
	end
end

local function compositeinput(frame)          --Convert individual directions to diagonals.
	for _,dir in pairs({ {1,3,5}, {2,3,6}, {1,4,7}, {2,4,8} }) do --ul, ur, dl, dr
		if frame[dir[1]] and frame[dir[2]] then
			frame[dir[1]], frame[dir[2]], frame[dir[3]] = nil, nil, true
		end
	end
end

local function detectchanges(lastframe, thisframe)
	changed = false
	for key, state in pairs(thisframe) do       --If a key is pressed >
		if lastframe and not lastframe[key] then  --that wasn't pressed last frame >
			changed = true                          --then changes were made.
			break
		end
	end
end

local function updaterecords(player, frame, input)
	if changed then                         --If changes were made >
		if idle[player] < timeout then        --and the player hasn't been idle too long >
			for record = buffersize, 2, -1 do
				input[record] = input[record-1]   --then shift every old record by 1 >
			end
		else
			for record = buffersize, 2, -1 do
				input[record] = nil               --otherwise wipe out the old records.
			end
		end
		idle[player] = 0                      --Reset the idle count >
		input[1] = {}                         --and set current input as record 1 >
		local index = 1
		for row, name in ipairs(module) do    --but the order must not deviate from gamekeys.
			for key, state in pairs(frame) do
				if key == row then
					input[1][index] = row
					index = index+1
					break
				end
			end
		end
	else
		idle[player] = idle[player]+1         --Increment the idle count if nothing changed.
	end
end

-- emu.registerafter(function()
	-- margin[1] = margin_p1x*effective_width
	-- margin[2] = (emu.screenwidth and emu.screenwidth() or screenwidth)  - margin_p2x*effective_width
	-- margin[3] = margin_y*icon_size
	-- for player = 1, 2 do
		-- thisframe = {}
		-- filterinput(player, thisframe)
		-- compositeinput(thisframe)
		-- detectchanges(lastframe[player], thisframe)
		-- updaterecords(player, thisframe, inp[player])
		-- lastframe[player] = thisframe
	-- end
	
-- end)

----------------------------------------------------------------------------------------------------
-- savestate functions

-- if savestate.registersave and savestate.registerload then --registersave/registerload are unavailable in some emus
	-- savestate.registersave(function(slot)
		-- return draw, inp, idle
	-- end)

	-- savestate.registerload(function(slot)
		-- draw, inp, idle = savestate.loadscriptdata(slot)
		-- if type(draw) ~= "table" then draw = { [1] = true, [2] = true } end
		-- if type(inp)  ~= "table" then inp  = { [1] =   {}, [2] =   {} } end
		-- if type(idle) ~= "table" then idle = { [1] =    0, [2] =    0 } end
	-- end)
-- end

--------------------
--Evil Dragon Check
--------------------
function checked()
if memory.readbyte(0xff8b82) == 0x12 then
	error"Why are you using this character? He's exactly the same as regular Gallon"
elseif memory.readbyte(0xff8782) == 0x12 then
	error"Why are you using this character? He's exactly the same as regular Gallon"
end
end

---------------------------------------------------
--Cheats
---------------------------------------------------
function timer()
memory.writebyte(0xff8109, 0x63)
memory.writebyte(0xFF8509, 0x63)
memory.writebyte(0xFF8909, 0x63)
end

function p1life()
if memory.readword(0xff8452) <= 28 then
memory.writeword(0xff8450,0x0090)
memory.writeword(0xff8452,0x0090)
end
end

function p2life()
if memory.readword(0xff8852) <= 28 then
memory.writeword(0xff8850,0x0090)
memory.writeword(0xff8852,0x0090)
end
end

----------------------------------------------------------------------------------------------------
--Main loop
----------------------------------------------------------------------------------------------------
-- while true do
-- gui.register(function()
	-- hud()
	-- projectile_onscreen(hud)
	-- movelist()
	-- charaspecfic()
	-- for player = 1, 2 do
		-- if draw[player] then
			-- for line in pairs(inp[player]) do
				-- for index,row in pairs(inp[player][line]) do
					-- display(margin[player] + (index-1)*effective_width, margin[3] + (line-1)*icon_size, row)
				-- end
			-- end
		-- end
	-- end
-- end)

	-- --cheats
	-- p1life()
	-- p2life()
	-- checked()
	-- timer()
	-- --Pause the script until the next frame
	-- emu.frameadvance()
-- end


print("CPS-2 fighting game hitbox viewer")
print("February 20, 2012")
print("http://code.google.com/p/mame-rr/wiki/Hitboxes")
-- print("Lua hotkey 1: toggle blank screen")
-- print("Lua hotkey 2: toggle object axis")
-- print("Lua hotkey 3: toggle hitbox axis")
-- print("Lua hotkey 4: toggle pushboxes")
-- print("Lua hotkey 5: toggle throwable boxes")

local boxes = {
	      ["vulnerability"] = {color = 0x7777FF, fill = 0x40, outline = 0xFF},
	             ["attack"] = {color = 0xFF0000, fill = 0x40, outline = 0xFF},
	["proj. vulnerability"] = {color = 0x00FFFF, fill = 0x40, outline = 0xFF},
	       ["proj. attack"] = {color = 0xFF66FF, fill = 0x40, outline = 0xFF},
	               ["push"] = {color = 0x00FF00, fill = 0x20, outline = 0xFF},
	           ["tripwire"] = {color = 0xFF66FF, fill = 0x40, outline = 0xFF}, --sfa3
	             ["negate"] = {color = 0xFFFF00, fill = 0x40, outline = 0xFF}, --dstlk, nwarr
	              ["throw"] = {color = 0xFFFF00, fill = 0x40, outline = 0xFF},
	         ["axis throw"] = {color = 0xFFAA00, fill = 0x40, outline = 0xFF}, --sfa, sfa2, nwarr
	          ["throwable"] = {color = 0xF0F0F0, fill = 0x20, outline = 0xFF},
}

local globals = {
	axis_color           = 0xFFFFFFFF,
	blank_color          = 0xFFFFFFFF,
	axis_size            = 12,
	mini_axis_size       = 2,
	blank_screen         = false,
	draw_axis            = true,
	draw_mini_axis       = false,
	draw_pushboxes       = true,
	draw_throwable_boxes = false,
	no_alpha             = false, --fill = 0x00, outline = 0xFF for all box types
	ground_throw_height  = 0x50, --default for sfa & sfa2 if pushbox unavailable
}
if use_hb_config == true then
	globals.blank_screen = hb_config_blank_screen
	globals.draw_axis = hb_config_draw_axis
	globals.draw_pushboxes = hb_config_draw_pushboxes
	globals.draw_throwable_boxes = hb_config_draw_throwable_boxes
	globals.no_alpha = hb_config_no_alpha
end

--------------------------------------------------------------------------------
-- game-specific modules

local rb, rbs, rw, rws, rd = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned, memory.readdword
local any_true, get_thrower, insert_throw, signed_register, define_box, get_x, get_y
local game, frame_buffer, throw_buffer

local profile = {
{	games = {"sfa"},
	number = {players = 3, projectiles = 8},
	address = {
		player      = 0xFF8400,
		projectile  = 0xFF9000,
		screen_left = 0xFF8290,
	},
	offset = {
		object_space = 0x80,
		flip_x       = 0x0B,
		hitbox_ptr   = {player = 0x50, projectile = 0x50},
	},
	friends = {0x0D},
	box = {
		radius_read = rb,
		offset_read = rbs,
		val_x = 0x0, val_y = 0x1, rad_x = 0x2, rad_y = 0x3,
	},
	box_list = {
		{anim_ptr = 0x20, addr_table_ptr = 0x08, p_addr_table_ptr = 0x4, id_ptr = 0x0C, id_shift = 0x2, type = "push"},
		{anim_ptr = 0x20, addr_table_ptr = 0x00, p_addr_table_ptr = 0x0, id_ptr = 0x08, id_shift = 0x2, type = "vulnerability"},
		{anim_ptr = 0x20, addr_table_ptr = 0x02, p_addr_table_ptr = 0x0, id_ptr = 0x09, id_shift = 0x2, type = "vulnerability"},
		{anim_ptr = 0x20, addr_table_ptr = 0x04, p_addr_table_ptr = 0x0, id_ptr = 0x0A, id_shift = 0x2, type = "vulnerability"},
		{anim_ptr = 0x20, addr_table_ptr = 0x08, p_addr_table_ptr = 0x4, id_ptr = 0x0C, id_shift = 0x2, type = "throwable"},
		{anim_ptr = 0x20, addr_table_ptr = 0x06, p_addr_table_ptr = 0x2, id_ptr = 0x0B, id_shift = 0x4, type = "attack"},
	},
	breakpoints = {
		{["sfa"] = 0x020F14, func = function() --ground throws
			insert_throw({
				val_x = signed_register("d0"),
				rad_x = signed_register("d1"),
				type = "throw",
			})
		end},
		{["sfa"] = 0x020FF2, func = function() --air throws
			insert_throw({
				val_x = signed_register("d0"),
				rad_x = signed_register("d1"),
				val_y = signed_register("d2"),
				rad_y = signed_register("d3"),
				type = "axis throw",
			})
		end},
	},
	clones = {
		["sfar3"] = -0xB4, ["sfar2"] = -0x64, ["sfar1"] = -0x18, ["sfad"] = 0, ["sfau"] = -0x64, 
		["sfza"] = -0x64, ["sfzbr1"] = 0, ["sfzb"] = 0x5B4, ["sfzhr1"] = -0x64, ["sfzh"] = -0x18, 
		["sfzjr2"] = -0xB4, ["sfzjr1"] = -0x64, ["sfzj"] = 0, 
	},
	process_throw = function(obj, box)
		box.val_y = box.val_y or obj.val_y or globals.ground_throw_height/2
		box.rad_y = box.rad_y or obj.rad_y or globals.ground_throw_height/2

		box.val_x  = obj.pos_x + box.val_x * obj.flip_x
		box.val_y  = obj.pos_y - box.val_y
		box.left   = box.val_x - box.rad_x
		box.right  = box.val_x + box.rad_x
		box.top    = box.val_y - box.rad_y
		box.bottom = box.val_y + box.rad_y

		return box
	end,
	active = function() return any_true({
		(rd(0xFF8004) == 0x40000 and rd(0xFF8008) == 0x40000),
		(rw(0xFF8008) == 0x2 and rw(0xFF800A) > 0),
	}) end,
	invulnerable = function(obj, box) return any_true({
		rb(obj.base + 0x13B) > 0,
	}) end,
	unthrowable = function(obj, box) return any_true({
		rb(obj.base + 0x241) > 0,
		rw(obj.base + 0x004) ~= 0x200,
		rb(obj.base + 0x02F) > 0,
		bit.band(rd(rd(obj.base + 0x020) + 0x8), 0xFFFFFF00) == 0,
	}) end,
},
{	games = {"sfa2", "sfz2al"},
	number = {players = 3, projectiles = 26},
	address = {
		player      = 0xFF8400,
		projectile  = 0xFF9400,
		screen_left = 0xFF8290,
	},
	offset = {
		object_space = 0x80,
		flip_x       = 0x0B,
		hitbox_ptr   = {player = nil, projectile = 0x60},
	},
	friends = {0x17},
	box_list = {
		{anim_ptr = 0x1C, addr_table_ptr = 0x120, p_addr_table_ptr = 0x4, id_ptr = 0x0C, id_shift = 0x3, type = "push"},
		{anim_ptr = 0x1C, addr_table_ptr = 0x110, p_addr_table_ptr = 0x0, id_ptr = 0x08, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr = 0x1C, addr_table_ptr = 0x114, p_addr_table_ptr = 0x0, id_ptr = 0x09, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr = 0x1C, addr_table_ptr = 0x118, p_addr_table_ptr = 0x0, id_ptr = 0x0A, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr = 0x1C, addr_table_ptr = 0x120, p_addr_table_ptr = 0x4, id_ptr = 0x0C, id_shift = 0x3, type = "throwable"},
		{anim_ptr = 0x1C, addr_table_ptr = 0x11C, p_addr_table_ptr = 0x2, id_ptr = 0x0B, id_shift = 0x5, type = "attack"},
	},
	breakpoints = {
		{["sfa2"] = 0x025516, ["sfz2al"] = 0x025C8A, func = function() --ground throws
			insert_throw({
				val_x = signed_register("d0"),
				rad_x = signed_register("d1"),
				type = "throw",
			})
		end},
		{["sfa2"] = 0x02564A, ["sfz2al"] = 0x025DD6, func = function() --tripwire
			insert_throw({
				val_x = signed_register("d0"),
				rad_x = signed_register("d1"),
				type = "throw",
			})
		end},
		{["sfa2"] = 0x025786, ["sfz2al"] = 0x025F12, func = function() --air throws
			insert_throw({
				val_x = signed_register("d0"),
				rad_x = signed_register("d1"),
				val_y = signed_register("d2"),
				rad_y = signed_register("d3"),
				type = "axis throw",
			})
		end},
	},
	clones = {
		["sfa2u"] = 0xBD2, ["sfa2ur1"] = 0xBC2, ["sfz2ad"] = 0xC0A, ["sfz2a"] = 0xC0A, 
		["sfz2br1"] = 0x48, ["sfz2b"] = 0x42, ["sfz2h"] = 0x48, ["sfz2jd"] = 0xC0A, ["sfz2j"] = 0xC0A, ["sfz2n"] = 0, 
		["sfz2al"] = 0, ["sfz2ald"] = 0, ["sfz2alb"] = 0, ["sfz2alh"] = 0, ["sfz2alj"] = -0x310, 
	},
	process_throw = function(obj, box)
		box.val_y = box.val_y or obj.val_y or globals.ground_throw_height/2
		box.rad_y = box.rad_y or obj.rad_y or globals.ground_throw_height/2

		box.val_x  = obj.pos_x + box.val_x * obj.flip_x
		box.val_y  = obj.pos_y - box.val_y
		box.left   = box.val_x - box.rad_x
		box.right  = box.val_x + box.rad_x
		box.top    = box.val_y - box.rad_y
		box.bottom = box.val_y + box.rad_y

		return box
	end,
	active = function() return any_true({
		(rd(0xFF8004) == 0x40000 and
		(rd(0xFF8008) == 0x40000 or rd(0xFF8008) == 0xA0000)),
		rw(0xFF8008) == 0x2 and rw(0xFF800A) > 0,
	}) end,
	invulnerable = function(obj, box) return any_true({
		rb(obj.base + 0x25B) > 0,
		rb(obj.base + 0x273) > 0,
		rb(obj.base + 0x13B) > 0,
	}) end,
	unthrowable = function(obj, box)
		if any_true({
				rb(0xFF810E) > 0,
				rb(obj.base + 0x273) > 0,
				bit.band(rd(rd(obj.base + 0x01C) + 0x8), 0xFFFFFF00) == 0,
			}) then
			return true
		elseif rb(0xFF0000 + rw(obj.base + 0x38) + 0x142) > 0 then --opponent in CC
			return any_true({
				rb(rd(obj.base + 0x01C) + 0xD) > 0,
			})
		else --not in CC
			return any_true({
				rb(obj.base + 0x241) > 0,
				rw(obj.base + 0x004) ~= 0x200,
				rb(obj.base + 0x031) > 0,
			})
		end
	end,
},
{	games = {"sfa3"},
	number = {players = 4, projectiles = 24},
	address = {
		player      = 0xFF8400,
		projectile  = 0xFF9400,
		screen_left = 0xFF8290,
	},
	offset = {
		object_space = 0x100,
		flip_x       = 0x0B,
		hitbox_ptr   = nil,
	},
	friends = {0x17, 0x22},
	box_list = {
		{anim_ptr =  nil, addr_table_ptr = 0x9C, id_ptr =  0xCB, id_shift = 0x3, type = "push"},
		{anim_ptr =  nil, addr_table_ptr = 0x90, id_ptr =  0xC8, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr =  nil, addr_table_ptr = 0x94, id_ptr =  0xC9, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr =  nil, addr_table_ptr = 0x98, id_ptr =  0xCA, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr =  nil, addr_table_ptr = 0x9C, id_ptr =  0xCB, id_shift = 0x3, type = "throwable"}, --identical to pushbox
		{anim_ptr = 0x1C, addr_table_ptr = 0xA0, id_ptr =   0x9, id_shift = 0x5, type = "attack"},
	},
	throw_box_list = {
		{anim_ptr =  nil, addr_table_ptr = 0xA0, id_ptr = 0x32F, id_shift = 0x5, type = "throw", clear = true},
		{anim_ptr =  nil, addr_table_ptr = 0xA0, id_ptr =  0x82, id_shift = 0x5, type = "tripwire", clear = true},
	},
	watchpoints = {
		{offset = 0x32F, size = 1, func = function() insert_throw({
			id = bit.band(memory.getregister("m68000.d0"), 0xFF),
			anim_ptr = nil, addr_table_ptr = 0xA0, type = "throw", id_shift = 0x5,
		}) end},
		{offset = 0x1E4, size = 2, func = function() insert_throw({
			pos_x = bit.band(memory.getregister("m68000.d0"), 0xFFFF),
			anim_ptr = nil, addr_table_ptr = 0xA0, type = "tripwire", id_ptr = 0x82, id_shift = 0x5,
		}) end},
	},
	process_throw = function(obj, box)
		box.pos_x = box.pos_x and rws(obj.base + 0x1E4) + box.pos_x
		return define_box[game.box_type](obj, box)
	end,
	active = function() return any_true({
		(rd(0xFF8004) == 0x40000 and rd(0xFF8008) == 0x60000),
		(rw(0xFF8008) == 0x2 and rw(0xFF800A) > 0),
	}) end,
	invulnerable = function(obj, box) return any_true({
		rb(obj.base + 0x067) > 0,
		rb(obj.base + 0x25D) > 0,
		rb(obj.base + 0x0D6) > 0,
		rb(obj.base + 0x2CE) > 0,
	}) end,
	unpushable = function(obj, box) return any_true({
		rb(obj.base + 0x67) > 0,
	}) end,
	unthrowable = function(obj, box)
		if any_true({
				rb(obj.base + 0x25D) > 0,
				rb(obj.base + 0x23F) > 0,
				rb(obj.base + 0x2CE) > 0,
				bit.band(rd(obj.base + 0x0C8), 0xFFFFFF00) == 0,
				rb(obj.base + 0x067) > 0,
			}) then
			return true
		end
		local opp = { base = 0xFF0000 + rw(obj.base + 0x38)}
		opp.air = rb(opp.base + 0x31) > 0
		opp.VC  = rb(opp.base + 0xB9) > 0
		local status = rw(obj.base + 0x4)
		if opp.VC and rb(obj.base + 0x24E) == 0 then --VC: 02E37C
			return
		elseif not opp.air then --ground: 02E3FE
			return any_true({ --02E422
				status ~= 0x204 and status ~= 0x200 and rb(obj.base + 0x24E) == 0 and 
				(status ~= 0x202 or rb(obj.base + 0x54) ~= 0xC),
				rb(obj.base + 0x031) > 0,
			})
		else --air: 02E636
			return any_true({ --02E66E
				rb(obj.base + 0x031) == 0,
				rb(obj.base + 0x0D6) > 0,
				status ~= 0x204 and status ~= 0x200 and status ~= 0x202,
			})
		end
	end,
},
{	games = {"dstlk"},
	number = {players = 2, projectiles = 4},
	address = {
		player      = 0xFF8388,
		projectile  = 0xFFAA2E,
		screen_left = 0xFF9518,
	},
	offset = {
		object_space = 0xC0,
		flip_x       = 0x09,
		hitbox_ptr   = {player = 0x5C, projectile = 0x5C},
		character    = 0x3A1, 
	},
	box = {val_x = 0x0, val_y = 0x4, rad_x = 0x2, rad_y = 0x6},
	box_list = {
		{anim_ptr = 0x1C, addr_table_ptr = 0x0A, id_ptr = 0x15, id_shift = 0x3, type = "push", no_projectile = true},
		{anim_ptr = 0x1C, addr_table_ptr = 0x00, id_ptr = 0x10, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr = 0x1C, addr_table_ptr = 0x02, id_ptr = 0x11, id_shift = 0x3, type = "vulnerability", no_projectile = true},
		{anim_ptr = 0x1C, addr_table_ptr = 0x04, id_ptr = 0x12, id_shift = 0x3, type = "vulnerability", no_projectile = true},
		{anim_ptr = 0x1C, addr_table_ptr = 0x06, id_ptr = 0x13, id_shift = 0x3, type = "negate"},
		{anim_ptr = 0x1C, addr_table_ptr = 0x08, id_ptr = 0x14, id_shift = 0x4, type = "attack"},
	},
	throw_box_list = {
		{method = "range given", base_x = 0x010, range_x = 0x1E8, range_y = 0x1E9, air_state = 0x4C, type = "throwable"},
	},
	breakpoints = {
		{["dstlk"] = 0x033CBE, func = function() --attempt ground throws from any range
			memory.setregister("m68000.d3", 0)
		end},
		{["dstlk"] = 0x033D22, func = function() --ground throws
			local base = memory.getregister("m68000.a6")
			local range = rws(rd(base + 0x1EA) + rb(base + 0x27))
			insert_throw({range_x = range})
		end},
		{["dstlk"] = 0x033BEC, func = function() --air throws
			local base = memory.getregister("m68000.a6")
			local curr = rw(base + game.offset.player_space - 0x7A)
			local prev = rw(base + game.offset.player_space - 0x78)
			local range = bit.band(memory.getregister("m68000.d0"), 0xFF)
			range = rws(rd(base + 0x1EA) + range)
			if any_true({
				bit.band(curr, 0x07) == 0, 
				bit.band(bit.band(bit.bnot(prev), curr), 0x60) == 0, 
				range == 0, 
			}) then
				return --input check @ 0451D6
			end
			insert_throw({range_x = range, height = 0xC}) --vertical range @ 033BE0
		end},
		{["dstlk"] = 0x03B8F4, ["dstlku"] = 0x03BBCE, ["dstlkh"] = 0x03BBCE, 
			["vampjr1"] = 0x03DDA4, ["vampj"] = 0x03DDB8, ["vampja"] = 0x03DDB8, 
			func = function() --midnight pleasure
				insert_throw({range_x = 0x24}) --hard range @ 03B938
			end, 
		},
	},
	clones = {
		["dstlka"] = 0, ["dstlkh"] = 0x2D6, ["dstlku1d"] = 0, ["dstlkur1"] = 0, ["dstlku"] = 0x2D6, 
		["vampjr1"] = 0x24A2, ["vampj"] = 0x24B6, ["vampja"] = 0x24B6, 
	},
	breakables = {start = 0xFFAD2E, space = 0x80, number = 8},
	process_throw = function(obj, box)
		box.type   = "throw"
		box.right  = obj.pos_x
		box.left   = obj.pos_x + box.range_x * obj.flip_x
		if rb(obj.base + game.offset.character) == 0x06 then --Anakaris
			box.right = box.left - 0x20 * obj.flip_x --hard width @ 033C5C
		end
		box.bottom = obj.pos_y
		box.top    = obj.pos_y - rb(obj.base + 0x1E9)
		if box.height then
			box.bottom = box.top + box.height
		end
		box.val_x  = (box.left + box.right)/2
		box.val_y  = (box.bottom + box.top)/2
		
		return box
	end,
	active = function() return any_true({
		(rd(0xFF8004) == 0x40000 and bit.band(rd(0xFF8008), 0x8FFFF) == 0x80000),
	}) end,
	invulnerable = function(obj, box) return any_true({
		rb(obj.base + 0x15D) > 0,
		(rb(obj.base + 0x167) == 0 and 
		rbs(obj.base + 0x062) < 0 and 
		rb(obj.base + 0x12A) == 0),
	}) end,
	unpushable = function(obj, box) return any_true({
		rb(obj.base + 0x1E6) > 0,
		rb(obj.base + 0x04D) > 0,
	}) end,
	unthrowable = function(obj, box) return any_true({
		rb(obj.base + 0x062) > 0,
		rw(obj.base + 0x15D) > 0,
	}) end,
},
{	games = {"nwarr"},
	number = {players = 2, projectiles = 12},
	address = {
		player      = 0xFF8388,
		projectile  = 0xFFA86E,
		screen_left = 0xFF8F18,
	},
	offset = {
		player_space = 0x500,
		object_space = 0xC0,
		flip_x       = 0x09,
		hitbox_ptr   = {player = 0x5C, projectile = 0x5C},
		character    = 0x4A1, 
	},
	box = {val_x = 0x0, val_y = 0x4, rad_x = 0x2, rad_y = 0x6},
	box_list = {
		{anim_ptr = 0x1C, addr_table_ptr = 0x0A, id_ptr = 0x15, id_shift = 0x3, type = "push", no_projectile = true},
		{anim_ptr = 0x1C, addr_table_ptr = 0x00, id_ptr = 0x10, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr = 0x1C, addr_table_ptr = 0x02, id_ptr = 0x11, id_shift = 0x3, type = "vulnerability", no_projectile = true},
		{anim_ptr = 0x1C, addr_table_ptr = 0x04, id_ptr = 0x12, id_shift = 0x3, type = "vulnerability", no_projectile = true},
		{anim_ptr = 0x1C, addr_table_ptr = 0x06, id_ptr = 0x13, id_shift = 0x3, type = "negate"},
		{anim_ptr = 0x1C, addr_table_ptr = 0x08, id_ptr = 0x14, id_shift = 0x4, type = "attack"},
	},
	throw_box_list = {
		{method = "range given", base_x = 0x010, range_x = 0x1E8, range_y = 0x1E9, air_state = 0x41, type = "throwable"},
		{method = "range given", base_x = 0x192, range_x = 0x196, range_y = 0x194, type = "axis throw"}, --"no_box" projectiles
	},
	breakpoints = {
		{["nwarr"] = 0x02A002, func = function() --attempt ground throws from any range
			memory.setregister("m68000.d3", 0)
		end},
		{["nwarr"] = 0x02A172, func = function() --ground throws
			local base = memory.getregister("m68000.a6")
			local range = rws(rd(base + 0x1EA) + rb(base + 0x27))
			insert_throw({range_x = range})
		end},
		{["nwarr"] = 0x029F5C, func = function() --air throws
			local base = memory.getregister("m68000.a6")
			local curr = rw(base + game.offset.player_space - 0x7A)
			local prev = rw(base + game.offset.player_space - 0x78)
			local range = bit.band(memory.getregister("m68000.d0"), 0xFF)
			range = rws(rd(base + 0x1EA) + range)
			if any_true({
				bit.band(curr, 0x07) == 0, 
				bit.band(bit.band(bit.bnot(prev), curr), 0x60) == 0, 
				range == 0, 
			}) then
				return --input check @ 0355CE
			end
			insert_throw({range_x = range, height = 0xC}) --vertical range @ 029F50
		end},
		{["nwarr"] = 0x0366C2, ["vhuntjr2"] = 0x036488, ["vhuntjr1"] = 0x0366F4, ["vhuntj"] = 0x0366F4, 
			func = function() --midnight pleasure
				insert_throw({range_x = 0x22}) --hard range @ 036706
			end, 
		},
	},
	clones = {
		["nwarra"] = -0x282, ["nwarrb"] = 0, ["nwarrh"] = 0, ["nwarrud"] = 0, ["nwarru"] = 0, 
		["vhuntjr2"] = -0x25E, ["vhuntjr1"] = 0x024, ["vhuntj"] = 0x024, 
	},
	special_projectiles = {start = 0xFF9A6E, space = 0x80, number = 28, whitelist = {
		0x56, --Demitri 263KK
		0x4C, --Gallon 41236KK
		0x5F, --Gallon 63214PP
		0x50, --Lei-Lei 623P
		0x54, --Lei-Lei 214P
		0x6E, --Lei-Lei LK,HK,MP,MP,8
		0x0C, --Morrigan LP,LP,6,LK,HP
		0x40, --Morrigan LP,LP,6,MP,HP
		0x44, --Felicia 41236KK
		0x52, --Aulbath 41236PP
		0x05, --Huitzil GC
		0x22, --Huitzil 63214KK
		0x5A, --Huitzil 623P
		0x70, --Pyron 41236PP/KK
	}, 
	no_box = { --special throws
		0x3F, --Rapter 623PP
		0x68, --Anakaris 236P
		0x3E, --Aulbath 623PP
	}},
	friends = {0x40, 0x4C, 0x50},
	breakables = {start = 0xFFB16E, space = 0x80, number = 8},
	process_throw = function(obj, box)
		box.type   = "throw"
		box.right  = obj.pos_x
		box.left   = obj.pos_x + box.range_x * obj.flip_x
		box.bottom = obj.pos_y
		box.top    = obj.pos_y - rb(obj.base + 0x1E9)
		if box.height then
			box.bottom = box.top + box.height
		end
		box.val_x  = (box.left + box.right)/2
		box.val_y  = (box.bottom + box.top)/2
		
		return box
	end,
	active = function() return any_true({
		(rd(0xFF8004) == 0x40000 and bit.band(rd(0xFF8008), 0x8FFFF) == 0x80000),
		(rw(0xFF8000) >= 0x0E and rd(0xFF8004) == 0),
	}) end,
	invulnerable = function(obj, box) return any_true({
		(rb(obj.base + 0x49F) == 0 and rb(obj.base + 0x2AF) > 0),
		rb(obj.base + 0x15D) > 0,
		bit.band(rb(obj.base + 0x167), 0x0E) > 0,
		(rb(obj.base + 0x167) == 0 and 
		rbs(obj.base + 0x062) < 0 and 
		rb(obj.base + 0x12A) == 0),
	}) end,
	unpushable = function(obj, box) return any_true({
		rb(obj.base + 0x1E6) > 0,
		rb(obj.base + 0x04C) > 0,
	}) end,
	unthrowable = function(obj, box) return any_true({
		rb(obj.base + 0x062) > 0,
		rb(obj.base + 0x15D) > 0,
	}) end,
},
{	games = {"vsav", "vhunt2", "vsav2"},
	number = {players = 2, projectiles = 32},
	address = {
		player      = 0xFF8400,
		projectile  = 0xFF9400,
		screen_left = 0xFF8290,
	},
	offset = {
		object_space = 0x100,
		flip_x       = 0x0B,
		hitbox_ptr   = nil,
	},
	box_list = {
		{anim_ptr =  nil, addr_table_ptr = 0x90, id_ptr = 0x97, id_shift = 0x3, type = "push"},
		{anim_ptr =  nil, addr_table_ptr = 0x80, id_ptr = 0x94, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr =  nil, addr_table_ptr = 0x84, id_ptr = 0x95, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr =  nil, addr_table_ptr = 0x88, id_ptr = 0x96, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr =  nil, addr_table_ptr = 0x90, id_ptr = 0x97, id_shift = 0x3, type = "throwable"}, --identical to pushbox
		{anim_ptr = 0x1C, addr_table_ptr = 0x8C, id_ptr = 0x0A, id_shift = 0x5, type = "attack"},
	},
	breakpoints = {
		{["vsav"] = 0x029450, ["vsav2"] = 0x02874A, ["vhunt2"] = 0x028778, 
		func = function() --non-ranged throws
			local stack, pc = rd(memory.getregister("m68000.a7")), memory.getregister("m68000.pc")
			if stack ~= pc + 0x30 and stack ~= pc + 0xB2 and stack ~= pc + 0xBE then
				return --don't draw the initial range check of command throws
			end
			insert_throw({
				id = bit.band(memory.getregister("m68000.d0"), 0xFF),
				anim_ptr = nil, addr_table_ptr = 0x8C, id_ptr = 0x98, id_shift = 0x5, type = "throw",
			})
		end},
		{["vsav"] = 0x0191A2, ["vsav2"] = 0x017BA4, ["vhunt2"] = 0x017BAA, ["vhunt2r1"] = 0x017B3A, 
		func = function() --attempt cmd throws from any range
			local stack = {rd(memory.getregister("m68000.a7")), rd(memory.getregister("m68000.a7") + 4)}
			local target = {["vsav"] = 0x029472, ["vsav2"] = 0x02876C, ["vhunt2"] = 0x02879A, ["vhunt2r1"] = 0x0286E8}
			target = target[emu.romname()] or target[emu.parentname()]
			if any_true({
				stack[1] ~= target, --must be a command throw setup
				stack[2] == target + 0x0E, --don't interfere with actual throw attempts
				stack[2] == target + 0x90, --don't interfere with attacks
				stack[2] == target + 0x9C, --don't interfere with vsav2/vhunt2 air throws
				}) then
				return
			end
			memory.setregister("m68000.d1", 0)
		end},
		{["vsav"] = 0x029638, ["vsav2"] = 0x02893E, ["vhunt2"] = 0x02896C, 
		func = function() --ranged throws
			local base = memory.getregister("m68000.a4")
			insert_throw({
				id = bit.band(memory.getregister("m68000.d0"), 0xFF),
				pos_x = get_x(rws(base + game.offset.pos_x)),
				pos_y = get_y(rws(base + game.offset.pos_y)),
				anim_ptr = nil, addr_table_ptr = 0x8C, id_ptr = 0x98, id_shift = 0x5, type = "throw",
			})
		end},
	},
	clones = {
		["vsava"] = 0, ["vsavd"] = 0, ["vsavh"] = 0, ["vsavj"] = 0, ["vsavu"] = 0, 
		["vsav2"] = 0, ["vsav2d"] = 0, ["vhunt2"] = 0, ["vhunt2d"] = 0, ["vhunt2r1"] = -0xB2
	},
	process_throw = function(obj, box)
		return define_box[game.box_type](obj, box)
	end,
	friends = {0x08, 0x10, 0x11, 0x37},
	active = function() return any_true({
		(rd(0xFF8004) == 0x40000 and rd(0xFF8008) == 0x40000),
		(rw(0xFF8008) == 0x2 and rw(0xFF800A) > 0),
	}) end,
	invulnerable = function(obj, box) return any_true({
		rb(obj.base + 0x134) > 0,
		rb(obj.base + 0x147) > 0,
		rb(obj.base + 0x11E) > 0,
		rb(obj.base + 0x145) > 0 and rb(obj.base + 0x1A4) == 0,
	}) end,
	unpushable = function(obj, box) return any_true({
		rb(obj.base + 0x134) > 0,
	}) end,
	unthrowable = function(obj, box) return any_true({
		not (rw(obj.base + 0x004) == 0x0200 or rw(obj.base + 0x004) == 0x0204),
		rb(obj.base + 0x143) > 0,
		rb(obj.base + 0x147) > 0,
		rb(obj.base + 0x11E) > 0,
		bit.band(rd(obj.base + 0x094), 0xFFFFFF00) == 0,
	}) end,
},
{	games = {"ringdest"},
	number = {players = 2, projectiles = 28},
	ground_level = 0x17,
	address = {
		player      = 0xFF8000,
		projectile  = 0xFF9000,
		screen_left = 0xFF72D2,
		screen_top  = 0xFF72D4,
	},
	offset = {
		object_space = 0x100,
		flip_x       = 0x38,
		id_ptr       = 0x4A,
	},
	box = {
		radscale = 2,
		val_x = 0x0, val_y = 0x4, rad_x = 0x2, rad_y = 0x6,
	},
	box_list = {
		{addr_table_ptr  = 0x2D8,  type = "push"},
		{addr_table_base = 0xC956, type = "throwable"},
		{addr_table_base = 0xC92E, type = "vulnerability"},
		{addr_table_base = 0xC936, type = "vulnerability"},
		{addr_table_base = 0xC93E, type = "vulnerability"},
		{addr_table_base = 0xC946, type = "attack"},
		{addr_table_base = 0xC94E, type = "throw"},
	},
	active = function() return any_true({
		rws(0xFF72D2) > 0,
	}) end,
	projectile_active = function(obj, box) return any_true({
		rw(obj.base) > 0x0100 and rb(obj.base + 0x02) == 0x01,
	}) end,
	unpushable = function(obj, box) return any_true({
		obj.projectile ~= nil,
		rw(obj.base + 0x70) > 0,
		rw(obj.base + 0x98) > 0,
	}) end,
},
{	games = {"cybots"},
	number = {players = 2, projectiles = 16},
	address = {
		player      = 0xFF81A0,
		projectile  = 0xFF92A0,
	},
	offset = {
		object_space = 0xC0,
		flip_x       = 0x09,
		pos_x        = 0x1A,
		hitbox_ptr   = {player = 0x32, projectile = 0x32},
	},
	box_list = {
		{anim_ptr = nil, addr_table_ptr = 0x08, id_ptr = 0x66, id_shift = 0x3, type = "push"},
		{anim_ptr = nil, addr_table_ptr = 0x02, id_ptr = 0x63, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr = nil, addr_table_ptr = 0x04, id_ptr = 0x64, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr = nil, addr_table_ptr = 0x06, id_ptr = 0x65, id_shift = 0x3, type = "vulnerability"},
		{method = "dimensions", dimensions = 0x19E, type = "throwable"},
		{anim_ptr = nil, addr_table_ptr = 0x00, id_ptr = 0x62, id_shift = 0x4, type = "attack"},
	},
	breakpoints = {
		{["cybots"] = 0x002DF0, func = function()
			local base = memory.getregister("m68000.a6")
			insert_throw({
				val_x = rws(base + 0x160),
				val_y = rws(base + 0x162),
				rad_x = rws(base + 0x164),
				rad_y = rws(base + 0x164), --Same as rad_x. Glitch?
				type = "axis throw",
			}) end},
	},
	clones = {
		["cybotsj"] = 0, ["cybotsud"] = 0, ["cybotsu"] = 0, 
	},
	process_throw = function(obj, box)
		box.val_x  = obj.pos_x + box.val_x * obj.flip_x
		box.val_y  = obj.pos_y - box.val_y
		box.left   = box.val_x - box.rad_x
		box.right  = box.val_x + box.rad_x
		box.top    = box.val_y - box.rad_y
		box.bottom = box.val_y + box.rad_y

		return box
	end,
	get_cam_ptr = function()
		local slot = {
			0x6CDA, 0x6C1A, 0x6CDA, 0x6C1A, 0x6CDA, 0x6CDA, 0x6D9A, 0x6CDA, 
			0x6CDA, 0x6D9A, 0x6D9A, 0x6D9A, 0x6C1A, 0x6D9A, 0x6CDA, 0x6CDA,
		}
		return 0xFF8000 + (slot[rw(0xFFEA1A) + 1] or slot[1]) + 0x1A
	end,
	active = function() return any_true({
		bit.band(rd(0xFF8008), 0x10FFFF) == 0x100000,
	}) end,
	projectile_active = function(obj) return any_true({
		rw(obj.base) > 0x0100 and bit.band(rw(obj.base + 0x2), 0x8) == 0,
	}) end,
	invulnerable = function(obj, box) return any_true({
		bit.band(rw(obj.base + 0x126), 0x20) > 0,
	}) end,
	unpushable = function(obj, box) return any_true({
		bit.band(rw(obj.base + 0x126), 0x20) > 0,
	}) end,
	unthrowable = function(obj, box)
	local status = rw(obj.base + 0x126)
	return any_true({
		rw(obj.base + 0x152) > 0,
		bit.band(status, 0x40) == 0 and bit.band(status, 0x30) > 0,
		rb(obj.base + 0x1A6) > 0,
	}) end,
},
{	games = {"sgemf"},
	number = {players = 2, projectiles = 14},
	address = {
		player      = 0xFF8400,
		projectile  = 0xFF8C00,
		screen_left = 0xFF8290,
	},
	offset = {
		object_space = 0x100,
		flip_x       = 0x0B,
		hitbox_ptr   = nil,
	},
	box = {radscale = 2},
	box_list = {
		{anim_ptr =  nil, addr_table_ptr = 0x8C, id_ptr = 0x93, id_shift = 0x3, type = "push"},
		{anim_ptr =  nil, addr_table_ptr = 0x80, id_ptr = 0x90, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr =  nil, addr_table_ptr = 0x84, id_ptr = 0x91, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr = 0x1C, addr_table_ptr = 0x8C, id_ptr = 0x0B, id_shift = 0x3, type = "throwable"}, --same as pushbox?
		{anim_ptr =  nil, addr_table_ptr = 0x88, id_ptr = 0x92, id_shift = 0x5, type = "attack"},
	},
	breakpoints = {
		{["sgemf"] = 0x012800, func = function() insert_throw({
			id = bit.band(memory.getregister("m68000.d0"), 0xFF),
			anim_ptr = nil, addr_table_ptr = 0x88, id_ptr = 0x98, id_shift = 0x5, type = "throw",
		}) end},
	},
	clones = {
		["pfghtj"] = 0, ["sgemfd"] = 0, ["sgemfa"] = 0, ["sgemfh"] = 0, 
	},
	process_throw = function(obj, box)
		return define_box[game.box_type](obj, box)
	end,
	active = function() return any_true({
		rd(0xFF8004) == 0x40000 and rd(0xFF8008) == 0x40000,
		rw(0xFF8008) == 0x2 and rw(0xFF800A) > 0,
	}) end,
	no_hit = function(obj, box) return any_true({
		rb(obj.base + 0xB1) > 0,
	}) end,
	invulnerable = function(obj, box) return any_true({
		rb(obj.base + 0x147) > 0,
		rb(obj.base + 0x132) > 0,
		rb(obj.base + 0x11B) > 0,
	}) end,
	unpushable = function(obj, box) return any_true({
		rb(obj.base + 0x1AA) > 0,
		rb(obj.base + 0x093) == 0,
	}) end,
	unthrowable = function(obj, box) return any_true({
		rb(obj.base + 0x143) > 0,
		rb(obj.base + 0x188) > 0,
		rb(obj.base + 0x119) == 0 and rw(obj.base + 0x04) == 0x0202,
		rw(box.id_base + 0x08) == 0,
		rb(obj.base + 0x105) > 0 and rb(obj.base + 0x1BE) == 0 and rb(box.id_base + 0x17) == 0,
	}) end,
},
}

--------------------------------------------------------------------------------
-- post-process the modules

for game in ipairs(profile) do
	local g = profile[game]
	g.box_type = g.offset.id_ptr and "id ptr" or "hitbox ptr"
	g.ground_level = g.ground_level or -0x0F
	g.offset.player_space = g.offset.player_space or 0x400
	g.offset.pos_x = g.offset.pos_x or 0x10
	g.offset.pos_y = g.offset.pos_y or g.offset.pos_x + 0x4
	g.offset.hitbox_ptr = g.offset.hitbox_ptr or {}
	g.box = g.box or {}
	g.box.radius_read = g.box.radius_read or rw
	g.box.offset_read = g.box.radius_read == rw and rws or rbs
	g.box.val_x    = g.box.val_x or 0x0
	g.box.val_y    = g.box.val_y or 0x2
	g.box.rad_x    = g.box.rad_x or 0x4
	g.box.rad_y    = g.box.rad_y or 0x6
	g.box.radscale = g.box.radscale or 1
	g.no_hit       = g.no_hit       or function() end
	g.invulnerable = g.invulnerable or function() end
	g.unpushable   = g.unpushable   or function() end
	g.unthrowable  = g.unthrowable  or function() end
	g.projectile_active = g.projectile_active or function(obj)
		if rw(obj.base) > 0x0100 and rb(obj.base + 0x04) == 0x02 then
			return true
		end
	end
	g.special_projectiles = g.special_projectiles or {number = 0}
	g.breakables = g.breakables or {number = 0}
end

for _, box in pairs(boxes) do
	box.fill    = bit.lshift(box.color, 8) + (globals.no_alpha and 0x00 or box.fill)
	box.outline = bit.lshift(box.color, 8) + (globals.no_alpha and 0xFF or box.outline)
end

local projectile_type = {
	       ["attack"] = "proj. attack",
	["vulnerability"] = "proj. vulnerability",
}

local DRAW_DELAY = 1
if fba then
	DRAW_DELAY = DRAW_DELAY + 1
end
emu.registerfuncs = fba and memory.registerexec --0.0.7+


--------------------------------------------------------------------------------
-- functions referenced in the modules

any_true = function(condition)
	for n = 1, #condition do
		if condition[n] == true then return true end
	end
end


get_thrower = function(frame)
	local base = bit.band(0xFFFFFF, memory.getregister("m68000.a6"))
	for _, obj in ipairs(frame) do
		if base == obj.base then
			return obj
		end
	end
end


insert_throw = function(box)
	local f = frame_buffer[DRAW_DELAY]
	local obj = get_thrower(f)
	if not f.match_active or not obj then
		return
	end
	table.insert(throw_buffer[obj.base], game.process_throw(obj, box))
end


signed_register = function(register, bytes)
	local bits = bit.lshift(4, bytes or 2)
	local val = bit.band(memory.getregister("m68000." .. register), bit.lshift(1, bits) - 1)
	if bit.arshift(val, bits-1) > 0 then
		val = val - bit.lshift(1, bits)
	end
	return val
end


get_x = function(x)
	return x - frame_buffer[DRAW_DELAY+1].screen_left
end


get_y = function(y)
	return emu.screenheight() - (y + game.ground_level) + frame_buffer[DRAW_DELAY+1].screen_top
end


--------------------------------------------------------------------------------
-- prepare the hitboxes

local process_box_type = {
	["vulnerability"] = function(obj, box)
		if game.invulnerable(obj, box) or obj.friends then
			return false
		end
	end,

	["attack"] = function(obj, box)
		if game.no_hit(obj, box) then
			return false
		end
	end,

	["push"] = function(obj, box)
		if game.unpushable(obj, box) or obj.friends then
			return false
		end
	end,

	["negate"] = function(obj, box)
	end,

	["tripwire"] = function(obj, box)
		box.id = bit.rshift(box.id, 1) + 0x3E
		box.pos_x = box.pos_x or rws(obj.base + 0x1E4)
		if box.pos_x == 0 or rb(obj.base + 0x102) ~= 0x0E then
			return false
		elseif box.clear and not (rb(obj.base + 0x07) == 0x04 and rb(obj.base + 0xAA) == 0x0C) then
			memory.writeword(obj.base + 0x1E4, 0) --sfa3 w/o registerfuncs (bad)
		end
		box.pos_x = obj.pos_x + box.pos_x
	end,

	["throw"] = function(obj, box)
		if box.clear then
			memory.writebyte(obj.base + box.id_ptr, 0) --sfa3 w/o registerfuncs (bad)
		end
	end,

	["axis throw"] = function(obj, box)
	end,

	["throwable"] = function(obj, box)
		if game.unthrowable(obj, box) or obj.projectile then
			return false
		end
	end,
}


define_box = {
	["hitbox ptr"] = function(obj, box_entry)
		local box = copytable(box_entry)

		if obj.projectile and box.no_projectile then
			return nil
		end

		if not box.id then
			box.id_base = (box.anim_ptr and rd(obj.base + box.anim_ptr)) or obj.base
			box.id = rb(box.id_base + box.id_ptr)
		end

		if process_box_type[box.type](obj, box) == false or box.id == 0 then
			return nil
		end

		local addr_table
		if not obj.hitbox_ptr then
			addr_table = rd(obj.base + box.addr_table_ptr)
		else
			local table_offset = obj.projectile and box.p_addr_table_ptr or box.addr_table_ptr
			addr_table = obj.hitbox_ptr + rws(obj.hitbox_ptr + table_offset)
		end
		box.address = addr_table + bit.lshift(box.id, box.id_shift)

		box.rad_x = game.box.radius_read(box.address + game.box.rad_x)/game.box.radscale
		box.rad_y = game.box.radius_read(box.address + game.box.rad_y)/game.box.radscale
		box.val_x = game.box.offset_read(box.address + game.box.val_x)
		box.val_y = game.box.offset_read(box.address + game.box.val_y)
		if box.type == "push" then
			obj.val_y, obj.rad_y = box.val_y, box.rad_y
		end

		box.val_x  = (box.pos_x or obj.pos_x) + box.val_x * obj.flip_x
		box.val_y  = (box.pos_y or obj.pos_y) - box.val_y
		box.left   = box.val_x - box.rad_x
		box.right  = box.val_x + box.rad_x
		box.top    = box.val_y - box.rad_y
		box.bottom = box.val_y + box.rad_y

		box.type = obj.projectile and not obj.friends and projectile_type[box.type] or box.type

		return box
	end,

	["id ptr"] = function(obj, box_entry) --ringdest only
		local box = copytable(box_entry)

		if process_box_type[box.type](obj, box) == false then
			return nil
		end

		if box.addr_table_base then
			box.address = box.addr_table_base + bit.lshift(obj.id_offset, 2)
		else
			box.address = rd(obj.base + box.addr_table_ptr)
		end

		box.rad_x = game.box.radius_read(box.address + game.box.rad_x)/game.box.radscale
		box.rad_y = game.box.radius_read(box.address + game.box.rad_y)/game.box.radscale
		if box.rad_x == 0 or box.rad_y == 0 then
			return nil
		end
		box.val_x = game.box.offset_read(box.address + game.box.val_x)
		box.val_y = game.box.offset_read(box.address + game.box.val_y)

		box.val_x  = obj.pos_x + (box.rad_x + box.val_x) * obj.flip_x
		box.val_y  = obj.pos_y - (box.rad_y + box.val_y)
		box.left   = box.val_x - box.rad_x
		box.right  = box.val_x + box.rad_x
		box.top    = box.val_y - box.rad_y
		box.bottom = box.val_y + box.rad_y

		box.type = obj.projectile and projectile_type[box.type] or box.type

		return box
	end,

	["range given"] = function(obj, box_entry) --dstlk/nwarr throwable; nwarr ranged
		local box = copytable(box_entry)

		box.base_x  = rw(obj.base + box.base_x)
		box.range_x = rb(obj.base + box.range_x)
		if process_box_type[box.type](obj, box) == false or box.base_x == 0 or box.range_x == 0 then
			return nil
		end
		box.right = get_x(box.base_x) - box.range_x
		box.left  = get_x(box.base_x) + box.range_x
		if box.type == "axis throw" then --nwarr ranged
			box.bottom = get_y(game.ground_level)
			box.top    = get_y(rw(obj.base + box.range_y))
		else
			box.top    = obj.pos_y - rb(obj.base + box.range_y)
			if rb(obj.base + box.air_state) > 0 then
				box.bottom = box.top + 0xC --air throwable; verify range @ 033BE0 [dstlk] & 029F50 [nwarr]
			else
				box.bottom = obj.pos_y --ground throwable
			end
		end
		box.val_x = (box.left + box.right)/2
		box.val_y = (box.bottom + box.top)/2

		return box
	end,

	["dimensions"] = function(obj, box_entry) --cybots throwable
		local box = copytable(box_entry)

		if process_box_type[box.type](obj, box) == false then
			return nil
		end
		box.hval = rws(obj.base + box.dimensions + 0x0)
		box.vval = rws(obj.base + box.dimensions + 0x2)
		box.hrad =  rw(obj.base + box.dimensions + 0x4)
		box.vrad =  rw(obj.base + box.dimensions + 0x6)

		box.hval   = obj.pos_x + box.hval * obj.flip_x
		box.vval   = obj.pos_y - box.vval
		box.left   = box.hval - box.hrad
		box.right  = box.hval + box.hrad
		box.top    = box.vval - box.vrad
		box.bottom = box.vval + box.vrad

		return box
	end,
}


local get_ptr = {
	["hitbox ptr"] = function(obj)
		obj.hitbox_ptr = obj.projectile and game.offset.hitbox_ptr.projectile or game.offset.hitbox_ptr.player
		obj.hitbox_ptr = obj.hitbox_ptr and rd(obj.base + obj.hitbox_ptr) or nil
	end,

	["id ptr"] = function(obj) --ringdest only
		obj.id_offset = rw(obj.base + game.offset.id_ptr)
	end,
}


local update_object = function(obj)
	obj.flip_x = rb(obj.base + game.offset.flip_x) > 0 and -1 or 1
	obj.pos_x  = get_x(rws(obj.base + game.offset.pos_x))
	obj.pos_y  = get_y(rws(obj.base + game.offset.pos_y))
	get_ptr[game.box_type](obj)
	for _, box_entry in ipairs(game.box_list) do
		table.insert(obj, define_box[box_entry.method or game.box_type](obj, box_entry))
	end
	return obj
end


local friends_status = function(id)
	for _, friend in ipairs(game.friends or {}) do
		if id == friend then
			return true
		end
	end
end


local read_projectiles = function(f)
	for i = 1, game.number.projectiles do
		local obj = {base = game.address.projectile + (i-1) * game.offset.object_space}
		if game.projectile_active(obj) then
			obj.projectile = true
			obj.friends = friends_status(rb(obj.base + 0x02))
			table.insert(f, update_object(obj))
		end
	end

	for i = 1, game.special_projectiles.number do --for nwarr only
		local obj = {base = game.special_projectiles.start + (i-1) * game.special_projectiles.space}
		local id = rb(obj.base + 0x02)
		for _, valid in ipairs(game.special_projectiles.no_box) do
			if id == valid then
				obj.pos_x = get_x(rws(obj.base + game.offset.pos_x))
				obj.pos_y = get_y(rws(obj.base + game.offset.pos_y))
				table.insert(f, obj)
				break
			end
		end
		for _, valid in ipairs(game.special_projectiles.whitelist) do
			if id == valid then
				obj.projectile, obj.hit_only, obj.friends = true, true, friends_status(id)
				table.insert(f, update_object(obj))
				break
			end
		end
	end
--[[
	for i = 1, game.breakables.number do --for dstlk, nwarr
		local obj = {base = game.breakables.start + (i-1) * game.breakables.space}
		local status = rb(obj.base + 0x04)
		if status == 0x02 then
			obj.projectile = true
			obj.x_adjust = 0x1C*((f.screen_left-0x100)/0xC0-1)
			table.insert(f, update_object(obj))
		end
	end
]]
end


local update_hitboxes = function()
	if not game then
		return
	end
	local screen_left_ptr = game.address.screen_left or game.get_cam_ptr()
	local screen_top_ptr  = game.address.screen_top or screen_left_ptr + 0x4

	for f = 1, DRAW_DELAY do
		frame_buffer[f] = copytable(frame_buffer[f+1])
	end

	frame_buffer[DRAW_DELAY+1] = {
		match_active = game.active(),
		screen_left = rws(screen_left_ptr),
		screen_top  = rws(screen_top_ptr),
	}
	local f = frame_buffer[DRAW_DELAY+1]
	if not f.match_active then
		return
	end

	for p = 1, game.number.players do
		local player = {base = game.address.player + (p-1) * game.offset.player_space}
		if rb(player.base) > 0 then
			table.insert(f, update_object(player))
			local tb = throw_buffer[player.base]
			table.insert(player, tb[1])
			for frame = 1, #tb-1 do
				tb[frame] = tb[frame+1]
			end
			table.remove(tb)
		end
	end
	read_projectiles(f)

	f = frame_buffer[DRAW_DELAY]
	for _, obj in ipairs(f or {}) do
		if obj.projectile then
			break
		end
		for _, box_entry in ipairs(game.throw_box_list or {}) do
			if not (emu.registerfuncs and box_entry.clear) then
				table.insert(obj, define_box[box_entry.method or game.box_type](obj, box_entry))
			end
		end
	end

	f.max_boxes = 0
	for _, obj in ipairs(f or {}) do
		f.max_boxes = math.max(f.max_boxes, #obj)
	end
	f.max_boxes = f.max_boxes+1
end


-- emu.registerafter( function()
	-- update_hitboxes()
-- end)


--------------------------------------------------------------------------------
-- draw the hitboxes

local draw_hitbox = function(hb)
	if not hb or any_true({
		not globals.draw_pushboxes and hb.type == "push",
		not globals.draw_throwable_boxes and hb.type == "throwable",
	}) then return
	end

	if globals.draw_mini_axis then
		gui.drawline(hb.val_x, hb.val_y-globals.mini_axis_size, hb.val_x, hb.val_y+globals.mini_axis_size, boxes[hb.type].outline)
		gui.drawline(hb.val_x-globals.mini_axis_size, hb.val_y, hb.val_x+globals.mini_axis_size, hb.val_y, boxes[hb.type].outline)
	end

	gui.box(hb.left, hb.top, hb.right, hb.bottom, boxes[hb.type].fill, boxes[hb.type].outline)
end


local draw_axis = function(obj)
	gui.drawline(obj.pos_x, obj.pos_y-globals.axis_size, obj.pos_x, obj.pos_y+globals.axis_size, globals.axis_color)
	gui.drawline(obj.pos_x-globals.axis_size, obj.pos_y, obj.pos_x+globals.axis_size, obj.pos_y, globals.axis_color)
	--gui.text(obj.pos_x, obj.pos_y, string.format("%06X", obj.base)) --debug
end


local render_hitboxes = function()
	gui.clearuncommitted()
	local f = frame_buffer[1]
	if not f.match_active then
		return
	end
	if globals.blank_screen then
		gui.box(0, 0, emu.screenwidth(), emu.screenheight(), globals.blank_color)
	end

	for entry = 1, f.max_boxes or 0 do
		for _, obj in ipairs(f) do
			draw_hitbox(obj[entry])
		end
	end

	if globals.draw_axis then
		for _, obj in ipairs(f) do
			draw_axis(obj)
		end
	end
end


-- gui.register(function()
	-- render_hitboxes()
-- end)


--------------------------------------------------------------------------------
-- hotkey functions

-- input.registerhotkey(1, function()
	-- globals.blank_screen = not globals.blank_screen
	-- render_hitboxes()
	-- emu.message((globals.blank_screen and "activated" or "deactivated") .. " blank screen mode")
-- end)


-- input.registerhotkey(2, function()
	-- globals.draw_axis = not globals.draw_axis
	-- render_hitboxes()
	-- emu.message((globals.draw_axis and "showing" or "hiding") .. " object axis")
-- end)


-- input.registerhotkey(3, function()
	-- globals.draw_mini_axis = not globals.draw_mini_axis
	-- render_hitboxes()
	-- emu.message((globals.draw_mini_axis and "showing" or "hiding") .. " hitbox axis")
-- end)


-- input.registerhotkey(4, function()
	-- globals.draw_pushboxes = not globals.draw_pushboxes
	-- render_hitboxes()
	-- emu.message((globals.draw_pushboxes and "showing" or "hiding") .. " pushboxes")
-- end)


-- input.registerhotkey(5, function()
	-- print("Do we call thsi every frame?")
	-- globals.draw_throwable_boxes = not globals.draw_throwable_boxes
	-- render_hitboxes()
	-- emu.message((globals.draw_throwable_boxes and "showing" or "hiding") .. " throwable boxes")
-- end)


--------------------------------------------------------------------------------
-- initialize on game startup

local initialize_bps = function()
	for _, pc in ipairs(globals.breakpoints or {}) do
		memory.registerexec(pc, nil)
	end
	for _, addr in ipairs(globals.watchpoints or {}) do
		memory.registerwrite(addr, nil)
	end
	globals.breakpoints, globals.watchpoints = {}, {}
end


local initialize_fb = function()
	frame_buffer = {}
	for f = 1, DRAW_DELAY + 1 do
		frame_buffer[f] = {}
	end
end


local initialize_throw_buffer = function()
	throw_buffer = {}
	for p = 1, game.number.players do
		throw_buffer[game.address.player + (p-1) * game.offset.player_space] = {}
	end
end


local whatgame = function()
	 game = nil
	 initialize_fb()
	 initialize_bps()
	 for _, module in ipairs(profile) do
		 for _, shortname in ipairs(module.games) do
			 if emu.romname() == shortname or emu.parentname() == shortname then
				 game = module
				 initialize_throw_buffer()
				 if not emu.registerfuncs then
					 return
				 end
				 for _, bp in ipairs(game.breakpoints or {}) do
					 local pc = bp[emu.romname()] or bp[shortname] + game.clones[emu.romname()]
					 memory.registerexec(pc, bp.func)
					 table.insert(globals.breakpoints, pc)
				 end
				 for _, wp in ipairs(game.watchpoints or {}) do
					for p = 1, game.number.players do
						local addr = game.address.player + (p-1) * game.offset.player_space + wp.offset
						memory.registerwrite(addr, wp.size, wp.func)
						table.insert(globals.watchpoints, addr)
					end
				end
				return
			end
		end
	end
	print("unsupported game: " .. emu.gamename())
end


-- savestate.registerload(function()
	-- initialize_fb()
-- end)


-- emu.registerstart(function()
	-- whatgame()
-- end)

--[[
MacroLua: macro player/recorder for emulators with Lua
http://code.google.com/p/macrolua/
written by Dammit

User: Do not edit this file.
This script depends on macro-options.lua and macro-modules.lua.
See macro-readme.html for help and instructions.
]]

----------------------------------------------------------------------------------------------------
--[[ Prepare the script for the current emulator and the game. ]]--

-- begin macrolua

macrolua = "1.13, 2/18/2011"
print("MacroLua v" .. macrolua)
if fba and not emu.registerstart then
	error("This script requires a newer version of FBA-rr.", 0)
end

--initialize the globals


emu = emu or gens --gens doesn't have the "emu" table of functions

if not savestate.registersave or not savestate.registerload then --registersave/registerload are unavailable in some emus
	print("With this emulator, loading a save during a macro will cause desync.")
end

local guiregisterhax = FCEU or pcsx --exploit that allows checking for hotkeys while paused

if input.registerhotkey then
	print("* Press Lua hotkey 1 for playback.")
	print("* Press Lua hotkey 2 for recording.")
	print("* Press Lua hotkey 3 to toggle pause after playback.")
	print("* Press Lua hotkey 4 to toggle loop mode or adjust wait incrementation.")
	print("* Press Lua hotkey 5 to show or hide hitboxes.")
else
	for _, key in ipairs({
		{playkey,        "for playback."},
		{recordkey,      "for recording."},
		{togglepausekey, "to toggle pause after playback."},
		{toggleloopkey,  "to toggle loop mode or adjust wait incrementation."},
	}) do
		if key[1] and type(key[1]) == "string" and not key[1]:find(" ") and key[1]:len() > 0 then
			print("* Press '" .. key[1] .. "' " .. key[2])
		else
			print("* No hotkey defined " .. key[2])
		end
	end
end

local nplayers,keymap,analog,useF_B

local function check_module(set) --check if reserved chars are being used and determine if it's OK to convert F/B to L/R
	local using = {}
	for _,key in ipairs(set.keymap or {}) do
		if key[1]:len() > 1 then
			print("Warning: symbol for '" .. (mame and key[3] or key[2]) .. "' ('" .. key[1] .. "') should be a single character.")
		end
		using[key[1]:upper()] = true
		for _,reserved in ipairs({".","W","_","^","*","+","-","<","/",">","(",")","[","]","$","&","#","!"}) do
			if key[1]:upper() == reserved then
				print("Warning: the reserved character '" .. key[1] .. "' is mapped to '" .. (mame and key[3] or key[2]) .. "'.")
			end
		end
	end
	for _,control in ipairs(set.analog or {}) do
		for _,reserved in ipairs({".","_","^","*","+","-","<","/",">","(",")","[","]","$","&","#","!"}) do
			if control[1]:find(reserved, 1, true) then
				print("Warning: the reserved character '" .. reserved .. "' is part of the '" .. (mame and control[3] or control[2]) .. "' symbol.")
			end
		end
		for letter = 1,control[1]:len() do
			using[control[1]:sub(letter, letter):upper()] = true
		end
	end
	useF_B = using.L and using.R and not (using.F or using.B)
end

local function add(symbol, name) --add keys to the generic module
	local newkey = {symbol = symbol}
	for p = 1,nplayers do
		newkey[p] = name:gsub("#", p)
		if newkey[p]:find(" Player Start") and p > 1 then
			newkey[p] = newkey[p]:gsub(" Player Start", " Players Start")
		end
	end
	table.insert(keymap, newkey)
	print(symbol .. "\t" .. name)
end

local function generic() --try to detect controls and make a generic module
	local c = joypad.get()
	local stick,nbuttons,label = {},0
	nplayers = 1
	for _,v in ipairs({{"L", "P1 Left"}, {"R", "P1 Right"}, {"U", "P1 Up"}, {"D", "P1 Down"}}) do
		if c[v[2]] ~= nil then
			table.insert(stick, v)
		end
	end
	for b = 10,1,-1 do
		for _,v in ipairs({"P1 Button " .. b, "P1 Fire " .. b}) do
			if c[v] ~= nil then
				nbuttons = b
				label = v:gsub("[(P1)(%d+)]", "")
				break
			end
		end
		if nbuttons > 0 then
			break
		end
	end
	for n = 4,1,-1 do
		if c["P"..n.." Button 1"] ~= nil or c["P"..n.." Fire 1"] ~= nil then
			nplayers = n
			break
		end
	end
	if #stick+nbuttons == 0 then
		print("generic module: found neither stick nor buttons")
		return
	end
	
	print("generic module: "..nplayers.."-player, "..(#stick > 0 and #stick .. "-way" or "no") .. " joystick, "..nbuttons.."-button")
	print("Symbol:\tCommand:")
	for _,v in ipairs(stick) do
		add(v[1], v[2]:gsub("P1 ", "P# "))
	end
	for b = 1,nbuttons do
		b = tostring(b)
		add(b, "P#" .. label .. b)
	end
	for _,start_button in ipairs({"1 Player Start", "P1 Start", "Start 1"}) do
		if c[start_button] ~= nil then
			add("S", start_button:gsub("1","#"))
			break
		end
	end
	for _,coin_button in ipairs({"Coin 1", "P1 Coin"}) do
		if c[coin_button] ~= nil then
			add("C", coin_button:gsub("1","#"))
			break
		end
	end
	if c["Reset"] then
		add("~", "Reset")
	end
	useF_B = true
	print()
end

local function findarcademodule()
	keymap,analog = {},{}
	for _,set in ipairs(arcade) do
		for _,romname in ipairs(type(set.games) == "table" and set.games or {set.games}) do
			if emu.romname() == romname or emu.parentname() == romname or emu.sourcename() == romname then
				print("Using " .. romname .. " module") print()
				nplayers = set.players or 0
				for _,key in ipairs(set.keymap or {}) do
					local newkey = {symbol = key[1]:upper()}
					for p = 1,nplayers do
						newkey[p] = (mame and key[3] or key[2]):gsub("#",p)
						if newkey[p]:find(" Player Start") and p > 1 then
							newkey[p] = newkey[p]:gsub(" Player Start", " Players Start")
						end
					end
					table.insert(keymap, newkey)
				end
				for _,key in ipairs(set.analog or {}) do
					local newkey = {symbol = key[1]:upper()}
					newkey.pattern = "^" .. newkey.symbol .. " ?%[([+-]?) ?([^%]]-) ?([hH]?) ?%]"
					newkey.spaces = math.max(6, key[1]:len()+1)
					for p = 1,nplayers do
						newkey[p] = (mame and key[3] or key[2]):gsub("#",p)
						if newkey[p] == "Dial 1" then
							newkey[p] = "Dial"
						end
					end
					table.insert(analog, newkey)
				end
				check_module(set)
				return
			end
		end
	end
	generic()
end

local function findmodule()
	keymap,analog = {},{}
	for _,set in ipairs(single) do
		for _,emuname in pairs(set.emulator or {}) do
			if emuname then
				nplayers = set.players or 0
				for _,key in ipairs(set.keymap or {}) do
					local newkey = {symbol = key[1]:upper()}
					for p = 1,nplayers do
						newkey[p] = key[2]
					end
					table.insert(keymap, newkey)
				end
				for _,key in ipairs(set.analog or {}) do
					local newkey = {symbol = key[1]:upper()}
					newkey.pattern = "^" .. newkey.symbol .. " ?%[([+-]?) ?([^%]]-) ?([hH]?) ?%]"
					newkey.spaces = math.max(6, key[1]:len()+1)
					for p = 1,nplayers do
						newkey[p] = key[2]
					end
					table.insert(analog, newkey)
				end
				check_module(set)
				return
			end
		end
	end
	error("No module found for this emulator in macro-modules.lua.",0)
end
----------------------------------------------
-- FRAME DATA BEGIN --------------------------

print("Frame data collector script")
print("July 5, 2011")
print("http://code.google.com/p/mame-rr/")
print()
print("WARNING! Set game to 'NORMAL' speed or you will get back incorrect data!")
print("> 'startup' is the period before the 1st active frame")
print("> hitfreeze '*' means the attacker did not get frozen")
print("Lua hotkey 1: insert blank line")

local print_header = function()
	print("startup\tatkrecov.\thitstun\tfr.adv.\thitfreeze")
end

local print_results = function(c)
	print(string.format("%d\t%d\t%d\t%+d\t%d%s\t%s", 
		c.startup, c.atkrecov, c.hitstun, c.advantage, c.hitfreeze, c.non_projectile, c.freeze_details))
end

local profile = {
	{
		games = {"sf2"}, class = "sf2",
		address = {0xFF83C6, 0xFF86C6, projectile_slowdown = 0xFF82E2},
	},
	{
		games = {"sf2ce", "sf2hf"}, class = "sf2",
		address = {0xFF83BE, 0xFF86BE, projectile_slowdown = 0xFF82E2},
		no_frameskip = function() memory.writebyte(0xFF02BE, 0x00) end,
	},
	{
		games = {"ssf2t"}, class = "sf2",
		address = {0xFF844E, 0xFF884E, projectile_slowdown = 0xFF82F2},
		no_frameskip = function() memory.writebyte(0xFF8CD3, 0xFF) end,
		superfreeze = function(addr) return memory.readbyte(addr + 0x1FA) == 0x01 end,
	},
	{
		games = {"ssf2"}, class = "sf2",
		address = {0xFF83CE, 0xFF87CE, projectile_slowdown = 0xFF82F2},
	},
	{
		games = {"hsf2"}, class = "sf2",
		address = {0xFF833C, 0xFF873C, projectile_slowdown = 0xFF8C29},
		superfreeze = function(addr) return memory.readbyte(addr + 0x1FA) == 0x01 end,
	},
	{
		games = {"sfa"}, class = "sfa",
		hitfreeze = function(addr) return memory.readbyte(addr + 0x04F) ~= 0x00 end,
		superfreeze = function(addr) return memory.readbyte(0xFFAE84) ~= 0x00 end,
		delay = {startup = 0, atk_recover = 1, hit_recover = 0, prefreeze = 0, superfreeze = 10, postfreeze = {["*"] = 4, [""] = -4}},
	},
	{
		games = {"sfa2", "sfz2al"}, class = "sfa",
		hitfreeze = function(addr) return memory.readbyte(addr + 0x05F) ~= 0x00 end,
		superfreeze = function(addr) return memory.readbyte(0xFF8125) ~= 0x00 end,
		delay = {startup = -1, atk_recover = 1, hit_recover = 0, prefreeze = 0, superfreeze = 10, postfreeze = {["*"] = 4, [""] = -4}},
	},
	{
		games = {"sfa3"},
		address = {0xFF8400, 0xFF8800},
		attacking = function(addr)
			return (
				memory.readbyte(addr + 0x0A9) == 0x01 or --normal attack
				memory.readbyte(addr + 0x0CE) == 0x01 or --special
				memory.readbyte(addr + 0x005) == 0x04 --normal throw
			)
		end,
		supering  = function(addr) return memory.readbyte(addr + 0x216) == 0x01 end,
		hurt      = function(addr) return memory.readbyte(addr + 0x005) == 0x02 end,
		thrown    = function(addr) return memory.readbyte(addr + 0x005) == 0x06 end,
		hitfreeze = function(addr) return memory.readbyte(addr + 0x05F) ~= 0x00 end,
		superfreeze = function(addr) return memory.readbyte(0xFF8125) ~= 0x00 end,
		delay = {startup = -1, atk_recover = 1, hit_recover = 0, prefreeze = 0, superfreeze = 0, postfreeze = {["*"] = -4, [""] = -4}},
	},
	{
		games = {"dstlk"}, class = "dstlk",
		address = {0xFF8388, 0xFF8788},
	},
	{
		games = {"nwarr"}, class = "dstlk",
		address = {0xFF8388, 0xFF8888},
	},
	{
		games = {"vsav","vhunt2","vsav2"},
		address = {0xFF8400, 0xFF8800},
		attacking = function(addr) return memory.readbyte(addr + 0x105) == 0x01 end,
		supering  = function(addr) return memory.readbyte(addr + 0x006) == 0x12 end,
		hurt      = function(addr) return memory.readbyte(addr + 0x005) == 0x02 end,
		thrown    = function(addr) return memory.readbyte(addr + 0x005) == 0x06 end,
		hitfreeze = function(addr) return memory.readbyte(addr + 0x05C) ~= 0x00 end,
		delay = {startup = -1, atk_recover = 1, hit_recover = 1},
	},
	{
		games = {"sfiii"}, class = "sf3",
		address = {0x0200D18C, 0x0200D564},
		super_frozen  = 0x390,
		super_shadows = 0x398,
	},
	{
		games = {"sfiii2"}, class = "sf3",
		address = {0x0200E504, 0x0200E910},
		super_frozen  = 0x3B4,
		super_shadows = 0x3BC,
	},
	{
		games = {"sfiii3"}, class = "sf3",
		address = {0x02068C6C, 0x02069104},
		super_frozen  = 0x41C,
		super_shadows = 0x424,
	},
}

local fill_out = {
	["sf2"] = function(game2)
		game2.attacking = function(addr) return memory.readbyte(addr + 0x18B) == 0x01 end
		game2.hurt      = function(addr) return memory.readbyte(addr + 0x003) >= 0x0E end
		game2.thrown    = function(addr) return memory.readbyte(addr + 0x063) == 0xFF end
		game2.hitfreeze = function(addr) return memory.readbyte(addr + 0x047) ~= 0x00 end
		game2.delay = {startup = -1, atk_recover = 0, hit_recover = 0, 
			prefreeze = 0, superfreeze = -1, postfreeze = {["*"] = 0, [""] = 0}}
	end,

	["sfa"] = function(game2)
		game2.address = {0xFF8400, 0xFF8800}
		game2.attacking = function(addr)
			return (
				memory.readbyte(addr + 0x132) == 0x01 or --normal attack
				memory.readbyte(addr + 0x006) == 0x0E or --special
				memory.readbyte(addr + 0x005) == 0x04 --normal throw
			)
		end
		game2.supering  = function(addr) return memory.readbyte(addr + 0x006) == 0x10 end
		game2.hurt      = function(addr) return memory.readbyte(addr + 0x005) == 0x02 end
		game2.thrown    = function(addr) return memory.readbyte(addr + 0x005) == 0x06 end
	end,

	["dstlk"] = function(game2)
		game2.attacking = function(addr)
			return (
				memory.readbyte(addr + 0x005) == 0x02 or --normal attack
				memory.readbyte(addr + 0x004) == 0x10 or --special
				memory.readbyte(addr + 0x004) == 0x0E or --throw
				memory.readbyte(addr + 0x088) == 0x01 --special recovery
			)
		end
		game2.supering = function(addr)
			return (
				memory.readbyte(addr + 0x004) == 0x10 or --special
				memory.readbyte(addr + 0x004) == 0x0E or --throw
				memory.readbyte(addr + 0x088) == 0x01 --special recovery
			)
		end
		game2.hurt      = function(addr) return memory.readbyte(addr + 0x004) == 0x0C end
		game2.thrown    = function(addr) return memory.readbyte(addr + 0x004) == 0x12 end
		game2.hitfreeze = function(addr) return memory.readbyte(addr + 0x04B) ~= 0x00 end
		game2.delay = {startup = 0, atk_recover = 1, hit_recover = 1}
		game2.update = {func = emu.registerbefore, cycle = 4}
	end,

	["sf3"] = function(game2)
		game2.attacking = function(addr)
			return memory.readword(addr + 0x026) == 0x0002 or memory.readword(addr + 0x026) == 0x0004
		end
		game2.supering  = function(addr) return memory.readword(addr + game2.super_shadows) == 0x0001 end
		game2.hurt      = function(addr) return memory.readword(addr + 0x026) == 0x0001 end
		game2.thrown    = function(addr) return memory.readword(addr + 0x026) == 0x0003 end
		game2.hitfreeze = function(addr, opp_addr)
			return memory.readword(addr + 0x044) ~= 0x0000 and 
				(memory.readbyte(addr + game2.super_frozen) == 0x00 and memory.readbyte(opp_addr + game2.super_frozen) == 0x00)
		end
		game2.superfreeze = function(addr, opp_addr)
			return memory.readword(addr + 0x044) ~= 0x0000 and 
				(memory.readbyte(addr + game2.super_frozen) == 0x01 or memory.readbyte(opp_addr + game2.super_frozen) == 0x01)
		end
		game2.delay = {startup = 0, atk_recover = 0, hit_recover = 0, 
			prefreeze = 0, superfreeze = 1, postfreeze = {["*"] = -4, [""] = -3}}
	end,
}

for _, game2 in ipairs(profile) do
	game2.update = game2.update or {func = emu.registerafter, cycle = 1}
	if game2.class then
		fill_out[game2.class](game2)
	end
end

--------------------------------------------------------------------------------

local game2, player_old, count, register_count, last_frame
local super_mode = false

input.registerhotkey(1, function()
	print()
end)

input.registerhotkey(2, function()
	if not game2.supering then
		return
	end
	super_mode = not super_mode
	print() print("now tracking: " .. (super_mode and "super moves only" or "all moves"))
	print_header()
end)


local function initialize_count()
	count = {active = true, total = 0, total_superfreeze = 0, hitfreeze = 0, non_projectile = "*", freeze_details = ""}
end

local function initialize()
	if mo_enable_frame_data == true then
		player_old = {{}, {}}
		register_count, last_frame = 0, 0
		initialize_count()
	end
end


local get_attack_state = {
	[false] = function(addr) --non-super mode
		return game2.attacking(addr)
	end,

	[true] = function(addr) --super mode
		return game2.supering(addr)
	end,
}

local function update_frame_data()
	if game2.address.projectile_slowdown and
		memory.readbyte(game2.address[1] + 0x02) ~= 0x04 and memory.readbyte(game2.address[2] + 0x02) ~= 0x04 then
		memory.writebyte(game2.address.projectile_slowdown, 0) --disable projectile slowdown
	end
	if game2.no_frameskip then
		game2.no_frameskip() --disable frameskip
	end

	local fd_player = {{}, {}}
	for p = 1, 2 do --get the current status of the players from RAM
		local addr = game2.address[p]
		local opp_addr = (p == 1 and game2.address[2]) or game2.address[1]
		fd_player[p].attacking   = get_attack_state[super_mode](addr)
		fd_player[p].hurt        = game2.hurt(addr)
		fd_player[p].thrown      = game2.thrown(addr)
		fd_player[p].hitfreeze   = game2.hitfreeze(addr, opp_addr)
		fd_player[p].superfreeze = game2.superfreeze and game2.superfreeze(addr, opp_addr)
	end

	if not count.active and fd_player[1].attacking and not player_old[1].attacking then --check for start of the attack
		initialize_count()
	end

	if count.active and not count.startup then --check for hit
		if fd_player[1].superfreeze and not player_old[1].superfreeze and not count.prefreeze then --superfreeze just started
			count.prefreeze = count.total + game2.delay.prefreeze
		elseif player_old[1].superfreeze and not fd_player[1].superfreeze then --superfreeze just ended
			count.superfreeze = count.total - count.prefreeze
		end

		if fd_player[2].hurt and not player_old[2].hurt then --attack hit
			count.startup = count.total + game2.delay.startup
		elseif fd_player[2].thrown and not player_old[2].thrown then --throw grabbed
			count.startup = count.total
		elseif not fd_player[1].attacking then --attack whiffed; stop counting
			count.active = false
		end
	end

	if count.startup and not count.atkrecov then
		if player_old[1].hurt and not fd_player[1].hurt then --check if the attacker got hit/traded
			count.atkrecov = count.total - count.hitfreeze - count.startup + game2.delay.hit_recover
		elseif player_old[1].attacking and not (fd_player[1].attacking or fd_player[1].hurt) then --check for attacker recovery
			count.atkrecov = count.total - count.hitfreeze - count.startup + game2.delay.atk_recover
		end
	end

	if count.startup and --check for dummy recovery
		(player_old[2].hurt or player_old[2].thrown) and not (fd_player[2].hurt or fd_player[2].thrown) then
		count.hitstun  = count.total - count.hitfreeze - count.startup + game2.delay.hit_recover
	end

	if count.active and count.atkrecov and count.hitstun then --print results and stop counting
		count.advantage = count.hitstun - count.atkrecov
		if not count.non_projectile then --if it was a projectile...
			count.atkrecov = count.atkrecov + count.hitfreeze --...then p1 didn't have any hitfreeze so add it back
		end
		if count.prefreeze then
			count.superfreeze = count.superfreeze + game2.delay.superfreeze
			count.postfreeze = count.startup - count.superfreeze + game2.delay.postfreeze[count.non_projectile]
			count.startup = count.prefreeze + count.postfreeze
			count.freeze_details = count.prefreeze .. " (" .. count.superfreeze .. ") " .. count.postfreeze
		end
		print_results(count)
		count.active = false
	end

	player_old = fd_player

	if (fd_player[1].superfreeze or fd_player[2].superfreeze) then --check for superfreeze
		count.total_superfreeze = count.total_superfreeze + 1
	end
	if fd_player[1].hitfreeze or fd_player[2].hitfreeze then --check for hitfreeze
		count.hitfreeze = count.hitfreeze + 1
	end
	if fd_player[1].hitfreeze then
		count.non_projectile = "" --only a non-projectile would freeze p1 (remove the "*")
	end
	count.total = count.total + 1

	if count.active then --display count if counting
		emu.message(count.total .. " (" .. count.total_superfreeze .. ")" .. " [" .. count.hitfreeze .. "]")
	end
end

--------------- FRAME DATA END ------------

if fba or mame then
	local inp_display_script = "input-display.lua"
	if not io.open(inp_display_script, "r") then
		print("Warning: unable to open '" .. inp_display_script .. "'")
	end
	emu.registerstart(function()
	-- frame data config 
	if mo_enable_frame_data == true then 
		game2 = nil
		-- emu.registerbefore(function() end)
		-- emu.registerafter(function() end)
		super_mode = false
		initialize()
		print()
		for n, module in ipairs(profile) do
			for m, shortname in ipairs(module.games) do
				if emu.romname() == shortname or emu.parentname() == shortname then
					game2 = module
					print("tracking " .. shortname .. " frame data")
					if fba and (emu.sourcename() == "CPS1" or emu.sourcename() == "CPS2") then
						print("Warning: FBA gives inaccurate results for CPS1/CPS2.")
					end
					if game2.supering then
						print("Lua hotkey 2: toggle normal/super-only mode")
					end
					if game2.no_frameskip then
						print("* disabling frameskip")
					end
					if game2.address.projectile_slowdown then
						print("* disabling projectile slowdown")
					end
					print()
					print_header()


				end
			end
		end
		print("not prepared for " .. emu.romname() .. " frame data")
		end
		whatgame()
		if io.open(inp_display_script, "r") then
			dofile(inp_display_script, "r")
		end
		print()
		findarcademodule()
	end)
else
	print()
	findmodule()
end

local hold,press = {},{}
for p = 1,nplayers do hold[p],press[p] = {},{} end

----------------------------------------------------------------------------------------------------
--[[ Set up the playback variables and functions. ]]--

local line,frame,nextkey,inputstream,macrosize,inbrackets,bracket,player,stateop,stateslot,op,slot,tempframe,junk,keytable
local wait,dumpmode,loopmode = {}

local statekeys = {["$"] = "save", ["&"] = "load"}

local function updatestream(p, f) --Inject holds and presses into the inputstream.
	for _,key in ipairs(keymap) do
		if hold[p][key.symbol] or press[p][key.symbol] then
			inputstream[f] = inputstream[f] or {}
			inputstream[f][p] = inputstream[f][p] or {}
			inputstream[f][p][key.symbol] = true
		end
	end
	for _,control in ipairs(analog) do
		if press[p][control.symbol] then
			inputstream[f] = inputstream[f] or {}
			inputstream[f][p] = inputstream[f][p] or {}
			inputstream[f][p][control.symbol] = press[p][control.symbol]
		elseif hold[p][control.symbol] then
			inputstream[f] = inputstream[f] or {}
			inputstream[f][p] = inputstream[f][p] or {}
			inputstream[f][p][control.symbol] = hold[p][control.symbol]
		end
	end
	press[p] = {} --Clear keypresses at the end of the frame.
end

local function warning(msg, expr)
	if expr == true then
		if not macrosize then
			print("Warning (line " .. line .. ", frame " .. frame .. "):", msg)
		else
			print("Warning:", msg)
		end
		return true
	end
end

local function endframe()
	nextkey = press
	if tempframe then --Resolve save/load ops with the now-correct frame number.
		stateop[frame] = statekeys[op]
		stateslot[frame] = slot
		op,slot,tempframe = nil,nil,nil
	end
end

local funckeys = {
	["."] = function()
		frame = frame+1
		if not inbrackets then
			for p = 1,nplayers do
				updatestream(p, frame)
			end
		else
			updatestream(player, frame)
		end
		endframe()
	end,
	
	["_"] = function() nextkey = hold end,
	
	["^"] = function() nextkey = nil end,
	
	["*"] = function() hold[player] = {} end,
	
	["+"] = function()
		if warning("cannot use '+' in brackets", inbrackets) then return end
		if warning("used '+' but already controlling player 1", player == 1) then return end
		player = 1
	end,
	
	["-"] = function()
		if warning("cannot use '-' in brackets", inbrackets) then return end
		if warning("used '-' but already controlling player " .. player, player >= nplayers) then return end
		player = player+1
	end,
	
	["<"] = function()
		if warning("used '<' but brackets are already open", inbrackets) then return end
		inbrackets = true
		player = 1
		bracket[0] = frame
	end,
	
	["/"] = function()
		if warning("can only use '/' in brackets", not inbrackets) then return end
		if warning("used '/' but already controlling player " .. player, player >= nplayers) then return end
		bracket[player] = frame
		player = player+1
		frame = bracket[0]
	end,
	
	[">"] = function()
		if warning("used '>' but brackets are not open", not inbrackets) then return end
		bracket[player] = frame
		local highest = bracket[0]
		for p = 1,nplayers do
			bracket[p] = bracket[p] or bracket[0]
			if bracket[p] > highest then
				highest = bracket[p]
			end
		end
		for p = 1,nplayers do
			while bracket[p] <= highest do
				updatestream(p, bracket[p])
				bracket[p] = bracket[p]+1
			end
		end
		frame = highest
		bracket = {}
		inbrackets = false
		player = 1
		endframe()
	end,
}

local function digest(m)
	local char = m:sub(1, 1) --Take the first character.
	for func in pairs(funckeys) do --Look for special function characters.
		if char == func then
			warning("followed '_' with non-game key '" .. func .. "'", nextkey == hold)
			warning("followed '^' with non-game key '" .. func .. "'", nextkey == nil)
			funckeys[func]()
			return m:sub(2)
		end
	end

	local capture_start, capture_end = m:find("^[%$&] ?%d+") --Look for save/load ops.
	if capture_end then
		m:gsub("^([%$&]) ?(%d+)", function(o, s) --Queue save/load ops before parsing the controls.
			op, slot, tempframe = o, s, frame --The frame number is not correct until the rest of the frame is parsed.
			return
		end)
		return m:sub(capture_end + 1)
	end

	for _,control in ipairs(analog or {}) do --Look for analog controls.
		local capture_start, capture_end = m:upper():find(control.pattern)
		if capture_end then
			m:upper():gsub(control.pattern, function(sign, val, hex)
				val = tonumber(val, hex:len() > 0 and 16 or 10)
				if warning("Invalid analog value: '" .. m:sub(capture_start, capture_end) .. "'", not val) then return end
				val = (sign == "-" and -1 or 1) * val
				if nextkey == hold then --holds can cancel prior holds
					press[player][control.symbol] = nil
					hold[player][control.symbol] = val
				else --press or release to cancel holds
					press[player][control.symbol] = val
					hold[player][control.symbol] = nil
				end
				nextkey = press
				return
			end)
			return m:sub(capture_end + 1)
		end
	end

	if useF_B and char:upper() == "F" then --Convert F/B to L/R depending on player.
		char = player%2 == 0 and "L" or "R"
	elseif useF_B and char:upper() == "B" then
		char = player%2 == 0 and "R" or "L"
	end
	for _,key in ipairs(keymap) do --Look for game keys.
		if char:upper() == key.symbol:upper() then
			if not nextkey then --release
				hold[player][key.symbol] = nil
			else --press or hold
				warning("'" .. key.symbol .. "' is already pressed by player " .. player, press[player][key.symbol])
				warning("'" .. key.symbol .. "' is already held by player " .. player, hold[player][key.symbol])
				nextkey[player][key.symbol] = true
			end
			nextkey = press
			return m:sub(2)
		end
	end

	for _,space in ipairs({" ",",","\t"}) do --Remove commas, spaces and tabs.
		if char == space then
			return m:sub(2)
		end
	end
	for _,linebreak in ipairs({"\n","\r"}) do --Remove linebreaks.
		if char == linebreak then
			line = line+1
			return m:sub(2)
		end
	end

	warning("'" .. char .. "' is unrecognized", char:len() > 0) --invalid character
	junk = junk .. char
	return m:sub(2)
end

----------------------------------------------------------------------------------------------------
--[[ Read, interpret, and perform cleanup on the playback macro. ]]--

local function preparse(macro)
	local file = path:gsub("\\", "/") .. macro
	if not io.open(file, "r") then
		print("Error: unable to open '" .. file .. "'")
		return
	end
	local file = io.input(file)
	local m = "\n" .. file:read("*a") .. "\n" --Open and read the file.
	file:close() --Close the file.
	if framemame and (fba or mame) then --Remove frameMAME audio commands.
		m = m:gsub("[aA][cCsS] ?%d+", "")
		m = m:gsub("[aA][rR] ?%d+ %d+", "")
		m = m:gsub("[aA][mM!]", "")
	end
	m = m:gsub("([\n\r][^#]-)!.*", "%1") --Remove everything after the first uncommented "!".
	m = m:sub(2) --Remove initial linebreak that was inserted
	m = m:gsub("#.-[\n\r]", "\n") --Remove lines commented with "#".
	dumpmode = m:find("%?%?%?") --Determine whether to dump to text file.
	m = m:gsub("%?%?%?", "", 1) --Remove the first "???".
	local first, last = m:find("[wW] ?%d+ ?%?") --Detect if incremental wait is present
	if first and last then
		wait.before = m:sub(1, first-1)
		wait.duration = m:sub(first, last):gsub("%D", "")
		wait.after = m:sub(last+1)
		wait.increment, wait.change = 1, " (increasing)"
		m = wait.before .. "W" .. wait.duration .. "," .. wait.after
	end
	return m
end

local function parse(macro)
	local m = (wait.duration and wait.before .. "W" .. wait.duration .. "," .. wait.after) or preparse(macro)
	if not m then return end
	m = m:gsub("[wW] ?(%d+)", function(n) return string.rep(".", n) end) --Expand waits into dots.
	while m:find("%b() ?%d+") do --Recursively..
		m = m:gsub("(%b()) ?(%d+)", function(s, n) --..expand ()n loops..
			s = s:sub(2, -2) .. "," --..and remove the parentheses.
			return s:rep(n)
		end)
	end

	line,frame,macrosize,player,junk = 1,0,nil,1,"" --Initialize parameters.
	inputstream,stateop,stateslot = {},{},{}
	nextkey,inbrackets,bracket = press,false,{}

	while string.len(m) > 0 do --Process the macro string piece by piece
		m = digest(m)
	end
	if tempframe then --Clear save/load strings at the end that don't have a frame advance.
		endframe()
	end
	macrosize = frame

	warning("input left unprocessed: " .. junk, junk:len() > 0) --Report anything left unresolved.

	if warning("brackets were left open.", inbrackets) then char(">") end --Check if brackets still open.

	for p = 1,nplayers do --Check for keys still pressed.
		local leftovers = ""
		for k in pairs(press[p]) do
			leftovers = leftovers .. k
		end
		if warning("player " .. p .. " was left pressing " .. leftovers .. " without frame advance", leftovers ~= "") then
			press[p] = {}
		end
	end

	for p = 1,nplayers do --Check for keys still held.
		local leftovers = ""
		for k in pairs(hold[p]) do
			leftovers = leftovers .. k
		end
		if warning("player " .. p .. " was left holding " .. leftovers, leftovers ~= "") then hold[p] = {} end
	end

	frame = 0
	return frame
end

----------------------------------------------------------------------------------------------------
--[[ Set up the recording variables and functions. ]]--

local recframe,recinputstream

if type(longwait) ~= "number" or longwait < 0 then
	print("Using default longwait: 4")
	longwait = 4
end
if type(longpress) ~= "number" or longpress < 0 then
	print("Using default longpress: 10")
	longpress = 10
end
if type(longline) ~= "number" or longline < 0 then
	print("Using default longline: 60")
	longline = 60
end

local waitstring = string.rep("%.", longwait)
local longstring = string.rep("[^\n]", longline)

local function finalize(t)
	if recframe == 0 then
		print("Stopped recording after zero frames.") print()
		return
	end
	
	--Determine how many players were active.
	local activeplayers = 0
	for p = nplayers,1,-1 do
		for f = 1,recframe do
			if t[f] and t[f][p] then
				activeplayers = p
				break
			end
		if activeplayers > 0 then break end
		end
	end
	if activeplayers == 0 then
		print("Stopped recording: No input was entered in", recframe, "frames.") print()
		return
	end
	
	--Substitute _holds and ^releases for long press sequences.
	if longpress > 0 then
		for p = 1,activeplayers do
			for _,key in ipairs(keymap) do
				local hold,release,pressed,oldpressed = 0,0,false,false
				for f = 1,recframe+1 do
					pressed = t[f] and t[f][p] and t[f][p]:find(key.symbol)
					if pressed and not oldpressed then hold = f end
					if not pressed and oldpressed then release = f
						if release-hold >= longpress then --only hold if the press is long
							t[release] = t[release] or {}
							t[release][p] = t[release][p] or ""
							if f == recframe+1 then recframe = f end --add another frame to process the release if necessary
							for fr = hold,release do t[fr][p] = t[fr][p]:gsub(key.symbol, "") end --take away the presses
							t[hold][p] = t[hold][p] .. "_" .. key.symbol --add the hold at the beginning
							t[release][p] = t[release][p] .. "^" .. key.symbol --add the release at the end
						end
					end
					oldpressed = pressed
				end
			end
		end
	end
	
	--Compose the text in bracket format.
	local text = "# " .. (emu.romname and emu.romname() .. " " or "") .. os.date() .. "\n\n"
	local sep = "<"
	for p = 1,activeplayers do
		local str = sep .. " # Player " .. p .. "\n"
		for f = 1,recframe do
			str = str .. (t[f] and t[f][p] or "") .. "."
		end
		text = text .. str .. "\n\n"
		sep = "/"
	end
	t = nil
	text = text .. ">\n"
	
	--If only Player 1 is active, get rid of the brackets.
	if not text:find("\n/") then
		text = text:gsub("< # Player 1\n", "")
		text = text:gsub("\n\n>", "")
	end
	
	--Collapse long waits into W's.
	if longwait > 0 then
		text = text:gsub("([\n%.])(" .. waitstring .. "+)", function(c,n)
			return c .. "W" .. string.len(n) .. ","
		end)
	end
	text = text:gsub(",\n", "\n") --Remove trailing commas.
	
	--Break up long lines.
	if longline > 0 then
		local startpos,endpos = 0,0
		local before,after = text:sub(1, endpos), text:sub(endpos+1)
		while after:find("\n(" .. longstring .. ".-),") do --Search for a long stretch w/o breaks.
			text = before .. after:gsub("\n(" .. longstring .. ".-),", function(line) --Insert a break after the next comma.
				return "\n" .. line .. ",\n"
			end, 1) --Do this once per search.
			startpos,endpos = text:find("\n(" .. longstring .. ".-),", endpos) --Advance the start of the next search.
			before,after = text:sub(1, endpos), text:sub(endpos+1)
		end
	end
	
	--Save the text.
	local prefix = emu.romname and emu.romname() .. "-" or ""
	local filename = prefix .. os.date("%Y-%m-%d_%H-%M-%S") .. ".mis"
	if playbackfile == "last_recording.mis" then
		filename = "last_recording.mis"
	end
	local file = io.output(path:gsub("\\", "/") .. filename)
	file:write(text) --Write to file.
	file:close() --Close the file.
	print("Recorded", recframe, "frames to", filename .. ".") print()
end

----------------------------------------------------------------------------------------------------
--[[ Set up the variables and functions for user control of playback and recording. ]]--

local playing,recording,pauseafterplay,pausenow,framediff = false,false,false,false

local function bulletproof(active, f1, f2, t1, t2) --1 = current, 2 = loaded
	if not active then return false end
	if f1 == 0 then return true end --loading on 0th frame is always OK
	if not t2 then
		print("Error: loaded state has no macro data")
		return false
	end
	for f = 1,f2 do
		if type(t1[f]) ~= type(t2[f]) then --one has data in a table, the other is empty/nil
			print("Error: loaded macro does not match current macro on frame " .. f)
			return false
		elseif t1[f] and t2[f] then --both are tables with nonblank data
			for p = 1,nplayers do
				if t1[f][p] ~= t2[f][p] then
					print("Error: loaded macro does not match current macro on frame " .. f)
					return false
				end
			end
		end
	end
	print("Resumed from frame " .. f2) --no errors
	return true
end

if savestate.registersave and savestate.registerload then --registersave/registerload are unavailable in some emus

	savestate.registersave(function(slot)
		if mame then return emu.framecount(), draw, inp, idle end
		if playing then print("Saved progress to slot", slot, "while playing frame", frame) end
		if recording then print("Saved progress to slot", slot, "while recording frame", recframe) end
		if playing or recording then return frame, inputstream, macrosize, recframe, recinputstream end
	end)
	
	savestate.registerload(function(slot)
		initialize()
		initialize_fb()
		_, draw, inp, idle = savestate.loadscriptdata(slot)
		if type(draw) ~= "table" then draw = { [1] = true, [2] = true } end
		if type(inp)  ~= "table" then inp  = { [1] =   {}, [2] =   {} } end
		if type(idle) ~= "table" then idle = { [1] =    0, [2] =    0 } end
		if mame then
			framediff = savestate.loadscriptdata(slot)
			if playing and not framediff then
				--[[if not (wait.duration or loopmode) then
					print("Savestate " .. slot .. " has no framecount data. This macro may not play correctly!")
					print("Resave this savestate with the script running and idle to avoid problems.")
				end]]
				framediff = emu.framecount()
			end
			return
		end
		if not playing and not recording then
			return
		end
		if playing and not loopmode then
			print("Loaded from slot", slot, "while playing frame", frame)
		end
		if recording then
			print("Loaded from slot", slot, "while recording frame", recframe)
		end
		local tmp = {}
		tmp.frame,tmp.inputstream,tmp.macrosize,tmp.recframe,tmp.recinputstream = savestate.loadscriptdata(slot)
		playing = bulletproof(playing,frame,tmp.frame,inputstream,tmp.inputstream)
		recording = bulletproof(recording,recframe,tmp.recframe,recinputstream,tmp.recinputstream)
		frame          = tmp.frame          or frame
		inputstream    = tmp.inputstream    or inputstream
		macrosize      = tmp.macrosize      or macrosize
		recframe       = tmp.recframe       or recframe
		recinputstream = tmp.recinputstream or recinputstream
	end)
	
end

local function dostate(f)
	if stateop[f+1] then
		if savestate.create and savestate[stateop[f+1]] then
			savestate[stateop[f+1]](savestate.create(stateslot[f+1])) return
		elseif savestate[stateop[f+1]] then
			savestate[stateop[f+1]](stateslot[f+1]) return
		end
		warning("cannot do savestates with Lua in this emulator",true)
	end
end

local function dumpinputstream()
	if not dumpmode then return end
	local dump = ""
	for p = 1,nplayers do --header row
		dump = dump .. "|"
		for _,key in ipairs(keymap) do
			dump = dump .. key.symbol
		end
		for _,control in ipairs(analog) do
			dump = dump .. string.format("%"..control.spaces.."s", control.symbol)
		end
	end
	dump = dump .. "|\n"
	for f = 1,macrosize do --frame rows
		for p = 1,nplayers do
			dump = dump .. "|"
			for _,key in ipairs(keymap) do
				if inputstream[f] and inputstream[f][p] and inputstream[f][p][key.symbol] then
					dump = dump .. key.symbol
				else
					dump = dump .. "."
				end
			end
			for _,control in ipairs(analog) do
				if inputstream[f] and inputstream[f][p] and inputstream[f][p][control.symbol] then
					local number = string.format("%X", math.abs(inputstream[f][p][control.symbol]))
					dump = dump .. string.format("%"..control.spaces.."s", (inputstream[f][p][control.symbol] < 0 and "-" or "") .. number)
				else
					dump = dump .. string.rep(" ", control.spaces)
				end
			end
		end
		if stateop[f] and stateslot[f] then
			dump = dump .. "| " .. stateop[f] .. " slot " .. stateslot[f] .. "\n"
		else
			dump = dump .. "|\n"
		end
	end
	local filename = playbackfile:gsub("%....$", "")
	filename = filename .. "-inputstream.txt"
	local file = io.output(path:gsub("\\", "/") .. filename)
	file:write(dump) --Write to file.
	file:close() --Close the file.
	print("Converted " .. playbackfile .. " to " .. filename .. " (" .. macrosize .. " frames)") print()
	return true
end

local function playcontrol(silent)
	if not playing then
		if not parse(playbackfile) or warning("Macro is zero frames long.", macrosize == 0) or dumpinputstream(dumpmode) then
			return
		end
		if not silent then
			print("Now playing " .. playbackfile .. " (" .. macrosize .. " frames)" .. (loopmode and " in loop mode" or wait.duration and " in incremental wait mode" or ""))
		end
		dostate(frame)
		playing = true
		framediff = emu.framecount()
	else 
		playing = false
		inputstream = nil
		if wait.duration then
			print("Stopped at wait duration = " .. wait.duration) print()
			wait = {}
		elseif loopmode then
			print("Stopped looping playback on frame " .. frame) print()
		else
			print("Canceled playback on frame " .. frame) print()
		end
	end
end

local function reccontrol()
	if not recording then
		recording = true
		recframe = 0
		recinputstream = {}
		print("Started recording.")
	else 
		recording = false
		finalize(recinputstream)
	end
end

emu.registerexit(function() --Attempt to save if the script exits while recording
	if recording then recording = false finalize(recinputstream) end
end)

local function togglepause()
	pauseafterplay = not pauseafterplay
	print("Pause after playback mode: " .. (pauseafterplay and "on" or "off"))
end

local function toggleloop()
	if wait.increment == 1 then
		wait.increment, wait.change = -1, " (decreasing)"
	elseif wait.increment == -1 then
		wait.increment, wait.change = 0, " (constant)"
	elseif wait.increment == 0 then
		wait.increment, wait.change = 1, " (increasing)"
	else
		loopmode = not loopmode
		print("Loop mode: " .. (loopmode and "on" or "off"))
	end
end

function togglehitbox()
	display_hitbox_default =  not display_hitbox_default
end
local oldplaykey,oldrecordkey,oldpausekey,oldloopkey

if input.registerhotkey then --use registerhotkey if available
	input.registerhotkey(1, function()
		playcontrol()
	end)

	input.registerhotkey(2, function()
		reccontrol()
	end)

	input.registerhotkey(3, function()
		togglepause()
	end)

	input.registerhotkey(4, function()
		toggleloop()
	end)

elseif guiregisterhax then --otherwise try to exploit the constantly running gui.register (fceux and pcsx)
	gui.register(function()
		local nowplaykey = input.get()[playkey]
		if nowplaykey and not oldplaykey then
			playcontrol()
		end
		oldplaykey = nowplaykey

		local nowrecordkey = input.get()[recordkey]
		if nowrecordkey and not oldrecordkey then
			reccontrol()
		end
		oldrecordkey = nowrecordkey

		local nowpausekey = input.get()[togglepausekey]
		if nowpausekey and not oldpausekey then
			togglepause()
		end
		oldpausekey = nowpausekey

		local nowloopkey = input.get()[toggleloopkey]
		if nowloopkey and not oldloopkey then
			toggleloop()
		end
		oldloopkey = nowloopkey
	end)
end

----------------------------------------------------------------------------------------------------
--[[ Perform playback and check for user input before the frame. ]]--

emu.registerbefore(function()
	if not input.registerhotkey and not guiregisterhax then --as a last resort, check for hotkeys the hard way (snes9x & vba)
		local nowplaykey = input.get()[playkey]
		if nowplaykey and not oldplaykey then
			playcontrol()
		end
		oldplaykey = nowplaykey

		local nowrecordkey = input.get()[recordkey]
		if nowrecordkey and not oldrecordkey then
			reccontrol()
		end
		oldrecordkey = nowrecordkey

		local nowpausekey = input.get()[togglepausekey]
		if nowpausekey and not oldpausekey then
			togglepause()
		end
		oldpausekey = nowpausekey

		local nowloopkey = input.get()[toggleloopkey]
		if nowloopkey and not oldloopkey then
			toggleloop()
		end
		oldloopkey = nowloopkey
	end
	
	--framediff check is necessary for emus where registerbefore runs multiple times per frame
	if playing and emu.framecount()-frame >= framediff then
		frame = frame+1
		dostate(frame)
		inputstream[frame] = inputstream[frame] or {}
		for p = 1,nplayers do
			inputstream[frame][p] = inputstream[frame][p] or {}
		end
		if fba or mame then --In fba and mame, joypad.set is called once without a player number.
			keytable = {}
			for p = 1,nplayers do
				for n,key in ipairs(keymap) do
					if inputstream[frame][p][key.symbol] then
						keytable[keymap[n][p]] = true
					end
				end
				for n,control in ipairs(analog) do
					if inputstream[frame][p][control.symbol] then
						keytable[analog[n][p]] = inputstream[frame][p][control.symbol]
					end
				end
			end
			if keytable["Reset"] == 1 and emu.softreset then emu.softreset() end
		else --In other emus, joypad.set is called separately for each player.
			keytable = {}
			for p = 1,nplayers do
				keytable[p] = joypad.getdown(p) --This allows lua+user input
				for n,key in ipairs(keymap) do
					if inputstream[frame][p][key.symbol] then keytable[p][keymap[n][p]] = true end
				end
			end
		end
		if frame > macrosize then
			playing = false
			inputstream = nil
			pausenow = pauseafterplay
			if wait.duration then
				wait.duration = wait.duration + wait.increment
				if wait.duration < 0 then wait.duration = 0 end
				playcontrol(true)
			elseif loopmode then
				playcontrol(true)
			else
				print("Macro finished playing.") print()
			end
		end
	end
	
	--must joypad.set the keytable with every registerbefore, even if multiple times per frame, to ensure all keys are sent
	if playing then
		if fba or mame then
			joypad.set(keytable)
		else
			for p = 1,nplayers do joypad.set(p, keytable[p]) end
		end
	end
end)

----------------------------------------------------------------------------------------------------
--[[ Perform recording and print status after the frame. ]]--

emu.registerafter(function() --recording is done after the frame, not before, to catch input from playing macros
---frame data config
	if mo_enable_frame_data == true then
	register_count = register_count + 1
	if register_count == game2.update.cycle then
		update_frame_data()
	end
	if last_frame < emu.framecount() then
		register_count = 0
	end
	last_frame = emu.framecount()
	end
-- end frame data config
margin[1] = margin_p1x*effective_width
	margin[2] = (emu.screenwidth and emu.screenwidth() or screenwidth)  - margin_p2x*effective_width
	margin[3] = margin_y*icon_size
	for player = 1, 2 do
		thisframe = {}
		filterinput(player, thisframe)
		compositeinput(thisframe)
		detectchanges(lastframe[player], thisframe)
		updaterecords(player, thisframe, inp[player])
		lastframe[player] = thisframe
	end
	update_hitboxes()
	for player = 1, 2 do
		if draw[player] then
			for line in pairs(inp[player]) do
				for index,row in pairs(inp[player][line]) do
					display(margin[player] + (index-1)*effective_width, margin[3] + (line-1)*icon_size, row)
				end
			end
		end
	end
	if recording then
		recframe = recframe+1
		for p = 1,nplayers do
			for n,key in ipairs(keymap or {}) do
				if joypad.get(p)[keymap[n][p]] == 1 or joypad.get(p)[keymap[n][p]] == true then
					recinputstream[recframe] = recinputstream[recframe] or {}
					recinputstream[recframe][p] = not recinputstream[recframe][p] and key.symbol or recinputstream[recframe][p] .. key.symbol
				end
			end
		end
	end

	if playing or recording then
		local pmesg = playing and ("macro playing: " .. frame .. "/" .. macrosize) or ""
		if wait.duration then
			pmesg = pmesg .. "; incremental wait: " .. wait.duration .. wait.change
		elseif loopmode then
			pmesg = pmesg .. " in loop mode"
		end
		local rmesg = recording and "macro recording: " .. recframe or ""
		emu.message(pmesg .. (playing and recording and "   " or "") .. rmesg)
	end
end)

----------------------------------------------------------------------------------------------------
--[[ Handle pausing in the while true loop. ]]--





while true do
	gui.register(function()
	if display_hud == true then
		hud()
	end
	projectile_onscreen(hud)
	if display_movelist == true then
		movelist()
	end 
	charaspecfic()
	for player = 1, 2 do
		if draw[player] then
			for line in pairs(inp[player]) do
				for index,row in pairs(inp[player][line]) do
					display(margin[player] + (index-1)*effective_width, margin[3] + (line-1)*icon_size, row)
				end
			end
		end
	end
	p1life()
	p2life()
	checked()
	timer()
end)
	if display_hitbox_default == true then
		render_hitboxes()
	end
	if pausenow then
		emu.pause()
		pausenow = false
	end
	emu.frameadvance()
end