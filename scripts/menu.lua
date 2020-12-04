-- menu
text_default_color = 0xF7FFF7FF
text_default_border_color = 0x101008FF
text_selected_color = 0xFF0000FF
text_disabled_color = 0x999999FF

function checkbox_menu_item(_name, _object, _property_name, _default_value)
    if _default_value == nil then _default_value = false end
    local _o = {}
    _o.name = _name
    _o.object = _object
    _o.property_name = _property_name
    _o.default_value = _default_value
  
    function _o:draw(_x, _y, _selected)
      local _c = text_default_color
      local _prefix = ""
      local _suffix = ""
      if _selected then
        _c = text_selected_color
        _prefix = "< "
        _suffix = " >"
      end
  
      local _value = ""
      if self.object[self.property_name] then
        _value = "yes"
      else
        _value = "no"
      end
      gui.text(_x, _y, _prefix..self.name.." : ".._value.._suffix, _c, text_default_border_color)
    end
  
    function _o:left()
      self.object[self.property_name] = not self.object[self.property_name]
    end
  
    function _o:right()
      self.object[self.property_name] = not self.object[self.property_name]
    end
  
    function _o:reset()
      self.object[self.property_name] = self.default_value
    end
  
    function _o:legend()
      return "MP: Reset to default"
    end
  
    return _o
end
function list_menu_item(_name, _object, _property_name, _list, _default_value)
    if _default_value == nil then _default_value = 0 end
    local _o = {}
    -- print("_list", _list[0])
    _o.name = _name
    _o.object = _object
    _o.property_name = _property_name
    _o.list = _list
    _o.default_value = _default_value
  
    function _o:draw(_x, _y, _selected)
      local _c = text_default_color
      local _prefix = ""
      local _suffix = ""
      if _selected then
        _c = text_selected_color
        _prefix = "< "
        _suffix = " >"
      end
      gui.text(_x, _y, _prefix..self.name.." : "..tostring(self.list[self.object[self.property_name]]).._suffix, _c, text_default_border_color)
    end
  
    function _o:left()
      self.object[self.property_name] = self.object[self.property_name] - 1
      if self.object[self.property_name] < 0 then
        self.object[self.property_name] = #self.list
      end
    end
  
    function _o:right()
      self.object[self.property_name] = self.object[self.property_name] + 1
      if self.object[self.property_name] > #self.list then
        self.object[self.property_name] = 0
      end
    end
  
    function _o:reset()
      self.object[self.property_name] = self.default_value
    end
  
    function _o:legend()
      return "MP: Reset to default"
    end
  
    return _o
  end
  function integer_menu_item(_name, _object, _property_name, _min, _max, _loop, _default_value, _autofire_rate)
    if _default_value == nil then _default_value = _min end
    local _o = {}
    _o.name = _name
    _o.object = _object
    _o.property_name = _property_name
    _o.min = _min
    _o.max = _max
    _o.loop = _loop
    _o.default_value = _default_value
    _o.autofire_rate = _autofire_rate
  
    function _o:draw(_x, _y, _selected)
      local _c = text_default_color
      local _prefix = ""
      local _suffix = ""
      if _selected then
        _c = text_selected_color
        _prefix = "< "
        _suffix = " >"
      end
      gui.text(_x, _y, _prefix..self.name.." : "..tostring(self.object[self.property_name]).._suffix, _c, text_default_border_color)
    end
  
    function _o:left()
      self.object[self.property_name] = self.object[self.property_name] - 1
      if self.object[self.property_name] < self.min then
        if self.loop then
          self.object[self.property_name] = self.max
        else
          self.object[self.property_name] = self.min
        end
      end
    end
  
    function _o:right()
      self.object[self.property_name] = self.object[self.property_name] + 1
      if self.object[self.property_name] > self.max then
        if self.loop then
          self.object[self.property_name] = self.min
        else
          self.object[self.property_name] = self.max
        end
      end
    end
  
    function _o:reset()
      self.object[self.property_name] = self.default_value
    end
  
    function _o:legend()
      return "MP: Reset to default"
    end
  
    return _o
  end
  
dummy_neutral = {
    [0] = "None",
    "Down Back",
    "Down",
    "Down Forward",
    "Back",
    "Forward",
    "Up Back",
    "Up",
    "Up Forward"
}
gc_button = {
    [0] = "None",
    "Punch",
    "Kick",
    "Three Punch",
    "Three Kick"
}

