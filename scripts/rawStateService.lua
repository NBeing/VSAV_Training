-- Provides:
-- * input logging in console
-- * handles updates for globals.dummy_state_service
-- * exposes p1_state, a table of state delta observables
--     * p1_state["dash"] is an observable you can follow
--     * or use p1_state["dash"]:getValue() for immediate result
--       * returned object has keys "current", "previous",
--         "cycle", "frame", "tick"
--     * this can be refactored but it works
local exposed_deltas = {}

-- ticker:getValue() is like emu.framecount() for logical frames (ticks)
local ticker = Rx.BehaviorSubject.create(0)
-- framer updates at same time as ticker
-- but on skipped ticks, framer will send a duplicate frame value
-- ex: 1,2,3,3,4 ...
local framer = Rx.BehaviorSubject.create(0)
-- cycler updates at the same time as ticker
-- it gives turbo cycle: 0,1,2 are drawn ticks, 3 is skipped tick
local cycler = Rx.BehaviorSubject.create(nil)



-- Given a buffered stream of tables (ReplaySubject),
-- and a key for those tables, return a stream of delta events for given key
-- Returns a BehaviorSubject, last event can be read with :getValue()
-- Inherits the k:v pairs for "cycle", "frame", "tick", if they exist.
-- @arg {Rx.ReplaySubject} table_producer - a buffered channel of tables
-- @arg {string} key - a key for the ReplaySubject table stream
-- @returns {Rx.BehaviorSubject} - has delta info for given key
-- @returns {Rx.Subscription} - cancelfunc
local function pluckDeltaSubject(table_producer, key)
	if tostring(table_producer) ~= 'ReplaySubject' then
		error('Expected Rx.ReplaySubject')
	end
	if not key or type(key) ~= 'string' then
		error('Expected string key')
	end

	local function get_delta()
		local buffer_size = #table_producer.buffer
        local initial = {}
		if buffer_size < 1 then
			return initial
		end
		local current = table_producer.buffer[buffer_size][1]
        initial["cycle"]   = current["cycle"]
        initial["frame"]   = current["frame"]
        initial["tick"]    = current["tick"]
        initial["current"] = current[key]
		if buffer_size < 2 then
			return initial
		end
        local previous = table_producer.buffer[buffer_size - 1][1]
		initial["previous"] = previous[key]
		return initial
	end

	local initial_value = get_delta()
	local delta_subject = Rx.BehaviorSubject.create(initial_value)

	-- don't see a way to make the behaviorsubject subscribe to something
	-- directly; so make an observer that sends on behaviorsubject
	-- (following rx.Observable:takeLast, which hates ReplaySubjects)
	-- this subscription ignores sent values and just uses enclosed buffer
	local subscription = table_producer:subscribe(function()
		delta_subject(get_delta())
	end)

	return delta_subject, subscription
end


-- given a tick, what frame did it occur on?
-- target_tick: the tick you wanna know the frame of
-- known_tick, known_frame, known_cycle: tick/frame/cycle from same tick
--   these can be obtained from ticker, framer, cycler
-- output the frame associated to target_tick
local function get_frame_from_tick(target_tick, known_tick, known_frame,
    known_cycle)
    local tick_delta = known_tick - target_tick
    -- WLOG known_tick >= target_tick.
    if tick_delta < 0 then
        local base_tick = known_tick + 4 * (math.ceil(tick_delta / 4))
        local base_frame = known_frame + 3 * (math.ceil(tick_delta / 4))
        return get_frame_from_tick(target_tick,
            base_tick, base_frame, known_cycle)
    end
    -- first get frame of greatest tick <= target tick
    -- (with cycle same as starting cycle)
    -- want smallest multiple of 4 greater than tick delta
    local base_tick = known_tick - 4 * (math.ceil(tick_delta / 4))
    local base_cycle = known_cycle
    local base_frame = known_frame - 3 * (math.ceil(tick_delta / 4))
    while base_tick < target_tick do
        base_tick = base_tick + 1
        base_cycle = math.fmod(base_cycle + 1,4)
        -- don't increment frame when going from cycle 1 to 2
        base_frame = base_frame + ((base_cycle ~= 2) and 1 or 0)
    end
    return base_frame
