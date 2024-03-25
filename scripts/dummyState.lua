-- remember 100 most recent states
local dummy_state_producer = Rx.ReplaySubject.create(100)

local dummy_knocked_down_addr = 0xFF8805
local p2_facing_addr          = 0xFF880B
local p1_facing_addr          = 0xFF840B
local p1_can_pursuit = false
local p2_can_pursuit = false
local p1_ground_special = false
local p2_ground_special = false

local function get_gc_button()

    GC_type_config = globals.options.gc_button
    local gc_button_type = 'none'

    if GC_type_config == 0x2 then
        gc_button_type = 'LP'
	elseif GC_type_config == 0x3 then
		gc_button_type = 'LK'
	elseif GC_type_config == 0x4 then
		gc_button_type = 'MP+HP'
	elseif GC_type_config == 0x5 then
        gc_button_type = 'MK+HK'
	end

	return gc_button_type
end

local function get_p2_facing()
	local p2_facing_val  = memory.readbyte(p2_facing_addr)

	if p2_facing_val == 1 then
		return "right"
	end
	if p2_facing_val == 0 then
		return "left"
	end
end

local function get_p1_facing()
	local p1_facing_val  = memory.readbyte(p1_facing_addr)

	if p1_facing_val == 1 then
		return "right"
	end
	if p1_facing_val == 0 then
		return "left"
	end
end

local function get_p1_towards()
	local facing = get_p1_facing()
	local p1_towards = nil

	if facing == "right" then
		p1_towards = "P1 Right"
	else
		p1_towards = "P1 Left"
	end
	return p1_towards
end

local function get_p1_away()
	local facing = get_p1_facing()
	local p1_away = nil
	if facing == "right" then
		p1_away = "P1 Left"
	else
		p1_away = "P1 Right"
	end
	return p1_away
end

local function get_p2_towards()
	local facing = get_p2_facing()
	local p2_towards = nil

	if facing == "right" then
		p2_towards = "P2 Right"
	else
		p2_towards = "P2 Left"
	end
	return p2_towards
end

local function get_p2_away()
	local facing = get_p2_facing()
	local p2_away = nil
	if facing == "right" then
		p2_away = "P2 Left"
	else
		p2_away = "P2 Right"
	end
	return p2_away
end

local function setShouldRoll()
    if globals.game_state.match_begun and memory.readbyte(dummy_knocked_down_addr) == 2 then
        return true
    else
        return false
    end
end

local function get_guard_action()
    if globals.options.guard_action == 0x2 then
        return 'gc'
    elseif globals.options.guard_action == 0x3 then
        return 'pb'
    elseif globals.options.guard_action == 0x4 then
        return 'Character Specific Reversal'
    elseif globals.options.guard_action == 0x5 then
        return 'recording on reversal'
    elseif globals.options.guard_action == 0x6 then
        return 'reversal'
    elseif globals.options.guard_action == 0x7 then
        return 'Character Specific Counter'
    elseif globals.options.guard_action == 0x8 then
        return 'counter'
    elseif globals.options.guard_action == 0x9 then
        return 'recording on counter'
    elseif globals.options.guard_action == 0xA then
        return 'recording on pushblock'
    elseif globals.options.guard_action == 0x1 then
        return 'none'
    end
end

local function get_pb_type()
    local pb_type = globals.options.pb_type
    local parsed = 'none'
    if pb_type == 0x1 then
        parsed = 'none'
    elseif pb_type == 0x2 then
        parsed = 'light'
    elseif pb_type == 0x3 then
        parsed = 'medium'
    elseif pb_type == 0x4 then
        parsed = 'heavy'
    elseif pb_type == 0x5 then
        parsed = 'ascending'
    elseif pb_type == 0x6 then
        parsed = 'descending'
    elseif pb_type == 0x7 then
        parsed = 'random'
    end

    return parsed
end

local function get_pb_type_rec()
    local pb_type = globals.options.pb_type_rec
    local parsed = 'none'
    if pb_type == 0x1 then
        parsed = 'none'
    elseif pb_type == 0x2 then
        parsed = 'light'
    elseif pb_type == 0x3 then
        parsed = 'medium'
    elseif pb_type == 0x4 then
        parsed = 'heavy'
    elseif pb_type == 0x5 then
        parsed = 'ascending'
    elseif pb_type == 0x6 then
        parsed = 'descending'
    elseif pb_type == 0x7 then
        parsed = 'random'
    end

    return parsed