roll_direction = {
    [0] = "None",
    "Towards",
    "Away",
    "Random (All)",
    "Random (Left/Right Only)"
}
guard_action_type = {
    [0] = "None",
    "Guard Cancel",
    "Push Block",
    -- "Counter Attack",
    "Reversal"
}

_push_block_type = {
    [0] = "None",
    "All Light (6 frames)",
    "All Medium (6 frames)",
    "All Heavy (6 frames)",
    "Ascending (LP,LK,MP,MK,HP,HK)",
    "Descending (HP,HK,MP,MK,LP,LK)"
}
local counter_attack_type = {
    [0] = "None",
    "LP",
    "LK",
    "MP",
    "MK",
    "HP",
    "HK",
    "Up Back",
    "cr.LP",
    "cr.LK",
    "cr.MP",
    "cr.MK",
    "cr.HP",
    "cr.HK",
}
local counter_attack_random_upback = {
  [0] = "None",
  "25%",
  "50%",
  "75%",
  "100%",
}

gc_freq = {
    [0] = "None",
    "25%",
    "50%",
    "75%",
    "100%",
}
guard = {
    [0] = "None",
    "Block",
    "autoguard"
}

-- function list_menu_item(_name, _object, _property_name, _list, _default_value)
menu = {
    {
        name = "Game Settings",
        entries = {
          checkbox_menu_item("Infinite Time", training_settings, "infinite_time"),
          checkbox_menu_item("Show Hitboxes", training_settings, "show_hitboxes"),
        }
      },
    {
        name = "Dummy Settings",
        entries = {
            list_menu_item("Pose", training_settings, "dummy_neutral", dummy_neutral,0),
            list_menu_item("Wakeup", training_settings, "roll_direction", roll_direction,0),
            list_menu_item("Guard", training_settings, "guard", guard,0),
            list_menu_item("Guard Action Type", training_settings, "guard_action", guard_action_type, 0),
            list_menu_item("Guard Action Frequency", training_settings, "gc_freq", gc_freq,0),
            list_menu_item("Reversal Type", training_settings, "counter_attack", counter_attack_type, 0),
            list_menu_item("Guard Cancel Button", training_settings, "gc_button", gc_button,0),
            list_menu_item("Push Block Type", training_settings, "pb_type", _push_block_type,0),
            integer_menu_item("GC/PB Delay", training_settings, "gc_delay", 0, 15, false, 20),
        }
    }
}

main_menu_selected_index = 1
is_main_menu_selected = true
sub_menu_selected_index = 1
current_popup = nil

