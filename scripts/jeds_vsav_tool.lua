local rb, rbs, rw, rws, rd, rds = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned, memory.readdword, memory.readdwordsigned
local wb, ww, wd = memory.writebyte, memory.writeword, memory.writedword

print("Hotkey 1: Freeze animation")
print("Hotkey 2: Reset Y")

freezeframe = 0

function main()
objram = 0x708000


CamADR = 0xFF8280
camx = rw(CamADR + 0x20)
camy = rw(CamADR + 0x24)
local p2x = rw(0xFF8800 + 0x010) - camx 
local p2y = 244 - rw(0xFF8800 + 0x014) + camy

local p1x = rw(0xFF8400 + 0x010) - camx 
local p1y = 244 - rw(0xFF8400 + 0x014) + camy

	camboxx1=120 --0x78
	camboxx2=264 --0x108
	camboxy = camy + 0x70 + 0x38 
	ground = 244 - 0x28 + camy
	gui.box(camboxx1,camboxy,camboxx2,ground,0x00008880)

wd(0xFF88A4,0x01010101)	
	playerdata(0xFF8400,0,0)
	drawaxis(p2x,p2y,8)
	drawaxis(p1x,p1y,8)
	--Timer
	wb(0xFF8109,0x63)
	if freezeframe == 1 then
	wb(0xFF8420, 0x80)
		
	if rb(0xFF8438) == 1 then
		ww(0xFF8414, 0x40)
		wd(0xFF8444, 0)
		wd(0xFF844C, 0)
	end
	end
end

function playerdata(adr,x,y)
local px = rw(adr + 0x010) - camx 
local py = 244 - rw(adr + 0x014) + camy
local plcamy = camboxy 
local anipnt = rd(adr + 0x1C)
local boxset = rd(adr + 0x64) + rb(anipnt + 0x09)*4
local special = rd((rb(adr + 0x382)*4 + 0xbd57a))  
local charid = rb(adr + 0x382)
 
if rb(adr + 0x0B) == 0 then
pflip = 1
else
pflip = -1
end 

walkspeedadr = (charid*8 + 0xBd87A)
walkspeedfwd = rds(walkspeedadr)/0x10000
walkspeedbck = rds(walkspeedadr+8)/0x10000

--Dunno where to place
gui.text(42,8,"Anim Pointer: " .. hex(anipnt))
gui.text(8,32,"Special: " .. hex(special))
gui.text(42,0,"Animation: " .. rb(adr + 0x20) .. "/" .. rb(anipnt))
gui.text(8,168,"Walkspeed Forwards: " .. walkspeedfwd)
gui.text(8,176,"Walkspeed Backwards: " .. walkspeedbck)

--gui.text(42,80,"X,Y: " .. rw(adr + 0x10) .. "/" .. rw(adr + 0x14))
gui.text(42,0,"Animation: " .. rb(adr + 0x20) .. "/" .. rb(anipnt))

gui.text(142,8,"Box Setup PT: " .. hex(boxset))

--
------------------------
----------Push----------
------------------------
local pushpnt = rd(adr + 0x90)
local push = pushpnt + (rb(boxset + 0x03) * 0x08)
collisionbox(push,px,py,0x00FF0000,pflip)
gui.text(8,212,"Push Pointer: " .. hex(push))


------------------------
----------Head----------
------------------------
local headpnt = rd(adr + 0x80)
local head = headpnt + (rb(boxset + 0x00) * 0x08)
gui.box(224,34,383,54,{0x00,0xFF,0xFF,0x40})

gui.text(228,36,"Head Pointer: " .. hex(head))
gui.text(228,44,"XP: " .. hex(rw(head + 0x00)))
gui.text(268,44,"YP: " .. hex(rw(head + 0x02)))
gui.text(308,44,"XR: " .. hex(rw(head + 0x04)))
gui.text(348,44,"YR: " .. hex(rw(head + 0x06)))


------------------------
----------Body----------
------------------------
local bodypnt = rd(adr + 0x84)
local body = bodypnt + (rb(boxset + 0x01) * 0x08)
gui.box(224,55,383,75,{0xFF,0x88,0xFF,0x40})