end

local function get_counter_attack_button()
    local counter_attack_button = globals.options.counter_attack_button
    local parsed = 'none'
    if counter_attack_button == 0x1 then
        parsed = "none"
    elseif counter_attack_button == 0x2 then
        parsed = 'LP'
    elseif counter_attack_button == 0x3 then
        parsed = 'LK'
    elseif counter_attack_button == 0x4 then
        parsed = "MP"
    elseif counter_attack_button == 0x5 then
        parsed = 'MK'
    elseif counter_attack_button == 0x6 then
        parsed = 'HP'
    elseif counter_attack_button == 0x7 then
        parsed = 'HK'
    elseif counter_attack_button == 0x8 then
        parsed = 'MP+HP'
    elseif counter_attack_button == 0x9 then
        parsed = 'MK+HK'
    elseif counter_attack_button == 0xA then
        parsed = 'LP+LK'
    elseif counter_attack_button == 0xB then
        parsed = 'MP+MK'
    elseif counter_attack_button == 0xC then
        parsed = 'MP+MK'
    end

    return parsed
end

local function get_counter_attack_stick()
    local counter_attack_button = globals.options.counter_attack_stick
    local parsed = 'none'
    if counter_attack_button == 0x1 then
        parsed = "none"
    elseif counter_attack_button == 0x2 then
        parsed = 'up'
    elseif counter_attack_button == 0x3 then
        parsed = 'up-back'
    elseif counter_attack_button == 0x4 then
        parsed = "down-back"
    elseif counter_attack_button == 0x5 then
        parsed = 'up-forward'
    elseif counter_attack_button == 0x6 then
        parsed = 'down-forward'
    elseif counter_attack_button == 0x7 then
        parsed = 'QCF'
    elseif counter_attack_button == 0x8 then
        parsed = 'QCB'
    elseif counter_attack_button == 0x9 then
        parsed = 'HCF'
    elseif counter_attack_button == 0xA then
        parsed = 'HCB'
    elseif counter_attack_button == 0xB then
        parsed = 'DPF'
    elseif counter_attack_button == 0xC then
        parsed = 'DPB'
    elseif counter_attack_button == 0xD then
        parsed = '360'
    elseif counter_attack_button == 0xE then
        parsed = '720'
    elseif counter_attack_button == 0xF then
        parsed = 'back dash'
    elseif counter_attack_button == 0x10 then
        parsed = 'back dash cancel'
    elseif counter_attack_button == 0x11 then
        parsed = 'forward dash'
    elseif counter_attack_button == 0x12 then
        parsed = 'forward dash cancel'
    end

    return parsed
end

local function get_recording_slot()
    local pb_type = globals.options.recording_slot
    local slot = 'none'
    if pb_type == 0x1 then
        slot = 'last_recording.mis'
    elseif pb_type == 0x2 then
        slot = 'slot_1.mis'
    elseif pb_type == 0x3 then
        slot = 'slot_2.mis'
    elseif pb_type == 0x4 then
        slot = 'slot_3.mis'
    elseif pb_type == 0x5 then
        slot = 'slot_4.mis'
    elseif pb_type == 0x6 then
        slot = 'slot_5.mis'
    end

    return slot
end

local p1_base_addr = 0xFF8400
local p2_base_addr = 0xFF8800

local function parse_status_1(base_addr)
    local status = memory.readbyte(base_addr+0x05)
    if     status == 0x00  then return "Normal"
    elseif status == 0x02  then return 	"Hurt or Block"
    elseif status == 0x04  then return	"Throw"
    elseif status == 0x06  then return	"Be Thrown"
    elseif status == 0x08  then return	"Win Pose"
    elseif status == 0x0A  then return	"Time Up Lose"
    elseif status == 0x0C  then return	"Trigger Opponent Win-pose"
    elseif status == 0x0E  then return	"Intro"
    elseif status == 0x10  then return	"Cursed"
    elseif status == 0x12  then return	"Time Up Win" 
    end
end

