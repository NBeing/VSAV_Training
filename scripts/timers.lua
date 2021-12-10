local rb, rbs, rw, rws, rd, rds = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned, memory.readdword, memory.readdwordsigned
local wb, ww, wd = memory.writebyte, memory.writeword, memory.writedword

local timers = {
    p1_pushblock_counter = 0
}
local function hex(val)
    val = string.format("%X",val)
    return val
end
function drawaxis(x,y,axis)

    gui.line(x+axis,y,x-axis,y,'yellow')
    gui.line(x,y-axis,x,y+axis,'red')
    
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
    -- gui.box(left,top,right,bottom,color)
    return {
        left = left,
        top = top,
        right = right,
        bottom = bottom
    }
    
end
-- Box data from Jed's VSAV script
function getHeadBoxTopXY(adr)
    
    local CamADR = 0xFF8280
    local camx = rw(CamADR + 0x20)
    local camy = rw(CamADR + 0x24)
    local px = rw(adr + 0x010) - camx 
    local py = 244 - rw(adr + 0x014) + camy
    local anipnt = rd(adr + 0x1C)
    local boxset = rd(adr + 0x64) + rb(anipnt + 0x09)*4
    local special = rd((rb(adr + 0x382)*4 + 0xbd57a))  
    local charid = rb(adr + 0x382)
    local p2x = rw(0xFF8800 + 0x010) - camx 
    local p2y = 244 - rw(0xFF8800 + 0x014) + camy
    
    local p1x = rw(0xFF8400 + 0x010) - camx 
    local p1y = 244 - rw(0xFF8400 + 0x014) + camy

 
    if rb(adr + 0x0B) == 0 then
        pflip = 1
        else
        pflip = -1
        end 
    ------------------------
    ----------Head----------
    ------------------------
    local headpnt = rd(adr + 0x80)
    local head = headpnt + (rb(boxset + 0x00) * 0x08)
    -- gui.box(224,34,383,54,{0x00,0xFF,0xFF,0x40})

    -- gui.text(228,36,"Head Pointer: " .. hex(head))
    -- gui.text(228,44,"XP: " .. hex(rw(head + 0x00)))
    -- gui.text(268,44,"YP: " .. hex(rw(head + 0x02)))
    -- gui.text(308,44,"XR: " .. hex(rw(head + 0x04)))
    -- gui.text(348,44,"YR: " .. hex(rw(head + 0x06)))
    local head_box_coords = collisionbox(head,px,py,{0x00,0xFF,0xFF,0x00},pflip) 
    -- drawaxis(px,py,8)
    -- gui.box()
    return {
        head = head_box_coords,
        base = { x = px, y = py }
    }

end
local function draw_invuln_timer( player_adr , coords)
    local invuln_timer = memory.readbyte(player_adr + 0x147)
    if invuln_timer ~= 0 then
        gui.rect(coords.base.x - 20, coords.base.y - 100, coords.base.x - 20 + (invuln_timer * 2), coords.base.y - 110, 0x00FF0099,0x00000099)
        gui.text(coords.base.x - 17, coords.base.y - 108, invuln_timer)
        gui.text((coords.base.x - 35), coords.base.y - 108, "Inv." )
    end
end
local function draw_throw_invuln(player_adr, coords)
    local invuln_timer = memory.readbyte(player_adr + 0x143) 	-- Throw Invulnerability Timer 
    if invuln_timer ~= 0 then
        gui.rect(coords.base.x - 20, coords.base.y - 112, coords.base.x - 20 + (invuln_timer * 7), coords.base.y - 122, 0xFFFF0099,0x00000099)
        gui.text(coords.base.x - 17, coords.base.y - 120, invuln_timer)
        gui.text((coords.base.x - 57), coords.base.y - 120, "Throw Inv" )
    end
end
local function draw_pursuit_timer(player_adr, coords)
    local pursuit_timer = memory.readbyte(player_adr + 0x18A) 	-- Pursuit & OTG Restriction Timer  
    print("pursuit", pursuit_timer)
    if pursuit_timer ~= 0 then
        gui.rect(coords.base.x - 20, coords.base.y - 112, coords.base.x - 20 + (pursuit_timer * 7), coords.base.y - 122, 0xFF00FF99,0x00000099)
        gui.text(coords.base.x - 17, coords.base.y - 120, pursuit_timer)
        gui.text((coords.base.x - 55), coords.base.y - 120, "Pursuit" )
    end