menuModule = {
    ["guiRegister"] = function()
        -- globals.show_menu = true
        if globals.show_menu then
            function check_input_down_autofire(_input, _autofire_rate, _autofire_time)
                _autofire_rate = _autofire_rate or 4
                _autofire_time = _autofire_time or 23
                for _i = 1, 2 do
                  if player_objects[_i].input.pressed[_input] or 
                  (player_objects[_i].input.down[_input] and 
                    player_objects[_i].input.state_time[_input] > 
                    _autofire_time and (player_objects[_i].input.state_time[_input] % _autofire_rate) == 0) then
                    return true
                  end
                end
                return false
            end
            local _current_entry = menu[main_menu_selected_index].entries[sub_menu_selected_index]

    if current_popup then
      _current_entry = current_popup.entries[current_popup.selected_index]
    end
    local _horizontal_autofire_rate = 2
    local _vertical_autofire_rate = 2
    if not is_main_menu_selected then
      if _current_entry.autofire_rate then
        _horizontal_autofire_rate = _current_entry.autofire_rate
      end
    end

    function _sub_menu_down()
      sub_menu_selected_index = sub_menu_selected_index + 1
      _current_entry = menu[main_menu_selected_index].entries[sub_menu_selected_index]
      if sub_menu_selected_index > #menu[main_menu_selected_index].entries then
        is_main_menu_selected = true
      elseif _current_entry.is_disabled ~= nil and _current_entry.is_disabled() then
        _sub_menu_down()
      end
    end

    function _sub_menu_up()
      sub_menu_selected_index = sub_menu_selected_index - 1
      _current_entry = menu[main_menu_selected_index].entries[sub_menu_selected_index]
      if sub_menu_selected_index == 0 then
        is_main_menu_selected = true
      elseif _current_entry.is_disabled ~= nil and _current_entry.is_disabled() then
        _sub_menu_up()
      end
    end

    if check_input_down_autofire("down", _vertical_autofire_rate) then
      if is_main_menu_selected then
        is_main_menu_selected = false
        sub_menu_selected_index = 0
        _sub_menu_down()
      elseif _current_entry.down and _current_entry:down() then
        util.save_training_data()
      elseif current_popup then
        current_popup.selected_index = current_popup.selected_index + 1
        if current_popup.selected_index > #current_popup.entries then
          current_popup.selected_index = 1
        end
      else
        _sub_menu_down()
      end
    end

    if check_input_down_autofire("up", _vertical_autofire_rate) then
      if is_main_menu_selected then
        is_main_menu_selected = false
        sub_menu_selected_index = #menu[main_menu_selected_index].entries + 1
        _sub_menu_up()
      elseif _current_entry.up and _current_entry:up() then
          util.save_training_data()
      elseif current_popup then
        current_popup.selected_index = current_popup.selected_index - 1
        if current_popup.selected_index == 0 then
          current_popup.selected_index = #current_popup.entries
        end
      else
        _sub_menu_up()
      end
    end

    if check_input_down_autofire("left", _horizontal_autofire_rate) then
      if is_main_menu_selected then
        main_menu_selected_index = main_menu_selected_index - 1
        if main_menu_selected_index == 0 then
          main_menu_selected_index = #menu
        end
      elseif _current_entry.left then
        _current_entry:left()
        util.save_training_data()
      end
    end

    if check_input_down_autofire("right", _horizontal_autofire_rate) then
      if is_main_menu_selected then
        main_menu_selected_index = main_menu_selected_index + 1
        if main_menu_selected_index > #menu then
          main_menu_selected_index = 1
        end
      elseif _current_entry.right then
        _current_entry:right()
        util.save_training_data()
      end
    end
            -- screen size 383,223
            local _gui_box_bg_color = 0x293139FF
            local _gui_box_outline_color = 0x840000FF
            local _menu_box_left = 23
            local _menu_box_top = 20
            local _menu_box_right = 360
            local _menu_box_bottom = 180
            gui.box(_menu_box_left, _menu_box_top, _menu_box_right, _menu_box_bottom, _gui_box_bg_color, _gui_box_outline_color)
            local _bar_x = _menu_box_left + 18
            local _bar_y = _menu_box_top + 6
            for i = 1, #menu do
            local _offset = 0
            local _c = text_disabled_color
            local _t = menu[i].name
            if is_main_menu_selected and i == main_menu_selected_index then
                _t = "< ".._t.." >"
                _offset = -8
                _c = text_selected_color
            elseif i == main_menu_selected_index then
                _c = text_default_color
            end
            gui.text(_bar_x + _offset + (i - 1) * 85, _bar_y, _t, _c, text_default_border_color)
            end

            local _menu_x = _menu_box_left + 10
            local _menu_y = _menu_box_top + 23
            local _menu_y_interval = 10
            local _draw_index = 0
            for i = 1, #menu[main_menu_selected_index].entries do
            if menu[main_menu_selected_index].entries[i].is_disabled == nil or not menu[main_menu_selected_index].entries[i].is_disabled() then
                menu[main_menu_selected_index].entries[i]:draw(_menu_x, _menu_y + _menu_y_interval * _draw_index, not is_main_menu_selected and not current_popup and sub_menu_selected_index == i)
                _draw_index = _draw_index + 1
            end
            end

            -- check1 = checkbox_menu_item("Infinite Time", {["infinite_time"] = true}, "infinite_time")
            -- check2 = checkbox_menu_item("Infinite Time", {["infinite_time"] = true}, "infinite_time")
            -- check1:draw(100,100,true)

            -- if mo_show_facing == true then            
            --     gui.box(0, 0, 100, 20, text_default_color, text_default_border_color)
            --     gui.text(5, 2, "p1_facing: "..globals.dummy.p1_facing, text_default_color, text_default_border_color)
            --     gui.text(5, 10, "p2_facing: "..globals.dummy.p2_facing, text_default_color, text_default_border_color)
            --     gui.text(5, 18, "P1 Y : "..memory.readword(0xFF8400 + 0x14), text_default_color, text_default_border_color)
            -- end
        else
            gui.box(0,0,0,0,0,0) -- if we don't draw something, what we drawed from last frame won't be cleared
        end
    end
}

return menuModule