local function parse_status_2(base_addr)
    local status = memory.readbyte(base_addr+0x06)
    if     status  == 0x00 then return "Normal"
    elseif status  == 0x02 then return "Stand/Crouch Transition"
    elseif status  == 0x04 then return "Walk"
    elseif status  == 0x06 then return "Jump"
    elseif status  == 0x08 then return "Intro Animation"
    elseif status  == 0x0A then return "Ground Normal Attack"
    elseif status  == 0x0C then return "Proximity Block"
    elseif status  == 0x0E then return "Special Attack"
    elseif status  == 0x10 then return "ES Attack"
    elseif status  == 0x12 then return "EX Attack"
    elseif status  == 0x14 then return "Dashing"
    elseif status  == 0x16 then return "DarkForce Activate"
    elseif status  == 0x18 then return "Dark Force w/ Flight Activate"
    elseif status  == 0x1A then return "Dark Force Deactivate"
    elseif status  == 0x1C then return "Dark Force w/ Sting Ray"
    elseif status  == 0x1E then return "Vic Dark Force Grab - Whiff"
    elseif status  == 0x20 then return "Vic Dark Force Grab - Animation 1"
    elseif status  == 0x22 then return "Vic Dark Force Grab - Animation 2"
    elseif status  == 0x24 then return "Vic Dark Force Grab - Animation 3"
    elseif status  == 0x26 then return "Vic Dark Force Grab - Animation 4"
    elseif status  == 0x28 then return "Grapple Mash Startup - No Throw-Tech"
    elseif status  == 0x2A then return "Grapple Mash"
    elseif status  == 0x2C then return "Grapple Mash Recovery" end 
end

local function get_character(base_addr)
    local char_id = memory.readbyte(base_addr + 0x382)
    if     char_id == 0x00  then return "Bulleta"
    elseif char_id == 0x01 	then return "Demitri"
    elseif char_id == 0x02 	then return "Gallon"
    elseif char_id == 0x03 	then return "Victor"
    elseif char_id == 0x04 	then return "Zabel"
    elseif char_id == 0x05 	then return "Morrigan"
    elseif char_id == 0x06 	then return "Anakaris"
    elseif char_id == 0x07 	then return "Felicia"
    elseif char_id == 0x08 	then return "Bishamon"
    elseif char_id == 0x09 	then return "Aulbath"
    elseif char_id == 0x0A 	then return "Sasquatch"
    elseif char_id == 0x0B 	then return "Random Select"
    elseif char_id == 0x0C 	then return "Q-Bee"
    elseif char_id == 0x0D 	then return "Lei-Lei"
    elseif char_id == 0x0E 	then return "Lilith"
    elseif char_id == 0x0F 	then return "Jedah"
    elseif char_id == 0x12 	then return "Dark Gallon"
    elseif char_id == 0x18 	then return "Oboro" end
end

local function get_pursuit_ok(player)
    local pursuit_ok = false
    if player == 1 then
        if p1_can_pursuit == true and p1_ground_special == true then
            pursuit_ok = true
        else 
            pursuit_ok = false
        end
    end
    if player == 2 then
        if p2_can_pursuit == true and p2_ground_special == true then
            pursuit_ok = true
        else 
            pursuit_ok = false
        end
    end
    return pursuit_ok
end
local function parsed_dummy_state()
    print("gettin 1", get_pursuit_ok(1))
    print("gettin 2", get_pursuit_ok(2))
    return {
        { name = "p1_status_1",         value = parse_status_1(p1_base_addr)},
        { name = "p1_status_2",         value = parse_status_2(p1_base_addr)},
        { name = "p1_facing",           value = get_p1_facing()},
        { name = "p1_guarding",         value = memory.readbyte(0xFF8540) ~= 0},
        { name = "p1_knocked_down",     value = memory.readbyte(dummy_knocked_down_addr - 0x400)}, -- our knocked down is actually guard stun
        { name = "p1_block_stun_timer", value = memory.readbyte(0xFF8558)},
        { name = "p1_proxy_block",      value = memory.readbyte(0xFF8406) == 0x0C},
        { name = "p1_block_state",      value = memory.readbyte(0xFF8406) == 0x00},
        { name = "p1_attack_flag",      value = memory.readbyte(0xFF8505) ~= 0x00},
        { name = "p1_reversal",         value = memory.readbyte(0xFF8400 + 0x174)},
        { name = "p1_can_pursuit",      value = p1_can_pursuit },
        { name = "p2_can_pursuit",      value = p2_can_pursuit },
        { name = "p1_ground_special",   value = p1_ground_special },
        { name = "p2_ground_special",   value = p2_ground_special },
        { name = "p1_pursuit_ok",       value = get_pursuit_ok(1)},
        { name = "p2_pursuit_ok",       value = get_pursuit_ok(2)},

        { name = "p2_input", value = {}},
        { name = "p2_status_1",         value = parse_status_1(p2_base_addr)},
        { name = "p2_status_2",         value = parse_status_2(p2_base_addr)},
        { name = "p2_facing",           value = get_p2_facing()},
        { name = "p2_guarding",         value = memory.readbyte(0xFF8940) ~= 0},
        { name = "p2_knocked_down",     value = memory.readbyte(dummy_knocked_down_addr)}, -- our knocked down is actually guard stun
        { name = "p2_block_stun_timer", value = memory.readbyte(0xFF9558)},
        { name = "p2_proxy_block",      value = memory.readbyte(0xFF8806) == 0x0C},
        { name = "p2_block_state",      value = memory.readbyte(0xFF8806) == 0x00},
        { name = "p2_attack_flag",      value = memory.readbyte(0xFF8905) ~= 0x00},        
        { name = "p2_reversal",         value = memory.readbyte(0xFF8400 + 0x174)},
    }
