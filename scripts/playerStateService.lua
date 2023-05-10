-- module provides bussy logic
-- listen to queues from rawStateService
-- populate tables, do processing, whatever
-- prepare stuff for gui components
local BUFFER_LEN = 5

-- check if a dash attack started on this tick
local function dashAttackStarted()
    local dash_state = globals.truth.p1_state.dash:getValue()
    local attack_state = globals.truth.p1_state.attack:getValue()
    if (dash_state.current and attack_state.current and
            attack_state.previous == false) then
            return true
    end
    return false
end

-- check if a dash started on this tick
local function dashStarted()
    local dash_state = globals.truth.p1_state.dash:getValue()
    if (dash_state.current and dash_state.previous == false) then
        return true
    end
    return false
end

local p1_events = {
    dash = {},
    dash_attack = {},
--    jump = {},
--    jump_attack = {},
}

-- state checking functions associated to keys of p1_events
local p1_event_checkers = {
    dash = dashStarted,
    dash_attack = dashAttackStarted,
}

-- information to send to gui
-- (not atomic game state information)
local derived_events = {
    dash_attack_lengths = {},
}

-- after all the event information is written to p1_events,
-- run all these.
local p1_event_postprocessors = {}


-- if dash attack occurred, write its length
local function write_dash_attack_length()
    if dashAttackStarted() then
        local dash = p1_events["dash"][#p1_events["dash"]]
        local atk = p1_events["dash_attack"][#p1_events["dash_attack"]]
        -- inputs are 2 ticks earlier than the state change
        -- (with this timing setup)
        local dash_input_tick = dash.tick - 2
        local atk_input_tick = atk.tick - 2
        local dash_input_frame = globals.truth.get_frame_from_tick(
            dash_input_tick, atk.tick, atk.frame, atk.cycle)
        local atk_input_frame = globals.truth.get_frame_from_tick(
            atk_input_tick, atk.tick, atk.frame, atk.cycle)
        local record = {}
        record["frame_diff"] = atk_input_frame - dash_input_frame
        record["tick_diff"] = atk_input_tick - dash_input_tick
        table.insert(derived_events.dash_attack_lengths, record)
        if #derived_events.dash_attack_lengths > BUFFER_LEN then
            table.remove(derived_events.dash_attack_lengths, 1)
        end
        print("DEBUG:", record, atk_input_frame, dash_input_frame,
            atk_input_tick, dash_input_tick)
    end
end
table.insert(p1_event_postprocessors, write_dash_attack_length)


-- get_event_scribe returns a func to be passed to queue:subscribe
-- pass a bool function of state, table, and max table size
-- the bool function will be tested every tick
-- if true, the timing info (tick/frame/cycle) is appended to the table
--
-- state_test: function that returns a bool based on state
--   ex: dashStarted, dashAttackStarted
-- ledger: a table to update
-- max_ledger_size: max table length before earliest entry is deleted
local function get_event_scribe(state_test, ledger, max_ledger_size)
    local function subscribe_func(tick)
        if state_test() then
            local timings = {}
            timings["tick"] = tick
            timings["frame"] = globals.truth.framer:getValue()
            timings["cycle"] = globals.truth.cycler:getValue()
            table.insert(ledger, timings)
            if #ledger > max_ledger_size then
                table.remove(ledger, 1)
            end
        end
    end
    return subscribe_func
end

local playerStateServiceModule = {
    -- initialize after globals.truth and globals.dummy_state_service
    ["registerStart"] = function()
        -- scribes will handle recording state data in a global table
        local scribes = {}
        for event,ledger in pairs(p1_events) do
            table.insert(scribes, get_event_scribe(
                p1_event_checkers[event], ledger, BUFFER_LEN))
        end

        globals.truth.ticker:subscribe(function(tick)
            -- record all event data
            for _, scribe in ipairs(scribes) do
                scribe(tick)
            end
            for _, postprocessor in ipairs(p1_event_postprocessors) do
                postprocessor()
            end
        end)
    end,
    ["p1_events"] = p1_events,
    ["p1_derived_events"] = derived_events,
}
return playerStateServiceModule
