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
	if globals.show_life == true then
		gui.text(18,16,"Red Life: " .. memory.readword(0xFF8452),0xFF0000FF)
		gui.text(99,16,"White Life: " .. memory.readword(0xFF8450))
	end
	if globals.show_meter == true then
		gui.text(34,207,"Meter: ".. memory.readword(0xFF850A))
	end
	if globals.show_place == true then
		gui.text(34,198,"Place: " .. memory.readdword(0xFF8410) .. "," .. memory.readdword(0xFF8414))
	end
	-- gui.text(0,0,"Taunts: " .. memory.readbyte(0xFF8579))
		
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
	if globals.show_life == true then
		gui.text(315,16,"Red Life: " .. memory.readword(0xFF8852),0xFF0000FF)
		gui.text(226,16,"White Life: " .. memory.readword(0xFF8850))
	end
	if globals.show_meter == true then
		gui.text(312,207,"Meter: ".. memory.readword(0xFF890A))
	end
	if globals.show_place == true then
		gui.text(260,198,"Place: " .. memory.readdword(0xFF8810) .. "," .. memory.readdword(0xFF8814))
	end
	-- gui.text(344,0,"Taunts: " .. memory.readbyte(0xFF8979))
		
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

-- ------------------------------------------------------------------
-- --Scrolling Input Display Originally by Dammit9x
-- ------------------------------------------------------------------

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
		{     "LP",     "Weak Punch", "Weak Punch" },
		{     "MP",   "Medium Punch", "Medium Punch" },
		{     "HP",   "Strong Punch", "Strong Punch" },
		{     "LK",      "Weak Kick", "Weak Kick" },
		{     "MK",    "Medium Kick", "Medium Kick" },
		{     "HK",    "Strong Kick", "Strong Kick" },
		{      "S",          "Start",    "Start" },
	}
}

local recordpath =  "scrolling-input" .. "/" .. "framedump" .. "/" --(relative to resourcepath)

require "gd"

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
	gui.gdoverlay(x, y, module[row].img)
end

display = image

if not io.open(resourcepath .. iconfile, "rb") then
	print("there Icon file " .. iconfile .. " not found.")
	print("Falling back on text mode.")
	display = text
end
file = io.open(resourcepath .. iconfile, "rb")

local function readimages()
	local scaled_width = icon_size
	if rescale_icons and emu.screenwidth and emu.screenheight then
		scaled_width = icon_size * emu.screenwidth()/emu.screenheight() / (4/3)
	end
	if display == image then
		local sourceimg = gd.createFromPng(resourcepath .. iconfile)
		image_icon_size = sourceimg:sizeX()/2
		for n, key in ipairs(module) do
			tmp = gd.createFromPngStr(blank_img_string)
			gd.copyResampled(tmp, sourceimg, 0, 0, 0,(n-1)*image_icon_size, scaled_width, icon_size, image_icon_size, image_icon_size)
			key.img=tmp:gdStr()
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

vsavScriptModule = {
    ["registerAfter"] = function()
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
	end,
	["registerSave"] = function(slot)
		return draw, inp, idle
	end,
	["registerLoad"] = function(slot)
		draw, inp, idle = savestate.loadscriptdata(slot)
		if type(draw) ~= "table" then draw = { [1] = true, [2] = true } end
		if type(inp)  ~= "table" then inp  = { [1] =   {}, [2] =   {} } end
		if type(idle) ~= "table" then idle = { [1] =    0, [2] =    0 } end
	end,
	["guiRegister"] = function()
		if globals.options.display_hud == true then
			hud()
		end
	
		projectile_onscreen(hud)
		if globals.options.display_movelist == true then
			movelist()
		end 
		charaspecfic()
			if draw[2] then
				for line in pairs(inp[2]) do
					for index,row in pairs(inp[2][line]) do
						display(margin[2] + (index-1)*effective_width, margin[3] + (line-1)*icon_size, row)
					end
				end
			end
	end,
	["runCheats"] = function()
		p1life()
		-- p2life()
		checked()
		timer()
	end
}
return vsavScriptModule