end

local function get_p1_char_specific_reversal()
    local current = globals.options.p1_reversal_list
    if globals.p1_current_move_list then
        local move_name = globals.p1_current_move_list[current] 
        local move_object
        for k, v in pairs( globals.char_moves.P1.reversals) do
            if v["name"] == move_name then
                move_object = v
            end
        end
        return move_object
    end
end

local function get_p2_char_specific_reversal()
    local current = globals.options.p2_reversal_list
    if globals.p2_current_move_list then
        local move_name = globals.p2_current_move_list[current] 
        local move_object
        for k, v in pairs( globals.char_moves.P2.reversals) do
            if v["name"] == move_name then
                move_object = v
            end
        end
        return move_object
    end
end

local function get_p1_reversal_strength()
    local current = globals.options.p1_reversal_strength
    if current == 1 then
        return 0x00
    elseif current == 2 then
        return 0x02
    elseif current == 3 then
        return 0x04
    elseif current == 4 then
        return 0x06
    end
end

local function get_p2_reversal_strength()
    local current = globals.options.p2_reversal_strength
    if current == 1 then
        return 0x00
    elseif current == 2 then
        return 0x02
    elseif current == 3 then
        return 0x04
    elseif current == 4 then
        return 0x06
    end
end

local function set_min_pb_inputs()
  local fn = nil
  local min_inputs = globals.options.min_pb_inputs + 2
  if min_inputs > 3 then
    fn = function()
      if memory.getregister("m68000.d0") < min_inputs then
        memory.setregister("m68000.d0", 0x00000000)
      end
    end
  end
  memory.registerexec(0x2760E, fn)
end

local function set_lei_lei_stun_item()
    local current = globals.options.lei_lei_stun_item
    if globals and globals.getCharacter(0xFF8400) ~= "Lei-Lei" then 
        return
    end
    if current == true then
        memory.writebyte(0xFF8400 + 0x19D, 0x08)
    end
end

