function stage_select()
    if 	globals.options.stage == 1 then
        return
    elseif globals.options.stage == 2 then
		memory.writeword(0xFF8100, 0x0000) -- 	Feast of the Damned
	elseif globals.options.stage == 3 then
		memory.writeword(0xFF8100, 0x0002) -- 	Concrete Cave
	elseif globals.options.stage == 4 then
		memory.writeword(0xFF8100, 0x0004) -- 	Tower of Arrogance
	elseif globals.options.stage == 5 then
		memory.writeword(0xFF8100, 0x0006) -- 	Red Thirst
	elseif globals.options.stage == 6 then
		memory.writeword(0xFF8100, 0x0008) -- 	Deserted Cheateu
	elseif globals.options.stage == 7 then
		memory.writeword(0xFF8100, 0x000A) -- 	Abaraya
	elseif globals.options.stage == 8 then
		memory.writeword(0xFF8100, 0x000C) -- 	Vanity Paradise
	elseif globals.options.stage == 9 then
		memory.writeword(0xFF8100, 0x000E) -- 	War Agony
	elseif globals.options.stage == 10 then
		memory.writeword(0xFF8100, 0x0010) -- 	Forever Torment
	elseif globals.options.stage == 11 then
		memory.writeword(0xFF8100, 0x0012) -- 	Green Scream
	elseif globals.options.stage == 12 then
		memory.writeword(0xFF8100, 0x0014) -- 	Iron Horse Iron Terror
	elseif globals.options.stage == 13 then
		memory.writeword(0xFF8100, 0x0016) -- 	Fetus of God 
	end
end

function ui_removal()
    if globals.options.hide_all_ui then
        -- print("removing")
        --P1 Portrait
        memory.writebyte(16735638, 0x00)
        memory.writebyte(16735640, 0x00)
        -- ???
        memory.writebyte(16735642, 0x00)
        memory.writebyte(16735644, 0x00)
        memory.writebyte(16735646, 0x00)
        -- P2 Portraits
        memory.writebyte(16735648, 0x00)
        memory.writebyte(16735650, 0x00)
        -- Top bar stuff
        memory.writebyte(16735652, 0x00)
        memory.writebyte(16735654, 0x00)
        memory.writebyte(16735656, 0x00)
        memory.writebyte(16735658, 0x00)
        memory.writebyte(16735660, 0x00)
        memory.writebyte(16735662, 0x00)
        memory.writebyte(16735664, 0x00)
        memory.writebyte(16735666, 0x00)
        memory.writebyte(16735668, 0x00)
        memory.writebyte(16735670, 0x00)
        memory.writebyte(16735672, 0x00)
        memory.writebyte(16735674, 0x00)
        memory.writebyte(16735676, 0x00)
        memory.writebyte(16735678, 0x00)
        memory.writebyte(16735680, 0x00)
        memory.writebyte(16735682, 0x00)
        memory.writebyte(16735684, 0x00)
        memory.writebyte(16735686, 0x00)
        memory.writebyte(16735688, 0x00)
        memory.writebyte(16735690, 0x00)
        memory.writebyte(16735692, 0x00)

        memory.writebyte(16735694, 0x00)
        memory.writebyte(16735696, 0x00)
        memory.writebyte(16735698, 0x00)
        memory.writebyte(16735700, 0x00)
        -- Lifebar?
        memory.writebyte(16735702, 0x00)
        memory.writeword(16735704, 0x0000)
        -- Lifebar pos
        memory.writebyte(16735708, 0x0)

        memory.writebyte(16735710, 0x00)
        memory.writebyte(16735712, 0x00)
        memory.writebyte(16735714, 0x00)
        memory.writebyte(16735716, 0x00)
        memory.writebyte(16735718, 0x00)
        memory.writebyte(16735720, 0x00)
        memory.writebyte(16735722, 0x00)
        memory.writebyte(16735724, 0x00)
        -- P2 life
        memory.writebyte(16735726, 0x00)
        memory.writebyte(16735728, 0x00)
        memory.writebyte(16735730, 0x00)
        memory.writebyte(16735732, 0x00)
        memory.writebyte(16735734, 0x00)
        memory.writeword(0xFF8030, 0x0000)
        memory.writeword(0xFFF200, 0x0000)
        memory.writeword(0xFFF000, 0x0000)

        -- for var=0xFF8B00,0xFF1FF, 2 do
        -- 	-- print("Removing", var)
        -- 	memory.writebyte(var, 0x00)
        -- end
    end
end
aestheticModule = {
    ["registerBefore"] = function()
        stage_select()
        ui_removal()
    end,
}

return aestheticModule