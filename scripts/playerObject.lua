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
    update_player_input(_player_obj.input, "start",  _local_input[_player_obj.prefix.." Start"])
    update_player_input(_player_obj.input, "coin",   _local_input[_player_obj.prefix.." Coin"])
    update_player_input(_player_obj.input, "up",     _local_input[_player_obj.prefix.." Up"])
    update_player_input(_player_obj.input, "down",   _local_input[_player_obj.prefix.." Down"])
    update_player_input(_player_obj.input, "left",   _local_input[_player_obj.prefix.." Left"])
    update_player_input(_player_obj.input, "right",  _local_input[_player_obj.prefix.." Right"])
    update_player_input(_player_obj.input, "LP",     _local_input[_player_obj.prefix.." Button 1"])
    update_player_input(_player_obj.input, "MP",     _local_input[_player_obj.prefix.." Button 2"])
    update_player_input(_player_obj.input, "HP",     _local_input[_player_obj.prefix.." Button 3"])
    update_player_input(_player_obj.input, "LK",     _local_input[_player_obj.prefix.." Button 4"])
    update_player_input(_player_obj.input, "MK",     _local_input[_player_obj.prefix.." Button 5"])
    update_player_input(_player_obj.input, "HK",     _local_input[_player_obj.prefix.." Button 6"])
  end

  function read_player_vars(_player_obj)
    update_input(_player_obj)
  end
  return {
      ["update_input"]         = update_input,
      ["reset_player_objects"] = reset_player_objects,
      ["make_player_object"]   = make_player_object,
      ["make_input_set"]       = make_input_set,
      ["read_player_vars"]     = read_player_vars
  }