local function get_anak_projectile()
    local current = globals.options.anak_projectile
    if globals and globals.getCharacter(0xFF8400) ~= "Anakaris" then 
        memory.writedword(0xFF84A6, 0xFFFFFFFF0000)
        return
    end
    if current == 1 then
        memory.writedword(0xFF84A6, 0xFFFFFFFF0000)
        return
    elseif current == 2 then
        -- "Bulleta St.Hk"
        memory.writebyte(0xff8782, 0x06)
        memory.writeword(0xFF8400 + 0xA6, 0x0000)
        memory.writeword(0xFF8400 + 0xA8, 0xFF0A)
        memory.writeword(0xFF8400 + 0xAA, 0x6000)
    elseif current == 3 then
        -- "Bulleta Missile"
        memory.writeword(0xFF8400 + 0xA6, 0x0200)
        memory.writeword(0xFF8400 + 0xA8, 0xFF0A)
        memory.writeword(0xFF8400 + 0xAA, 0x6000)
    elseif current == 4 then
        -- "Demitri Chaos Flare"
        memory.writeword(0xFF8400 + 0xA6, 0x0401)
        memory.writeword(0xFF8400 + 0xA8, 0xFF0A)
        memory.writeword(0xFF8400 + 0xAA, 0x6000)
    elseif current == 5 then
        -- "Morrigan Soul Fist"
        memory.writeword(0xFF8400 + 0xA6, 0x0B05)
        memory.writeword(0xFF8400 + 0xA8, 0xFF0A)
        memory.writeword(0xFF8400 + 0xAA, 0x0000)

    elseif current == 6 then
        -- "Morrigan Air Soul Fist"
        memory.writebyte(0xff8782, 0x06)
        memory.writeword(0xFF8400 + 0xA6, 0x0C05)
        memory.writeword(0xFF8400 + 0xA8, 0xFF0A)
        memory.writeword(0xFF8400 + 0xAA, 0x0000)
    elseif current == 7 then
        -- "Anakaris Curse"
        memory.writebyte(0xff8782, 0x06)
        memory.writeword(0xFF8400 + 0xA6, 0x1206)
        memory.writeword(0xFF8400 + 0xA8, 0xFF0A)
        memory.writeword(0xFF8400 + 0xAA, 0x4000)

    elseif current == 8 then
        -- "Aulbath Sonic Wave",
        memory.writebyte(0xff8782, 0x06)
        memory.writeword(0xFF8400 + 0xA6, 0x1E09)
        memory.writeword(0xFF8400 + 0xA8, 0xFF0A)
        memory.writeword(0xFF8400 + 0xAA, 0x6000)

    elseif current == 9 then
        -- "Lei-Lei Anki Oh"
        memory.writebyte(0xff8782, 0x06)
        memory.writeword(0xFF8400 + 0xA6, 0x2D0D)
        memory.writeword(0xFF8400 + 0xA8, 0xFF0A)
        memory.writeword(0xFF8400 + 0xAA, 0x0000)

    elseif current == 10 then
        -- "Lillith Soul Flash"
        memory.writebyte(0xff8782, 0x06)
        memory.writeword(0xFF8400 + 0xA6, 0x330E)
        memory.writeword(0xFF8400 + 0xA8, 0xFF0A)
        memory.writeword(0xFF8400 + 0xAA, 0x0000)

    elseif current == 11 then
        -- "Jedah Dio Sega"
        memory.writebyte(0xff8782, 0x06)
        memory.writeword(0xFF8400 + 0xA6, 0x380F)
        memory.writeword(0xFF8400 + 0xA8, 0xFF0A)
        memory.writeword(0xFF8400 + 0xAA, 0x4000)
    end
end

local function resolve_puppet_show_from_config(config_value)
	if     config_value == 1 then return 0x00
	elseif config_value == 2 then return 0x0A
	elseif config_value == 3 then return 0x13
	elseif config_value == 4 then return 0x1D
	elseif config_value == 5 then return 0x1E
	elseif config_value == 6 then return 0x1F
	else                          return 0x00
	end
end

local function set_lilith_gloomy_puppet_show()
	local is_lilith = globals.getCharacter(0xFF8400) == "Lilith"
	local selected_gps = globals.options.lilith_gps
	if not is_lilith or selected_gps == 0 then
		memory.registerexec(0x4F4F2, nil)
		return
	end
	memory.registerexec(0x4F4F2, function()
		memory.setregister("m68000.d1", resolve_puppet_show_from_config(selected_gps))
	end)
end

local function a6_contains_p1()
  return memory.getregister("m68000.a6") == p1_base_addr
end


local function set_pursuit_hooks()
  memory.registerexec(0x27ACC, function()
    if a6_contains_p1() and p1_can_pursuit then
      p1_can_pursuit = false
    elseif not a6_contains_p1() and p2_can_pursuit then
      p2_can_pursuit = false
    end
  end)
  memory.registerexec(0x27B14, function()
    if a6_contains_p1() then
      p1_can_pursuit = true
    else
      p2_can_pursuit = true
    end
    -- globals.p1_can_pursuit = p1_can_pursuit
    -- globals.p2_can_pursuit = p2_can_pursuit
  end)
end

