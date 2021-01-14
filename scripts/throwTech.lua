throwTechModule = {
    ["registerBefore"] = function(cur_keys)

        if globals.dummy.p2_status_1 == "Be Thrown" and globals.options.p2_throw_tech then
            local towards_btn    = globals.dummy.p2_away_btn
            cur_keys[towards_btn] = true
            cur_keys["P2 Medium Punch"] = true
        end    
    end
}

return throwTechModule