end

local function print_deltas()
    for k,v in pairs(exposed_deltas) do
	    local state = v:getValue()
        local cycle, frame, tick = state.cycle, state.frame, state.tick
	    if state.previous ~= state.current then
		local state_description = "end"
		if state.current then
			state_description = "begin"
		end

        local timestamp = string.format("cycle %d; frame %d (tick %d):",
            cycle, frame, tick)
		print(timestamp, k, state_description)
	    end
    end
end

-- input logging util:
-- accept list of 6 bools representing presses
-- [LP, MP, HP, LK, MK, HK], provided by inputHistory.lua
-- return string of pressed buttons
local button_names = {"LP ", "MP ", "HP ", "LK ", "MK ", "HK "}
local function format_btns(buttons)
  local pressed_names = ""
  for i = 1,6 do
    local nextString = "   "
    if buttons[i]==true then
      nextString = button_names[i]
    end
    pressed_names = pressed_names .. nextString
  end
  return pressed_names
end

local rawStateServiceModule = {
  ["registerStart"] = function()
	  -- log inputs to console
    local p1_input_history_subscription = globals.history_service_p1:subscribe(function(input_data)
	local cycle, frame, tick = cycler:getValue(), framer:getValue(), ticker:getValue()
	local dir = input_data.direction
	local btns = format_btns(input_data.buttons)
	print(string.format("cycle %d; frame %d (tick %d): %d %s",
		cycle, frame, tick, dir, btns))
      end)

--    local history_sub_p2 = globals.history_service_p2:subscribe(print)

    exposed_deltas["dash"] = pluckDeltaSubject(
    	globals.dummy_state_service, 'p1_is_dashing')
    exposed_deltas["attack"] = pluckDeltaSubject(
    	globals.dummy_state_service, 'p1_is_attacking')
    exposed_deltas["crouch"] = pluckDeltaSubject(
    	globals.dummy_state_service, 'p1_is_crouching')
    exposed_deltas["air"] = pluckDeltaSubject(
    	globals.dummy_state_service, 'p1_in_air')

    -- ticker updates whenever we read the tick mid-frame
    -- dummy_state_service also updates at this time
    globals.frameskipService.get_current_frame_frameskip_data():
    	subscribe(function(foo)
            print_deltas() -- view info about last frame
            -- before we overwrite last frame's timers

            local tick = ticker:getValue()+1
            local cycle = math.fmod(foo.calculated_frameskip_index, 4)
            local frame = framer:getValue()
            if cycle ~= 2 then
                frame = frame+1
            end
            -- ^ The cycle numbers correspond to the frameskip flags
            --   exposed by the frameskip service in the following way.
            -- print(cycle, foo.next_frame_will_be_skipped,
            --       foo.last_frame_was_skipped)
            -- 0 false false
            -- 1 true false
            -- 2 false true
            -- 3 false false

            globals.dummy_state_service_updater(cycle, frame, tick)

            -- Clocks must update last
            -- Clock consumers will assume that state data is fresh
            cycler(cycle)
            framer(frame)
            ticker(tick)
        end)
  end,
  ["p1_state"] = exposed_deltas,
  -- counts logical frames (ticks)
  ["ticker"] = ticker,
  -- counts animation frames, updates on same ticks as emu.framecount
  -- will repeat last value on the skipped tick
  ["framer"] = framer,
  -- counts mod 4 turbo cycle (intended for use on turbo 3)
  ["cycler"] = cycler,
  -- compute past frame a tick landed on, given a reference triple:
  -- tick+frame+cycle from the same tick
  ["get_frame_from_tick"] = get_frame_from_tick,
}
return rawStateServiceModule