local function set_ground_special()
    if memory.readbyte(0xFF8400 + 0x038) ~= 0x00 -- P1 Air State
    or memory.readbyte(0xFF8400 + 0x119) ~= 0x00 -- P1 Chain p1_attack_flag
    or memory.readbyte(0xFF8400 + 0x175) ~= 0x00 -- P1 Dash Attack
    or memory.readbyte(0xFF8400 + 0x171) ~= 0x00 -- P1 is Tech HIt
    or memory.readbyte(0xFF8400 + 0x18A) ~= 0x00 -- P1 OTG Restriction
    or memory.readbyte(0xFF8400 + 0x190) ~= 0x00 -- P1 Dark Force / On Crab
    or memory.readbyte(0xFF8000 + 0x10E) ~= 0x00 -- Total Disarmament
    or memory.readbyte(0xFF8000 + 0x10D) ~= 0x00 -- P1 Time Over Lose
    or memory.readbyte(0xFF8000 + 0x08A) ~= 0x00 -- P1 Time Over Win
    or memory.readbyte(0xFF8000 + 0x15D) ~= 0x00 -- P1 Intro Disarmament
    or memory.readword(0xFF8400 + 0x4) == 0x0202 -- P1 is hit
    or memory.readbyte(0xFF8400 + 0x6) == 0xE -- P1 is Special
    or memory.readbyte(0xFF8400 + 0x6) == 0x10 -- P1 is ES
    or memory.readbyte(0xFF8400 + 0x6) == 0x12 -- P1 is EX
    or memory.readbyte(0xFF8400 + 0x6) == 0x16 -- P1 Dark Force Startup
    or memory.readbyte(0xFF8400 + 0x6) == 0x1A -- P1 Dark Force Recovery
    or memory.readword(0xFF8400 + 0x6) == 0x0606 -- P1 Air attack
    or memory.readword(0xFF8404 + 0x5) == 0x4 -- P1 is throw
    or memory.readword(0xFF8404 + 0x5) == 0x6 -- P1 get throw
    or memory.readbyte(0xFF8400 + 0x6) == 0x0A and memory.readbyte(0xFF8400 + 0x167) == 0x00 -- P1 Normals & Special Cancels
    then p1_ground_special = false
    else p1_ground_special = true
    end   

    if memory.readbyte(0xFF8800 + 0x038) ~= 0x00 -- P2 Air State
    or memory.readbyte(0xFF8800 + 0x119) ~= 0x00 -- P2 Chain p1_attack_flag
    or memory.readbyte(0xFF8800 + 0x175) ~= 0x00 -- P2 Dash Attack
    or memory.readbyte(0xFF8800 + 0x171) ~= 0x00  -- P2 is Tech HIt
    or memory.readbyte(0xFF8800 + 0x18A) ~= 0x00 -- P2 OTG Restriction
    or memory.readbyte(0xFF8800 + 0x190) ~= 0x00 -- P2 Dark Force / On Crab
    or memory.readbyte(0xFF8000 + 0x10E) ~= 0x00 -- Total Disarmament
    or memory.readbyte(0xFF8000 + 0x10D) ~= 0x00 -- P2 Time Over Lose
    or memory.readbyte(0xFF8000 + 0x08A) ~= 0x00 -- P2 Time Over Win
    or memory.readbyte(0xFF8000 + 0x15D) ~= 0x00 -- P2 Intro Disarmament
    or memory.readword(0xFF8800 + 0x4) == 0x0202 -- P2 is hit
    or memory.readbyte(0xFF8800 + 0x6) == 0xE -- P2 is Special
    or memory.readbyte(0xFF8800 + 0x6) == 0x10 -- P2 is ES
    or memory.readbyte(0xFF8800 + 0x6) == 0x12 -- P2 is EX
    or memory.readbyte(0xFF8800 + 0x6) == 0x16 -- P2 Dark Force Startup
    or memory.readbyte(0xFF8800 + 0x6) == 0x1A -- P2 Dark Force Recovery
    or memory.readword(0xFF8800 + 0x6) == 0x0606 -- P2 Air attack
    or memory.readbyte(0xFF8800 + 0x6) == 0x0A and memory.readbyte(0xFF8800 + 0x167) == 0x00 -- P2 Normals & Special Cancels
    then p2_ground_special = false
    else p2_ground_special = true
    end
    -- globals.p1_ground_special = p1_ground_special
    -- globals.p2_ground_special = p2_ground_special
end

local function get_distance_between_players()
    local pushes = globals.pushboxes
    if not pushes then
        return
    end
    if not pushes.p1 or not pushes.p2 then
        return
    end
    local distance = 0
    local on_left = 'p1'
    if pushes.p1.right > pushes.p2.right then
        on_left = 'p2'
    end

    if on_left == 'p1' then
        -- gui.line(int x1, int y1, int x2, int y2 [, type color [, skipfirst]])
        distance = pushes.p2.left - pushes.p1.right        
    else
        distance = pushes.p1.left - pushes.p2.right
    end

    return distance
end

