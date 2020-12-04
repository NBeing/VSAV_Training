local p1_base_addr            = 0xFF8400
local p1_base_addr            = 0xFF8800

local dummy_knocked_down_addr = 0xFF8805
local p2_facing_addr          = 0xFF880B
local p1_facing_addr          = 0xFF840B

local proximity_guard_addr = 0xFF8806
local proximity_guard_value = memory.readbyte(proximity_guard_addr)
local proximity_guard_status = proximity_guard_value == 10

local p1_block_stun_timer = 0xFF8558
local p1_proxy_block      = 0xFF8406 == 0x0C
local p1_block_state      = 0xFF8406 == 0x00
local p1_attack_flag      = 0xFF8505 ~= 0x00

local p2_block_stun_timer = 0xFF9558 
local p2_proxy_block      = 0xFF8806 == 0x0C
local p2_block_state      = 0xFF8806 == 0x00
local p2_attack_flag      = 0xFF8905 ~= 0x00

-- local player_state = {
--     attacking      = function(addr) return memory.readbyte(addr + 0x105) == 0x01 end,
--     supering       = function(addr) return memory.readbyte(addr + 0x006) == 0x12 end,
--     hurt           = function(addr) return memory.readbyte(addr + 0x005) == 0x02 end,
--     thrown         = function(addr) return memory.readbyte(addr + 0x005) == 0x06 end,
--     hitfreeze      = function(addr) return memory.readbyte(addr + 0x05C) ~= 0x00 end,
--     facing_right   = function(addr) return memory.readbyte(addr + 0x00B) == 0x00 end,
--     delay          = {startup = -1, atk_recover = 1, hit_recover = 1},
-- }


function get_gc_button()

    GC_type_config = globals.options.gc_button
    gc_button_type = 'none'

    if GC_type_config == 0x1 then
        gc_button_type = 'punch'
	elseif GC_type_config == 0x2 then
		gc_button_type = 'kick'
	elseif GC_type_config == 0x3 then
		gc_button_type = '3punch'
	elseif GC_type_config == 0x4 then
        gc_button_type = '3kick'
	end

	return gc_button_type
end

local function get_p2_facing()
	p2_facing_val  = memory.readbyte(p2_facing_addr)

	if p2_facing_val == 1 then
		return "right"
	end
	if p2_facing_val == 0 then
		return "left"
	end
end

local function get_p1_facing()
	p1_facing_val  = memory.readbyte(p1_facing_addr)

	if p1_facing_val == 1 then
		return "right"
	end
	if p1_facing_val == 0 then
		return "left"
	end
end

local function get_p1_towards()
	facing = get_p1_facing()
	p1_towards = nil

	if facing == "right" then
		p1_towards = "P1 Right"
	else
		p1_towards = "P1 Left"
	end
	return p1_towards
end

local function get_p1_away()
	facing = get_p1_facing()
	p1_away = nil
	if facing == "right" then
		p1_away = "P1 Left"
	else
		p1_away = "P1 Right"
	end
	return p1_away
end

local function get_p2_towards()
	facing = get_p2_facing()
	p2_towards = nil

	if facing == "right" then
		p2_towards = "P2 Right"
	else
		p2_towards = "P2 Left"
	end
	return p2_towards
end

local function get_p2_away()
	facing = get_p2_facing()
	p2_away = nil
	if facing == "right" then
		p2_away = "P2 Left"
	else
		p2_away = "P2 Right"
	end
	return p2_away
end

local function setShouldRoll()
    if globals.game.match_begun and memory.readbyte(dummy_knocked_down_addr) == 2 then
        return true
    else 
        return false
    end
end

local next_should_gc = false
local function shouldGC(GC_freq_value)

    local function maybe(x) 
        if 100 * math.random() < x then 
            return true
        else 
            return false
        end  
    end    

	local should_GC = false

	if GC_freq_value == 0x1 then
        should_GC = maybe(35)
    elseif GC_freq_value == 0x2 then
        should_GC = maybe(50)
	elseif GC_freq_value == 0x3 then
		should_GC = maybe(65)
	elseif GC_freq_value == 0x4 then
        should_GC = true
    elseif GC_freq_value == 0x0 then
		should_GC = false
    end

    return should_GC
end
local function setNextGCValue( update )
    if update then 
        GC_freq_value = update
    else
        GC_freq_value = globals.options.gc_freq
    end

    if shouldGC(GC_freq_value) then
        next_should_gc = true
    else
        next_should_gc = false
    end

	if GC_freq_value == 0x4 then
        next_should_gc = true
	end
	if GC_freq_value == 0x0 then
        next_should_gc = false
    end
