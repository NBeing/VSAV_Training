-- players
function make_input_set(_value)
    return {
      up = _value,
      down = _value,
      left = _value,
      right = _value,
      LP = _value,
      MP = _value,
      HP = _value,
      LK = _value,
      MK = _value,
      HK = _value,
      start = _value,
      coin = _value
    }
  end
  
  function make_player_object(_id, _base, _prefix)
    return {
      id = _id,
      base = _base,
      prefix = _prefix,
      input = {
        pressed = make_input_set(false),
        released = make_input_set(false),
        down = make_input_set(false),
        state_time = make_input_set(0),
      },
      blocking = {
        last_attack_hit_id = 0,
        next_attack_hit_id = 0,
        wait_for_block_string = true,
        block_string = false,
      },
      counter = {
        attack_frame = -1,
        ref_time = -1,
        recording_slot = -1,
      },
      throw = {},
      max_meter_gauge = 0,
      max_meter_count = 0,
    }
  end
  function reset_player_objects()
    player_objects = {
      make_player_object(1, 0x02068C6C, "P1"),
      make_player_object(2, 0x02069104, "P2")
    }
  
    P1 = player_objects[1]
    P2 = player_objects[2]
  
    P1.gauge_addr = 0x020695B5
    P1.meter_addr = { 0x020286AB, 0x020695BF }
    P1.stun_base = 0x020695FD
  
    P2.gauge_addr = 0x020695E1
    P2.meter_addr = { 0x020286DF, 0x020695EB}
    P2.stun_base = 0x02069611
  end
  reset_player_objects()
  
  function update_input(_player_obj)
    function update_player_input(_input_object, _input_name, _input)
      _input_object.pressed[_input_name] = false
      _input_object.released[_input_name] = false
      if _input_object.down[_input_name] == false and _input then _input_object.pressed[_input_name] = true end
      if _input_object.down[_input_name] == true and _input == false then _input_object.released[_input_name] = true end
  
      if _input_object.down[_input_name] == _input then
        _input_object.state_time[_input_name] = _input_object.state_time[_input_name] + 1
        -- print("inc_inp",_input_object.down[_input_name],  _input_object.state_time[_input_name])
      else
        _input_object.state_time[_input_name] = 0
      end
      _input_object.down[_input_name] = _input
    end
  
    local _local_input = joypad.get()
    update_player_input(_player_obj.input, "start", _local_input[_player_obj.prefix.." Start"])
    update_player_input(_player_obj.input, "coin", _local_input[_player_obj.prefix.." Coin"])
    update_player_input(_player_obj.input, "up", _local_input[_player_obj.prefix.." Up"])
    update_player_input(_player_obj.input, "down", _local_input[_player_obj.prefix.." Down"])
    update_player_input(_player_obj.input, "left", _local_input[_player_obj.prefix.." Left"])
    update_player_input(_player_obj.input, "right", _local_input[_player_obj.prefix.." Right"])
    update_player_input(_player_obj.input, "LP", _local_input[_player_obj.prefix.." Weak Punch"])
    update_player_input(_player_obj.input, "MP", _local_input[_player_obj.prefix.." Medium Punch"])
    update_player_input(_player_obj.input, "HP", _local_input[_player_obj.prefix.." Strong Punch"])
    update_player_input(_player_obj.input, "LK", _local_input[_player_obj.prefix.." Weak Kick"])
    update_player_input(_player_obj.input, "MK", _local_input[_player_obj.prefix.." Medium Kick"])
    update_player_input(_player_obj.input, "HK", _local_input[_player_obj.prefix.." Strong Kick"])
  end

  function read_player_vars(_player1_obj, _player2_obj)
    update_input(_player1_obj)
    update_input(_player2_obj)
    -- if  memory.readdword(0xFF8804) == 0x02020400 then
    --   print("got it")
    -- end

    if last_dummy_dict then

      local current = last_dummy_dict[globals.current_frame]
      local prev = last_dummy_dict[globals.current_frame - 1]

      if current and prev then
        player_objects[1].flip_input = current.p1_facing == "right" 
        player_objects[2].flip_input = current.p2_facing == "right" 

        -- if current.p2_status_1 == "Hurt or Block" then 
        --   print("hurt or block")
        -- end
        if current.p2_guarding == true and prev.p2_guarding == false then 
          player_objects[2].started_guarding  = true
        else
          player_objects[2].started_guarding  = false
        end

        if prev.p2_pushback_timer > 0 and current.p2_pushback_timer == 0 then 
          player_objects[2].guard_ended  = true
        else
          player_objects[2].guard_ended  = false
        end
        if not prev.p2_reversal_frame and current.p2_reversal_frame then 
          player_objects[2].p2_trigger_reversal  = true
        else
          player_objects[2].p2_trigger_reversal  = false
          
        end
        
        -- Table to keep track of short hop dash counter
        if prev.p1_is_dashing and not current.p1_is_dashing then
          globals.last_dash_ended = emu.framecount()
          local cur_short_hop_counter = util.tablelength(globals.short_hop_counter)
          if globals.last_dash_started ~= nil then
            local diff = globals.last_dash_ended - globals.last_dash_started
            if cur_short_hop_counter == 1000 then
              table.remove(globals.short_hop_counter, 1)
              table.insert(globals.short_hop_counter, diff)
            else
              table.insert(globals.short_hop_counter, diff)
            end  
          end
          player_objects[1].stopped_dashing = true
        else
          player_objects[1].stopped_dashing = false
        end

        -- Case where the dash has ended
        -- We set last_dash_ended to emu.framecount()
        if prev.p1_is_dashing and not current.p1_is_dashing then
          globals.last_dash_ended = emu.framecount()
          local cur_dash_length_frames = util.tablelength(globals.dash_length_frames)
          if globals.last_dash_started ~= nil then
            local diff = globals.last_dash_ended - globals.last_dash_started
            if cur_dash_length_frames == 10 then
              table.remove(globals.dash_length_frames, 1)
              table.insert(globals.dash_length_frames, diff)
            else
              table.insert(globals.dash_length_frames, diff)
            end  
          end
          player_objects[1].stopped_dashing = true
        else
          player_objects[1].stopped_dashing = false
        end
        -- Case where dash begins
        if not prev.p1_is_dashing and current.p1_is_dashing then 
          player_objects[1].started_dashing  = true
          globals.last_dash_started = emu.framecount()
          local cur_time_between_dashes = util.tablelength(globals.time_between_dashes)

          if globals.last_dash_ended == nil then 
            globals.last_dash_ended = emu.framecount()
          end
          local diff = globals.last_dash_started - globals.last_dash_ended
          if cur_time_between_dashes == 10 then
            table.remove(globals.time_between_dashes,1)
            table.insert(globals.time_between_dashes, diff )
          else
            table.insert(globals.time_between_dashes, diff)            
          end
          if current.p1_in_air then 
            local cur = util.tablelength(globals.airdash_heights)
            if cur == 10 then
              table.remove(globals.airdash_heights,1)
              table.insert(globals.airdash_heights, current.p1_y )
              -- globals.airdash_heights[cur  + 1] = current.p1_y
            else
              table.insert(globals.airdash_heights, current.p1_y )            end
          end
        else
          player_objects[1].started_dashing  = false
        end
      end
    end 
  end
  return {
      ["update_input"]         = update_input,
      ["reset_player_objects"] = reset_player_objects,
      ["make_player_object"]   = make_player_object,
      ["make_input_set"]       = make_input_set,
      ["read_player_vars"]     = read_player_vars
  }