end
local function draw_curse_timer(player_adr, coords)
    local curse_timer = memory.readword(player_adr + 0x156) 	-- Curse Timer  
    if curse_timer ~= 0 then
        gui.rect(coords.base.x - 20, coords.base.y - 32, coords.base.x - 20 + (curse_timer * 1), coords.base.y - 42, 0xFF00FF99,0x00000099)
        gui.text(coords.base.x - 17, coords.base.y - 40, curse_timer)
        gui.text((coords.base.x - 55), coords.base.y - 40, "Curse" )
    end
end
local function draw_mash_timer(player_adr, coords)
    local mash_timer = memory.readword(player_adr + 0x15C) 	-- Mash Timer 
    if mash_timer ~= 0 then
        gui.rect(coords.base.x - 20, coords.base.y - 112, coords.base.x - 20 + (mash_timer * 2), coords.base.y - 122, 0x00FFFF99,0x00000099)
        gui.text(coords.base.x - 17, coords.base.y - 120, mash_timer)
        gui.text((coords.base.x - 55), coords.base.y - 120, "Mash" )
    end
end
local function draw_push_block_timer(player_adr, coords)
    local push_block_timer = memory.readbyte(player_adr + 0x1AB) 	-- Pushblock timer
    if push_block_timer ~= 0 then
        gui.rect(coords.base.x - 20, coords.base.y - 112, coords.base.x - 20 + (push_block_timer * 3), coords.base.y - 122, 0xFF00FF99,0x00000099)
        gui.text(coords.base.x - 17, coords.base.y - 120, push_block_timer)
        gui.text((coords.base.x - 35), coords.base.y - 120, "PB" )
    end
end
local function draw_push_block_push_back_timer(player_adr, coords)
    local push_block_push_back_timer = memory.readword(player_adr + 0x1B0) 	-- Pushblock pushback timer
    if push_block_push_back_timer ~= 0 then
        gui.rect(coords.base.x - 20, coords.base.y - 112, coords.base.x - 20 + (push_block_push_back_timer * 3), coords.base.y - 122, 0xDDA0DD99,0x00000099)
        gui.text(coords.base.x - 17, coords.base.y - 120, push_block_push_back_timer)
        gui.text((coords.base.x - 65), coords.base.y - 120, "PB PushBack" )
    end
end
local record_tech_hit_results = false
timerModule = {
    ["guiRegister"] = function()
        -- print("action timer", memory.readword(0xFF8400 + 0x26) )
        -- print("push back", memory.readbyte(0xFF8800 + 0x1B0))
        local p1_coords = getHeadBoxTopXY(0xFF8400)
        local p2_coords = getHeadBoxTopXY(0xFF8800)
        if globals.options.show_pb_pushback_timer then
            draw_push_block_push_back_timer( 0xFF8400, p1_coords)
            draw_push_block_push_back_timer( 0xFF8800, p2_coords)
        end
        if globals.options.show_pb_timer then
            draw_push_block_timer( 0xFF8400, p1_coords)
            draw_push_block_timer( 0xFF8800, p2_coords)
        end
        if globals.options.show_curse_timer then
            draw_curse_timer( 0xFF8400, p1_coords)
            draw_curse_timer( 0xFF8800, p2_coords)
        end
        if globals.options.show_throw_invuln_timer then
            draw_throw_invuln( 0xFF8400, p1_coords)
            draw_throw_invuln( 0xFF8800, p2_coords)
        end
        if globals.options.show_mash_timer then
            draw_mash_timer( 0xFF8400, p1_coords)
            draw_mash_timer( 0xFF8800, p2_coords)
        end
        if globals.options.show_invuln_timer then
            draw_invuln_timer( 0xFF8400, p1_coords)
            draw_invuln_timer( 0xFF8800, p2_coords)
        end
            -- draw_pursuit_timer( 0xFF8400, p1_coords)
            -- draw_pursuit_timer( 0xFF8800, p2_coords)
    end,
    ["registerBefore"] = function()
        local p1_pushblock_counter = memory.readbyte(0xFF8400 + 0x170)
        local p1_tech_hit_timer = memory.readbyte(0xFF8400 + 0x1AB) 
        if p1_tech_hit_timer > 0 then
            record_tech_hit_results = true
            timers.p1_pushblock_counter = p1_pushblock_counter
        elseif p1_tech_hit_timer == 0 and record_tech_hit_results == true then
            record_tech_hit_results = false
            timers.p1_pushblock_counter = p1_pushblock_counter
        end
        return timers
    end
}

return timerModule