local config = {}
local function get_dummy_state()
    config = {
        distance_between_players = get_distance_between_players(),

        p1_char               = get_character(p1_base_addr),
        p1_status_1           = parse_status_1(p1_base_addr),
        p1_status_2           = parse_status_2(p1_base_addr),
        p1_block_stun_timer   = memory.readbyte(0xFF8558),
        p1_proxy_block        = memory.readbyte(0xFF8406) == 0x0C,
        p1_block_state        = memory.readbyte(0xFF8406) == 0x00,
        p1_es_attack_flag     = memory.readbyte(0xFF8406) == 0x12,
        p1_ex_attack_flag     = memory.readbyte(0xFF8406) == 0x10,
        p1_dashing            = memory.readbyte(0xFF8406) == 0x14,
        p1_attack_flag        = memory.readbyte(0xFF8505) ~= 0x00,
        p1_reversal           = memory.readbyte(0xFF8400 + 0x174),
        p1_facing             = get_p1_facing(),
        p1_away_btn           = get_p1_away(),
        p1_toward_btn         = get_p1_towards(),
        p1_is_dashing         = memory.readbyte(0xFF8400 + 0x115) ~= 0,
        p1_is_attacking       = memory.readbyte(0xFF8400 + 0x105) ~= 0,
        p1_in_air             = memory.readbyte(0xFF8400 + 0x38) ~= 0,
        p1_y                  = memory.readword(0xFF8400 + 0x14),
        p1_guarding           = memory.readbyte(0xFF8540) ~= 0,
        p1_is_blocking_or_hit = memory.readbyte(0xFF8405) == 2,
        p1_pushback_timer     = memory.readword(0xFF8400 + 0x164),
        p1_is_crouching       = memory.readbyte(0xFF8400 + 0x121) ~= 0,
        p1_tech_hit           = memory.readword(0xFF8800 + 0x1B0) ~= 0,
        p1_can_pursuit        = p1_can_pursuit,
        p1_pursuit_ok         = get_pursuit_ok(1),

        p1_chain              = memory.readbyte(0xFF8400 + 0x119) ~= 0x00,
        p1_dash_Attack        = memory.readbyte(0xFF8400 + 0x175) ~= 0x00,
        p1_is_tech_hit        = memory.readbyte(0xFF8400 + 0x171) ~= 0,
        p1_otg_restriction    = memory.readbyte(0xFF8400 + 0x18A) ~= 0,
        p1_DF_on_the_crab     = memory.readbyte(0xFF8400 + 0x190) ~= 0,
        p1_disarmament        = memory.readbyte(0xFF8000 + 0x10E) ~= 0,
        p1_time_over_lose     = memory.readbyte(0xFF8000 + 0x10D) ~= 0,
        p1_time_over_win      = memory.readbyte(0xFF8000 + 0x8A) ~= 0,
        p1_disarmament_intro  = memory.readbyte(0xFF8000 + 0x15D) ~= 0,
        p1_is_hit             = memory.readdword(0xFF8400 + 0x4) == 0x02020400,
        p1_not_actively_hurt  = memory.readword(0xFF8400 + 0x4) == 0x0200,
        p1_is_special         = memory.readbyte(0xFF8400 + 0x6) == 0x0E,
        p1_is_es              = memory.readbyte(0xFF8400 + 0x6) == 0x10,
        p1_is_ex              = memory.readbyte(0xFF8400 + 0x6) == 0x12,
        p1_is_df_startup      = memory.readbyte(0xFF8400 + 0x6) == 0x16,
        p1_is_df_recovery     = memory.readbyte(0xFF8400 + 0x6) == 0x1A,
        p1_jump_attack        = memory.readword(0xFF8400 + 0x6) == 0x0606,
        p1_cancel_timer       = memory.readbyte(0xFF8400 + 0x167) ~= 0,
        p1_ground_special     = p1_ground_special,

        p2_char               = get_character(p2_base_addr),
        p2_status_1           = parse_status_1(p2_base_addr),
        p2_status_2           = parse_status_2(p2_base_addr),
        p2_knocked_down       = memory.readbyte(dummy_knocked_down_addr), -- our knocked down is actually guard stun
        p2_facing             = get_p2_facing(),
        p2_away_btn           = get_p2_away(),
        p2_toward_btn         = get_p2_towards(),
        p2_is_dashing         = memory.readbyte(0xFF8800 + 0x115),
        p2_in_air             = memory.readbyte(0xFF8800 + 0x38),
        p2_guarding           = memory.readbyte(0xFF8940) ~= 0,
        p2_is_blocking_or_hit = memory.readbyte(0xFF8805) == 2,
        p2_is_attacking       = memory.readbyte(0xFF8800 + 0x105) ~= 0,
        p2_y                  = memory.readword(0xFF8800 + 0x14),
        p2_pushback_timer     = memory.readword(0xFF8800 + 0x164),
        p2_block_stun_timer   = memory.readbyte(0xFF9558),
        p2_proxy_block        = memory.readbyte(0xFF8806) == 0x0C,
        p2_block_state        = memory.readbyte(0xFF8806) == 0x00,
        p2_attack_flag        = memory.readbyte(0xFF8905) ~= 0x00,
        p2_reversal           = memory.readbyte(0xFF8800 + 0x174),
        p2_reversal_frame     = memory.readdword(0xFF8804) == 0x02020400,
        p2_is_crouching       = memory.readbyte(0xFF8800 + 0x121),
        p2_can_pursuit        = p2_can_pursuit,
        p2_chain              = memory.readbyte(0xFF8800 + 0x119) ~= 0,
        p2_dash_Attack        = memory.readbyte(0xFF8800 + 0x175) ~= 0,
        p2_is_tech_hit        = memory.readbyte(0xFF8800 + 0x171) ~= 0,
        p2_otg_restriction    = memory.readbyte(0xFF8800 + 0x18A) ~= 0,
        p2_DF_on_the_crab     = memory.readbyte(0xFF8800 + 0x190) ~= 0,
        p2_disarmament        = memory.readbyte(0xFF8000 + 0x10E) ~= 0,
        p2_time_over_lose     = memory.readbyte(0xFF8000 + 0x10D) ~= 0,
        p2_time_over_win      = memory.readbyte(0xFF8000 + 0x8A) ~= 0,
        p2_disarmament_intro  = memory.readbyte(0xFF8000 + 0x15D) ~= 0,
        p2_is_hit             = memory.readdword(0xFF8800 + 0x4) == 0x02020400,
        p2_not_actively_hurt  = memory.readword(0xFF8800 + 0x4) == 0x0200,
        p2_is_special         = memory.readbyte(0xFF8800 + 0x4) == 0x0E,
        p2_is_es              = memory.readbyte(0xFF8800 + 0x4) == 10,
        p2_is_ex              = memory.readbyte(0xFF8800 + 0x4) == 12,
        p2_is_df_startup      = memory.readbyte(0xFF8800 + 0x4) == 16,
        p2_is_df_recovery     = memory.readbyte(0xFF8800 + 0x4) == 0x1A,
        p2_jump_attack        = memory.readword(0xFF8800 + 0x6) == 0x0606,
        p2_cancel_timer       = memory.readbyte(0xFF8800 + 0x167) ~= 0,
        p2_ground_special     = p2_ground_special,
        p2_pursuit_ok         = get_pursuit_ok(2),

        enable_roll  = setShouldRoll(),
        guard_action = get_guard_action(),
        gc_button    = get_gc_button(),

        counter_attack_button = get_counter_attack_button(),
        counter_attack_stick  = get_counter_attack_stick(),

        recording_slot = get_recording_slot(), 

        pb_type        = get_pb_type(),
        pb_type_rec    = get_pb_type_rec(),
        p1_char_specific_reversal = get_p1_char_specific_reversal(),
        p1_reversal_strength      = get_p1_reversal_strength(),
        p2_char_specific_reversal = get_p2_char_specific_reversal(),
        p2_reversal_strength      = get_p2_reversal_strength(),

        refresh_dummy = get_dummy_state,

    }
    return config
end

local dummyStateModule = {
    ["registerBefore"] = function()
        globals.parsed_dummy_state = parsed_dummy_state()
        get_anak_projectile()
        set_lei_lei_stun_item()
        set_lilith_gloomy_puppet_show()
        set_min_pb_inputs()
        set_pursuit_hooks()
        set_ground_special()
        return {
            get_dummy_state = get_dummy_state,
        }
    end,
    ["dummy_state_service_updater"] = function(cycle, frame, tick)
        local state = get_dummy_state()
        state["cycle"] = cycle
        state["frame"] = frame
        state["tick"] = tick
        dummy_state_producer(state)
    end,
    ["dummy_state_service"] = function()
      return dummy_state_producer
    end,
}

return dummyStateModule
