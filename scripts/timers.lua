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

local function draw_projectile_count_limiter( _ , coords)
    local projectile_count_limiter = memory.readbyte(0xFFF9BE)
    gui.text(135,50, "Projectile Allocation Value: ".."0x"..to_hex(projectile_count_limiter))
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

local function draw_pursuit_timer(player, coord)
  local player_can_pursuit = false
  if player == 1 then
    player_can_pursuit = globals.dummy.p1_can_pursuit
  else
    player_can_pursuit = globals.dummy.p2_can_pursuit
  end

  if player_can_pursuit == true then
    gui.text(23, 119, "Opponent OK", "green")
  else
    gui.text(23, 119, "Opponent OK", "grey")
  end
end

local function draw_ground_special(player, coord)
  local player_ground_special = false
  if player == 1 then
     player_ground_special = globals.dummy.p1_ground_special
  else
     player_ground_special = globals.dummy.p2_ground_special
  end

  if player_ground_special == true then
    gui.text(23, 111, "Player OK", "green")
  else
    gui.text(23, 111, "Player OK", "grey")
  end
end

local function draw_pursuit_OK(player, coord)

  if player_can_pursuit == false and player_ground_special == true
  then pursuitokscenario2 = emu.framecount()
    else pursuitokscenario2 = 0
  end
  
  if player_can_pursuit == true and player_ground_special == true
  then pursuitokscenario1 = emu.framecount() - pursuitokscenario2 
  else pursuitokscenario1 = 0
  end

  if player == 1
  then
    player_ground_special = globals.dummy.p1_ground_special
    player_can_pursuit = globals.dummy.p1_can_pursuit
    p1_pursuitwindow = (pursuitokscenario1 - pursuitokscenario2)
  else
    player_ground_special = globals.dummy.p2_ground_special
    player_can_pursuit = globals.dummy.p2_can_pursuit
  end

  if player_ground_special == true and player_can_pursuit == true
  then
    gui.text(23, 127, "Pursuit OK", "green")
  else
    gui.text(23, 127, "Pursuit OK", "grey")
  end

    -- if player_ground_special == true and player_can_pursuit == false
    -- then
      gui.text(68, 127, "Frames: ".. p1_pursuitwindow, "green")
    -- else
    --   gui.text(68, 127, "Frames: TBD", "grey")
    -- end
end

local function draw_curse_timer(player_adr, coords)
    local curse_timer = memory.readword(player_adr + 0x156) 	-- Curse Timer  
    if curse_timer ~= 0 then
        gui.rect(coords.base.x - 20, coords.base.y - 32, coords.base.x - 20 + (curse_timer * 1), coords.base.y - 42, 0xFF00FF99,0x00000099)
        gui.text(coords.base.x - 17, coords.base.y - 40, curse_timer)
        gui.text((coords.base.x - 55), coords.base.y - 40, "Curse" )
    end
end

local function a6_contains_p1() 
return memory.getregister("m68000.a6") == 0xFF8400
end


 function set_mash_hooks()
  p2_can_mash = true
  -- memory.registerexec(0x26100, function()
  -- if a6_contains_p1 then p2_can_mash = false
  -- end
  -- end)
end

 function draw_mash_timer(player_adr, coords)
 mash_timer = memory.readword(player_adr + 0x15C) 	-- Mash Timer 

    if mash_timer ~= 0 
    and p2_can_mash == true 
    then
    gui.rect(coords.base.x - 20, coords.base.y - 112, coords.base.x - 20 + (mash_timer *2), coords.base.y - 122, 0x00FFFF99,0x00000099)
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

local function get_move_strength(move_strength)
    if move_strength == 0 then 
        move_strength_display = "None / Light"
    elseif move_strength == 1 then 
        move_strength_display = "Medium"
    elseif move_strength == 2 then 
        move_strength_display = "Heavy"
    elseif move_strength == 3 then 
        move_strength_display = "ES"
    else
        move_strength_display = ""
    end
    return move_strength.." ( "..move_strength_display.." )"
end

local function draw_move_strength_display(player_adr)
    local move_strength_p1 = memory.readbyte(0xFF8859)
    local move_strength_display_p1 = get_move_strength(move_strength_p1)

    local move_strength_p2 = memory.readbyte(0xFF8459)
    local move_strength_display_p2 = get_move_strength(move_strength_p2)

    local push_block_push_back_timer_p1 = memory.readword(0xFF8400 + 0x1B0) 
    local push_block_push_back_timer_p2 = memory.readword(0xFF8800 + 0x1B0) 

    gui.text(50,50,"P1 Last Got Hit By       : "..move_strength_display_p2)
    gui.text(50,58,"P2 Last Got Hit By       : "..move_strength_display_p1)
    gui.text(50,66,"P1 Push Back Timer Value : "..push_block_push_back_timer_p1)
    gui.text(50,74,"P2 Push Back Timer Value : "..push_block_push_back_timer_p2)
end

local record_tech_hit_results = false

local timerModule = {
  ["guiRegister"] = function()
    -- print("action timer", memory.readword(0xFF8400 + 0x26) )
    -- print("push back", memory.readbyte(0xFF8800 + 0x1B0))
    local p1_coords = getHeadBoxTopXY(0xFF8400)
    local p2_coords = getHeadBoxTopXY(0xFF8800)
    if globals.options.show_pb_pushback_timer then
      draw_push_block_push_back_timer( 0xFF8400, p1_coords)
      draw_push_block_push_back_timer( 0xFF8800, p2_coords)
    end
    if globals.options.show_move_strength then
      draw_move_strength_display()
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
    if globals.options.show_projectile_count_limiter then
      draw_projectile_count_limiter()
    end
    if globals.options.show_pursuit_indicator then
      draw_pursuit_timer(1, 23, 119)
    end
    if globals.options.show_ground_special then
      draw_ground_special(1,23,111)
    end
    if globals.options.show_ground_special and globals.options.show_pursuit_indicator then
      draw_pursuit_OK(1, 23, 127)
    end
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