end

local next_gc_delay = 0
local function setNextGCDelay(update)
    if update then 
        GC_delay_value = update
    else
        GC_delay_value = globals.options.gc_delay
    end

	if GC_delay_value == 0x9 then
		gc_random_seed = math.random(0, 8)
		next_gc_delay = gc_random_seed
    else
        next_gc_delay = GC_delay_value
	end

end

local gc_random_seed = nil
local function setNextGCSeed(val)
    gc_random_seed = val
end
local next_should_upback = false
local function shouldUpback(upback_freq_value)

    local function maybe(x) 
        if 100 * math.random() < x then 
            return true
        else 
            return false
        end  
    end    

	local should_upback = false

	if upback_freq_value == 0x1 then
        should_upback = maybe(35)
    elseif upback_freq_value == 0x2 then
        should_upback = maybe(50)
	elseif upback_freq_value == 0x3 then
		should_upback = maybe(65)
	elseif upback_freq_value == 0x4 then
        should_upback = true
    elseif upback_freq_value == 0x0 then
		should_upback = false
    end

    return should_upback
end
local function setNextUpbackValue( update )
    if update then 
        upback_freq_value = update
    else
        upback_freq_value = globals.options.upback_freq
    end

    if shouldUpback(upback_freq_value) then
        next_should_upback = true
    else
        next_should_upback = false
    end

	if upback_freq_value == 0x4 then
        next_should_upback = true
	end
	if upback_freq_value == 0x0 then
        next_should_upback = false
    end
end

local upback_random_seed = nil
local function setNextUpbackSeed(val)
    upback_random_seed = val
end

local function get_guard_action()
    if globals.options.guard_action == 0x1 then
        return 'gc' 
    elseif globals.options.guard_action == 0x2 then
        return 'pb'
    -- elseif globals.options.guard_action == 0x3 then
    --     return 'counter'
    elseif globals.options.guard_action == 0x3 then
        return 'reversal'
    else
        return 'none'
    end
end
local function get_pb_type()
    pb_type = globals.options.pb_type
    parsed = 'none'
    if pb_type == 0x0 then
        parsed = 'none'
    elseif pb_type == 0x1 then
        parsed = 'light'
    elseif pb_type == 0x2 then
        parsed = 'medium'
    elseif pb_type == 0x3 then
        parsed = 'heavy'
    elseif pb_type == 0x4 then
        parsed = 'ascending'
    elseif pb_type == 0x5 then
        parsed = 'descending'
    elseif pb_type == 0x6 then
        parsed = 'random'
    end

    return parsed
end
local function get_dummy_state()
    config = {
        p2_knocked_down = memory.readbyte(dummy_knocked_down_addr), -- our knocked down is actually guard stun
        p2_facing       = get_p2_facing(),
        p2_away_btn     = get_p2_away(),
        p2_toward_btn   = get_p2_towards(),

        p1_facing       = get_p1_facing(),
        p1_away_btn     = get_p1_away(),
        p1_toward_btn   = get_p1_towards(),
        enable_roll     = setShouldRoll(),

        p2_guarding    = memory.readbyte(0xFF8940) ~= 0,

        guard_action   = get_guard_action(),
        gc_button      = get_gc_button(),
    
        next_should_gc = next_should_gc,
        next_gc_delay  = next_gc_delay,
    
        setNextGCValue = setNextGCValue,
        setNextGCSeed  = setNextGCSeed,
        setNextGCDelay = setNextGCDelay,

        setNextUpbackValue = setNextUpbackValue,
        setNextUpbackSeed  = setNextUpbackSeed,

        pb_type        = get_pb_type(),

        refresh_dummy  = get_dummy_state,
        p1_block_stun_timer = memory.readbyte(0xFF8558),
        p1_proxy_block      = memory.readbyte(0xFF8406) == 0x0C,
        p1_block_state      = memory.readbyte(0xFF8406) == 0x00,
        p1_attack_flag      = memory.readbyte(0xFF8505) ~= 0x00,

        p2_block_stun_timer = memory.readbyte(0xFF9558),
        p2_proxy_block      = memory.readbyte(0xFF8806) == 0x0C,
        p2_block_state      = memory.readbyte(0xFF8806) == 0x00,
        p2_attack_flag      = memory.readbyte(0xFF8905) ~= 0x00,
    }
    return config
end
dummyStateModule = {
    ["registerBefore"] = function()
        return get_dummy_state()
    end
}
return dummyStateModule