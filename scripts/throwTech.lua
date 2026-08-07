local throwtech_no      = 0x1
local throwtech_yes     = 0x2
local throwtech_random  = 0x3

local function getRandomIntBetween( lower, upper )
    return math.random(lower, upper)
end

throwTechModule = {
    ["registerBefore"] = function(cur_keys)
        local throwtech = globals.options.p2_throw_tech
        if globals.dummy.p2_status_1 == "Be Thrown" and throwtech == throwtech_random then
            flag = getRandomIntBetween(1,15) -- The game is sending this every frame so I think this is a fine enough compromise that a 1/15 chance across however many frames it has to input, it will input a throw tech
            if flag == 1 then
                local towards_btn    = globals.dummy.p2_away_btn
                cur_keys[towards_btn] = true
                cur_keys["P2 Medium Punch"] = true
            end
        end
        if globals.dummy.p2_status_1 == "Be Thrown" and throwtech == throwtech_yes then
            local towards_btn    = globals.dummy.p2_away_btn
            cur_keys[towards_btn] = true
            cur_keys["P2 Medium Punch"] = true
        end    
    end
}

return throwTechModule