gui.text(228,57,"Body Pointer: " .. hex(body))
gui.text(228,65,"XP: " .. hex(rw(body + 0x00)))
gui.text(268,65,"YP: " .. hex(rw(body + 0x02)))
gui.text(308,65,"XR: " .. hex(rw(body + 0x04)))
gui.text(348,65,"YR: " .. hex(rw(body + 0x06)))


------------------------
----------Legs----------
------------------------
local legspnt = rd(adr + 0x88)
local legs = legspnt + (rb(boxset + 0x02) * 0x08)
gui.box(224,76,383,96,{0xFF,0x88,0x00,0x40})

gui.text(228,78,"Legs Pointer: " .. hex(legs))
gui.text(228,86,"XP: " .. hex(rw(legs + 0x00)))
gui.text(268,86,"YP: " .. hex(rw(legs + 0x02)))
gui.text(308,86,"XR: " .. hex(rw(legs + 0x04)))
gui.text(348,86,"YR: " .. hex(rw(legs + 0x06)))

------------------------
---------Attack---------
------------------------
local atkpointer = rd(adr + 0x8C)
local attk = atkpointer + (rb(anipnt + 0x0A) * 0x20)
gui.box(8,34,168,76,{0xFF,0x00,0x00,0x40})

gui.text(012,36,"Attk Pointer: " .. hex(attk))
gui.text(012,44,"XP: " .. hex(rw(attk + 0x00)))
gui.text(052,44,"YP: " .. hex(rw(attk + 0x02)))
gui.text(092,44,"XR: " .. hex(rw(attk + 0x04)))
gui.text(132,44,"YR: " .. hex(rw(attk + 0x06)))

--Boxes
collisionbox(head,px,py,{0x00,0xFF,0xFF,0x00},pflip)
collisionbox(body,px,py,{0xFF,0x88,0xFF,0x00},pflip)
collisionbox(legs,px,py,{0xFF,0x88,0x00,0x00},pflip)
collisionbox(attk,px,py,{0xFF,0x00,0x00,0x00},pflip)
--]]
drawaxis(px,py,8)

end

function drawaxis(x,y,axis)

gui.line(x+axis,y,x-axis,y,'yellow')
gui.line(x,y-axis,x,y+axis,'red')

end

function hex(val)
        val = string.format("%X",val)
		return val
end

function getcolor(adr,transparency)
	--This is Example is for cps2 and cps1.
	--Transparency is still possible with this.
	--Example for a box gui.box(32,32,40,40,getcolor(0x900000))
	local red = bit.band(memory.readbyte(adr), 0xF)
	local green = (bit.band(memory.readbyte(adr+1), 0xF0))/16
	local blue = bit.band(memory.readbyte(adr+1), 0xF)
	
	local color = {(red * 17) , (green * 17) , (blue * 17),transparency}
	return color
end

function drawaxis(x,y,axis)

gui.line(x+axis,y,x-axis,y,"white")
gui.line(x,y+axis,x,y-axis,"white")

end

--Collision Box function
function collisionbox(adr,playerx,playery,color,flip)

local hval = rws(adr + 0x0)
local vval = rws(adr + 0x2)
local hrad =  rw(adr + 0x4)
local vrad =  rw(adr + 0x6)

	local hval	 = playerx + hval * flip
	local vval	 = playery - vval
	local left	 = hval - hrad
	local right	 = hval + hrad
	local top	 = vval - vrad
	local bottom = vval + vrad
	
	--gui.line(playerx,playery,left,bottom) To help ID where the box is if your maths is wrong
	gui.box(left,top,right,bottom,color)

end

input.registerhotkey(1, function() 
if freezeframe == 0 then
freezeframe = freezeframe + 1
else
freezeframe = 0
end

end)

input.registerhotkey(2, function() 
ww(0xFF8414,0x28)
ww(0xFF8444,-1)
end)

emu.registerafter(function()
main()
end)
