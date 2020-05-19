-- The values to write
local roll_address       = 0xFF880A
local roll_toward_value  = 0x01
local roll_away_value    = 0xFF

-- These are the values for the roll options in the cheat
local roll_toward_option         = 0x1
local roll_away_option           = 0x2
local roll_random_option         = 0x3
local roll_random_toward_or_away = 0x4
local roll_none                  = 0x0

local function getRandomIntBetween( lower, upper )
    return math.random(lower, upper)
end

local function getDirection()
    -- This is direction set by the user in cheats
    local direction = globals.options.get_roll

    -- Handle random rolls
    if direction == roll_random_option then
        flag = getRandomIntBetween(0,2)
        if flag == 1 then
            return roll_toward_value
        elseif flag == 2 then
            return roll_away_value
        else
            return roll_none
        end
    end
    if direction == roll_random_toward_or_away then
        flag = getRandomIntBetween(1,2)
        if flag == 1 then
            return roll_toward_value
        else
            return roll_away_value
        end
    end
    if direction == roll_toward_option then
        return roll_toward_value
    end
    
    if direction == roll_away_option then
        return roll_away_value
    end

    return roll_none

end

local function rollToDirection( direction )
    if globals.dummy.enable_roll == true then
        memory.writebyte(roll_address, direction)
    end
end

rollingModule = {
    ["roll"] = function()
        -- Sets ram address to roll in the direction specified in cheat
        rollToDirection(getDirection())
    end
}
return rollingModule