-- menu
text_default_color = 0xF7FFF7FF
text_default_border_color = 0x101008FF
text_selected_color = 0xFF0000FF
text_disabled_color = 0x999999FF
charMovesModule   = require "./scripts/charMoves"
function check_input_down_autofire(_player_object, _input, _autofire_rate, _autofire_time)
  _autofire_rate = _autofire_rate or 4
  _autofire_time = _autofire_time or 23
  if _player_object.input.pressed[_input] or (_player_object.input.down[_input] and _player_object.input.state_time[_input] > _autofire_time and (_player_object.input.state_time[_input] % _autofire_rate) == 0) then
    return true
  end
  return false
end

function gauge_menu_item(_name, _object, _property_name, _unit, _fill_color, _gauge_max, _subdivision_count)
  local _o = {}
  _o.name = _name
  _o.object = _object
  _o.property_name = _property_name
  _o.player_id = _player_id
  _o.autofire_rate = 1
  _o.unit = _unit or 2
  _o.gauge_max = _gauge_max or 0
  _o.subdivision_count = _subdivision_count or 1
  _o.fill_color = _fill_color or 0x0000FFFF

  function _o:draw(_x, _y, _selected)
    local _c = text_default_color
    local _prefix = ""
    local _suffix = ""
    if _selected then
      _c = text_selected_color
      _prefix = "< "
      _suffix = " >"
    end
    gui.text(_x, _y, _prefix..self.name.." : ", _c, text_default_border_color)

    local _box_width = self.gauge_max / self.unit
    local _box_top = _y + 1
    local _box_left = _x + get_text_width("< "..self.name.." : ") - 1
    local _box_right = _box_left + _box_width
    local _box_bottom = _box_top + 4
    gui.box(_box_left, _box_top, _box_right, _box_bottom, text_default_color, text_default_border_color)
    local _content_width = self.object[self.property_name] / self.unit
    gui.box(_box_left, _box_top, _box_left + _content_width, _box_bottom, self.fill_color, 0x00000000)
    for _i = 1, self.subdivision_count - 1 do
      local _line_x = _box_left + _i * self.gauge_max / (self.subdivision_count * self.unit)
      gui.line(_line_x, _box_top, _line_x, _box_bottom, text_default_border_color)
    end

    gui.text(_box_right + 2, _y, _suffix, _c, text_default_border_color)
  end

  function _o:left()
    self.object[self.property_name] = math.max(self.object[self.property_name] - self.unit, 0)
  end

  function _o:right()
    self.object[self.property_name] = math.min(self.object[self.property_name] + self.unit, self.gauge_max)
  end

  function _o:reset()
    self.object[self.property_name] = 0
  end

  function _o:legend()
    return "MP: Reset to default"
  end

  return _o
end

available_characters = {
  " ",
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "X",
  "Y",
  "Z",
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "-",
  "_",
}

function textfield_menu_item(_name, _object, _property_name, _default_value, _max_length)
  _default_value = _default_value or ""
  _max_length = _max_length or 16
  local _o = {}
  _o.name = _name
  _o.object = _object
  _o.property_name = _property_name
  _o.default_value = _default_value
  _o.max_length = _max_length
  _o.edition_index = 0
  _o.is_in_edition = false
  _o.content = {}

  function _o:sync_to_var()
    local _str = ""
    for i = 1, #self.content do
      _str = _str..available_characters[self.content[i]]
    end
    self.object[self.property_name] = _str
  end

  function _o:sync_from_var()
    self.content = {}
    for i = 1, #self.object[self.property_name] do
      local _c = self.object[self.property_name]:sub(i,i)
      for j = 1, #available_characters do
        if available_characters[j] == _c then
          table.insert(self.content, j)
          break
        end
      end
    end
  end

  function _o:crop_char_table()
    local _last_empty_index = 0
    for i = 1, #self.content do
      if self.content[i] == 1 then
        _last_empty_index = i
      else
        _last_empty_index = 0
      end
    end

    if _last_empty_index > 0 then
      for i = _last_empty_index, #self.content do
        table.remove(self.content, _last_empty_index)
      end
    end
  end

  function _o:draw(_x, _y, _selected)
    local _c = text_default_color
    local _prefix = ""
    local _suffix = ""
    if self.is_in_edition then
      _c =  0xFFFF00FF
    elseif _selected then
      _c = text_selected_color
    end

    local _value = self.object[self.property_name]

    if self.is_in_edition then
      local _cycle = 100
      if ((frame_number % _cycle) / _cycle) < 0.5 then
        gui.text(_x + (#self.name + 3 + #self.content - 1) * 4, _y + 2, "_", _c, text_default_border_color)
      end
    end

    gui.text(_x, _y, _prefix..self.name.." : ".._value.._suffix, _c, text_default_border_color)
  end

  function _o:left()
    if self.is_in_edition then
      self:reset()
    end
  end

  function _o:right()
    if self.is_in_edition then
      self:validate()
    end
  end

  function _o:up()
    if self.is_in_edition then
      self.content[self.edition_index] = self.content[self.edition_index] + 1
      if self.content[self.edition_index] > #available_characters then
        self.content[self.edition_index] = 1
      end
      self:sync_to_var()
      return true
    else
      return false
    end
  end

  function _o:down()
    if self.is_in_edition then
      self.content[self.edition_index] = self.content[self.edition_index] - 1
      if self.content[self.edition_index] == 0 then
        self.content[self.edition_index] = #available_characters
      end
      self:sync_to_var()
      return true
    else
      return false
    end
  end

  function _o:validate()
    if not self.is_in_edition then
      self:sync_from_var()
      if #self.content < self.max_length then
        table.insert(self.content, 1)
      end
      self.edition_index = #self.content
      self.is_in_edition = true
    else
      if self.content[self.edition_index] ~= 1 then
        if #self.content < self.max_length then
          table.insert(self.content, 1)
          self.edition_index = #self.content
        end
      end
    end
    self:sync_to_var()
  end

  function _o:reset()
    if not self.is_in_edition then
      _o.content = {}
      self.edition_index = 0
    else
      if #self.content > 1 then
        table.remove(self.content, #self.content)
        self.edition_index = #self.content
      else
        self.content[1] = 1
      end
    end
    self:sync_to_var()
  end

  function _o:cancel()
    if self.is_in_edition then
      self:crop_char_table()
      self:sync_to_var()
      self.is_in_edition = false
    end
  end

  function _o:legend()
    if self.is_in_edition then
      return "LP/Right: Next   MP/Left: Previous   LK: Leave edition"
    else
      return "LP: Edit   MP: Reset to default"
    end
  end

  _o:sync_from_var()
  return _o
end

function checkbox_menu_item(_name, _object, _property_name, _default_value, description)
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
  function _o:description()
    if description then
      return description
    else
      return ""
    end
  end
  return _o
end

function list_menu_item(_name, _object, _property_name, _list, _default_value, _item_description, _default_description )
  if _default_value == nil then _default_value = 1 end
  local _o = {}
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
    if self.object[self.property_name] == 0 then
      self.object[self.property_name] = #self.list
    end
  end

  function _o:right()
    self.object[self.property_name] = self.object[self.property_name] + 1
    if self.object[self.property_name] > #self.list then
      self.object[self.property_name] = 1
    end
  end

  function _o:reset()
    self.object[self.property_name] = self.default_value
  end

  function _o:legend()
    return "MP: Reset to default"
  end

  function _o:description()
    if type(_item_description) == "table" then
      if _item_description[self.object[self.property_name]] ~= nil then
        return _item_description[self.object[self.property_name]]
      elseif _default_description then
        return _default_description
      else 
        return "" 
      end
    elseif type(_item_description) == "string" then
      return _item_description
    elseif not _item_description and _default_description then
      return _default_description
    else
      return ""
    end
  end
  return _o
end

function integer_menu_item(_name, _object, _property_name, _min, _max, _loop, _default_value, _autofire_rate, description)
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
  function _o:description()
    if description then
      return description
    else
      return ""
    end
  end
  return _o
end

function map_menu_item(_name, _object, _property_name, _map_object, _map_property)
  local _o = {}
  _o.name = _name
  _o.object = _object
  _o.property_name = _property_name
  _o.map_object = _map_object
  _o.map_property = _map_property

  function _o:draw(_x, _y, _selected)
    local _c = text_default_color
    local _prefix = ""
    local _suffix = ""
    if _selected then
      _c = text_selected_color
      _prefix = "< "
      _suffix = " >"
    end

    local _str = string.format("%s%s : %s%s", _prefix, self.name, self.object[self.property_name], _suffix)
    gui.text(_x, _y, _str, _c, text_default_border_color)
  end

  function _o:left()
    if self.map_property == nil or self.map_object == nil or self.map_object[self.map_property] == nil then
      return
    end

    if self.object[self.property_name] == "" then
      for _key, _value in pairs(self.map_object[self.map_property]) do
        self.object[self.property_name] = _key
      end
    else
      local _previous_key = ""
      for _key, _value in pairs(self.map_object[self.map_property]) do
        if _key == self.object[self.property_name] then
          self.object[self.property_name] = _previous_key
          return
        end
        _previous_key = _key
      end
      self.object[self.property_name] = ""
    end
  end

  function _o:right()
    if self.map_property == nil or self.map_object == nil or self.map_object[self.map_property] == nil then
      return
    end

    if self.object[self.property_name] == "" then
      for _key, _value in pairs(self.map_object[self.map_property]) do
        self.object[self.property_name] = _key
        return
      end
    else
      local _previous_key = ""
      for _key, _value in pairs(self.map_object[self.map_property]) do
        if _previous_key == self.object[self.property_name] then
          self.object[self.property_name] = _key
          return
        end
        _previous_key = _key
      end
      self.object[self.property_name] = ""
    end
  end

  function _o:reset()
    self.object[self.property_name] = ""
  end

  function _o:legend()
    return "MP: Reset to default"
  end

  return _o
end

function button_menu_item(_name, _validate_function)
  local _o = {}
  _o.name = _name
  _o.validate_function = _validate_function
  _o.last_frame_validated = 0

  function _o:draw(_x, _y, _selected)
    local _c = text_default_color
    if _selected then
      _c = text_selected_color

      if (frame_number - self.last_frame_validated < 5 ) then
        _c = 0xFFFF00FF
      end
    end

    gui.text(_x, _y,self.name, _c, text_default_border_color)
  end

  function _o:validate()
    self.last_frame_validated = frame_number
    if self.validate_function then
      self.validate_function()
    end
  end

  function _o:legend()
    return "LP: Validate"
  end

  return _o
end

function make_popup(_left, _top, _right, _bottom, _entries)
  local _p = {}
  _p.left = _left
  _p.top = _top
  _p.right = _right
  _p.bottom = _bottom
  _p.entries = _entries

  return _p
end

dummy_neutral = {
    "None",
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
    "None",
    "Punch",
    "Kick",
    "Three Punch",
    "Three Kick"
}

roll_direction = {
    "None",
    "Towards",
    "Away",
    "Random (All)",
    "Random (Left/Right Only)"
}
guard_action_type = {
    "None",
    "Guard Cancel",
    "Push Block",
    "Reversal - Character Specific",
    "Reversal - Recording",
    "Reversal - Specified",
    "Counter Attack - Character Specific",
    "Counter Attack - Specified",
    "Counter Attack - Recording",
    "PB Recording",
}

_push_block_type = {
    "None",
    "All Light (6 frames)",
    "All Medium (6 frames)",
    "All Heavy (6 frames)",
    "Ascending (LP,LK,MP,MK,HP,HK)",
    "Descending (HP,HK,MP,MK,LP,LK)"
}
local counter_attack_button = {
  "None",
  "LP",
  "LK",
  "MP",
  "MK",
  "HP",
  "HK",
  "MP+HP",
  "MK+HK",
  "LP+LK",
  "MP+MK",
  "HP+HK",
}

local counter_attack_stick = {
  "none",
  "up",
  "up-back",
  "down-back",
  "up-forward",
  "down-forward",
  "QCF",
  "QCB",
  "HCF",
  "HCB",
  "DPF",
  "DPB",
  "360",
  -- "DQCF",
  "720",
  "back dash",
  "back dash cancel",
  "forward dash",
  "forward dash cancel",
  "Character Specific"
  -- "HCharge",
  -- "VCharge",
  -- "Shun Goku Ratsu", -- Gouki hidden SA1
  -- "Kongou Kokuretsu Zan", -- Gouki hidden SA2
}

local counter_attack_random_upback = {
  "None",
  "25%",
  "50%",
  "75%",
  "100%",
}

gc_freq = {
    "None",
    "25%",
    "50%",
    "75%",
    "100%",
}
p2_block_chance = {
  "None",
  "25%",
  "50%",
  "75%",
  "100%",
}
guard = {
    "None",
    "Stand Block",
    "autoguard",
    "All Guard"
}
input_event_type = {
  "None",
  "Guard Cancel",
  "Push Block"
}
recording_slot = {
  "Last Recording",
  "Slot 1",
  "Slot 2",
  "Slot 3",
  "Slot 4",
  "Slot 5",
}
anak_projectile = {
  "None",
  "Bulleta St.Hk",
  "Bulleta Missile",
  "Demitri Chaos Flare",
  "Morrigan Soul Fist",
  "Morrigan Air Soul Fist",
  "Anakaris Curse",
  "Aulbath Sonic Wave",
  "Lei-Lei Anki Oh",
  "Lillith Soul Flash",
  "Jedah Dio Sega"
}

-- This is for button or stick
local function check_for_counter_attack_disabled()
  return training_settings.guard_action ~= 6 and
          training_settings.guard_action ~= 8
end

local function check_for_gc_disabled()
  return training_settings.guard_action ~= 2 -- GC
end

local function check_for_pb_disabled_rev()
  return training_settings.guard_action ~= 0xA -- PB
end
local function check_for_pb_disabled()
  return training_settings.guard_action ~= 0x3 -- PB
end

local pb_button_menu_item = list_menu_item("Push Block Type", training_settings, "pb_type", _push_block_type, 1, {
  "No push block will be performed",
  "A light Push block will be input.\n his takes 12 frames e.g.: (lp, no input) x 6 ",
  "A medium Push block will be input.\nThis takes 12 frames e.g.: (mp, no input) x 6 ",
  "A heavy Push block will be input.\nThis takes 12 frames e.g.: (hp, no input) x 6 ",
  "An ascending push block will be input.\nThis takes 6 frames",
  "A descending push block will be input.\nThis takes 6 frames"
})
pb_button_menu_item.is_disabled = check_for_pb_disabled

local pb_rev_button_menu_item = list_menu_item("Push Block Type", training_settings, "pb_type_rec", _push_block_type, 1, {
  "No push block will be performed",
  "A light Push block will be input.\n his takes 12 frames e.g.: (lp, no input) x 6 ",
  "A medium Push block will be input.\nThis takes 12 frames e.g.: (mp, no input) x 6 ",
  "A heavy Push block will be input.\nThis takes 12 frames e.g.: (hp, no input) x 6 ",
  "An ascending push block will be input.\nThis takes 6 frames",
  "A descending push block will be input.\nThis takes 6 frames"
})
pb_rev_button_menu_item.is_disabled = check_for_pb_disabled_rev

local gc_button_menu_item = list_menu_item("Guard Cancel Button", training_settings, "gc_button", gc_button,1, { "Choose a GC button"})
gc_button_menu_item.is_disabled = check_for_gc_disabled

local counter_attack_stick_menu_item = list_menu_item("Reversal/Counter Input Motion", training_settings, "counter_attack_stick", counter_attack_stick, 1, "The motion to be input on reversal or counters.Note that these are manually\nperformed after the reversal window E.G. the direction is x many frames \nafter frame perfect where x is the number of inputs needed to perform \nthe move in general prefer character specific 1f specials")
counter_attack_stick_menu_item.is_disabled = check_for_counter_attack_disabled

local counter_attack_button_menu_item = list_menu_item("Reversal/Counter Button", training_settings, "counter_attack_button", counter_attack_button, 1, "In general the strength of move used\nIf stick is set to none this can be used as a counterpoke")
counter_attack_button_menu_item.is_disabled = check_for_counter_attack_disabled

local guard_action_delay_menu_item = integer_menu_item(
      "GC/PB/uf/ub/f/b dash cancel delay", training_settings, "gc_delay", 0, 50, false, 0, 0,
      "Generally this option delays the guard action.\nUse for a later GC or PB\nor to create jump + button, or dash + button scenarios"
    )
guard_action_delay_menu_item.is_disabled = function() 
  return  training_settings.guard_action == 1 or -- None
          training_settings.guard_action == 9 or -- CA Record
          training_settings.guard_action == 5 or -- REV record
          training_settings.guard_action == 7 or -- CA char Specific
          training_settings.guard_action == 4    -- REV char Specific
end

local guard_action_frequency_menu_item = list_menu_item("Guard Action Frequency", training_settings, "gc_freq", gc_freq,5, "Use to randomize whether the guard action is performed")
guard_action_frequency_menu_item.is_disabled = function() return training_settings.guard_action == 1 end

function set_p1_reversal_names()
  return charMovesModule.get_player_movelists().P1.reversal_names
end
function set_p2_reversal_names()
  return charMovesModule.get_player_movelists().P2.reversal_names
end
local p1_reversal_names = set_p1_reversal_names()
local p1_reversal_list_menu_item = list_menu_item("P1 Reversal List", training_settings, "p1_reversal_list", p1_reversal_names, 1)
local p1_reversal_strength_menu_item = list_menu_item("Reversal Strength", training_settings, "p1_reversal_strength", { "Light", "Medium","Heavy","ES"}, 1)

local function char_specific_reversal_is_disabled()
  return  training_settings.guard_action ~= 4 and
          training_settings.guard_action ~= 7
end
local p2_reversal_names = set_p2_reversal_names()
local p2_reversal_list_menu_item = list_menu_item("P2 Character Available Reversals", training_settings, "p2_reversal_list", p2_reversal_names, 1,  { "Use a reversal teehee"})
p2_reversal_list_menu_item.is_disabled = char_specific_reversal_is_disabled
local p2_reversal_strength_menu_item = list_menu_item("Strength", training_settings, "p2_reversal_strength", { "Light", "Medium","Heavy","ES"}, 1, nil, "The strength of the reversal,\nPlease use normal game values (e.g. EX for EX moves)")
p2_reversal_strength_menu_item.is_disabled = char_specific_reversal_is_disabled
local p2_block_chance_menu_item = list_menu_item("P2 Random Guard %", training_settings, "p2_block_chance", p2_block_chance, 5, nil, "Randomize Blocking")
p2_block_chance_menu_item.is_disabled = function() return training_settings.guard ~= 2 and training_settings.guard ~= 4 end

--1 "None",
--2 "Guard Cancel",
--3 "Push Block",
--4 "Reversal - Character Specific",
--5 "Reversal - Recording",
--6 "Reversal - Specified",
--7 "Counter Attack- Character Specific",
--8 "Counter Attack - Specified",
--9 "Counter Attack - Recording",

local reversal_calculation_menu_item = checkbox_menu_item("True Reversal", training_settings, "true_reversal", false, "Setting this to true means a true reversal will be used\nOn turbo speed a true frame one reversal is only possible 75% of the time,\nDue to the lack of granularity of FBNeo's LUA implementation other reversal\nactions are about 1-2 frames past earliest reversal time")
reversal_calculation_menu_item.is_disabled = function() 
  return  training_settings.guard_action == 1 or -- None
          training_settings.guard_action == 2 or -- PB
          training_settings.guard_action == 3  -- GC
end

local anak_menu_item = list_menu_item("Anak Projectile", training_settings, "anak_projectile", anak_projectile ,1, "Choose Which Projectile Anakaris has eaten")
anak_menu_item.is_disabled = function()
  return globals and globals.getCharacter(0xFF8400) ~= "Anakaris"
end
local lei_lei_stun_menu_item = checkbox_menu_item("Lei-Lei Always Stun Item", training_settings, "lei_lei_stun_item", false, "Lei-Lei will always toss a stun item")
lei_lei_stun_menu_item.is_disabled = function()
  return globals and globals.getCharacter(0xFF8400) ~= "Lei-Lei"
end

local is_random_playback_on = function() return training_settings.random_playback == false end
local enable_slot_1_menu_item = checkbox_menu_item("Enable Slot 1", training_settings, "enable_slot_1", 0, "Enable this slot for random recording")
enable_slot_1_menu_item.is_disabled = is_random_playback_on 
local enable_slot_2_menu_item = checkbox_menu_item("Enable Slot 2", training_settings, "enable_slot_2", 0, "Enable this slot for random recording")
enable_slot_2_menu_item.is_disabled = is_random_playback_on
local enable_slot_3_menu_item = checkbox_menu_item("Enable Slot 3", training_settings, "enable_slot_3", 0, "Enable this slot for random recording")
enable_slot_3_menu_item.is_disabled = is_random_playback_on
local enable_slot_4_menu_item = checkbox_menu_item("Enable Slot 4", training_settings, "enable_slot_4", 0, "Enable this slot for random recording")
enable_slot_4_menu_item.is_disabled = is_random_playback_on
local enable_slot_5_menu_item = checkbox_menu_item("Enable Slot 5", training_settings, "enable_slot_5", 0, "Enable this slot for random recording")
enable_slot_5_menu_item.is_disabled = is_random_playback_on

local function get_menu() 
return {
    {
        name = "Recording",
        entries = {
          checkbox_menu_item("Use Character Specific Slots", training_settings, 1, "use_character_specific_slots", "Setting this to true uses recording/playback slots for p2's character\nOtherwise non character specific slots are used"),
          list_menu_item("Recording Slot", training_settings, "recording_slot", recording_slot,1,"Choose a playback/recording slot\nWill be overriden by random playback"),
          checkbox_menu_item("Looped Playback", training_settings, "looped_playback", 0, "The playback slot will be played back when the current recording ends\nThis works with random playback slots enabled below\nas well as with guard actions"),
          checkbox_menu_item("Use Random Recording Slot", training_settings, "random_playback", 0, "This can be used in two ways:\n 1) Random playback file on reversal\n 2) Using looped playback mode a random playback file will be \n    played back when the current recording ends"),
          enable_slot_1_menu_item,
          enable_slot_2_menu_item,
          enable_slot_3_menu_item,
          enable_slot_4_menu_item,
          enable_slot_5_menu_item,
        }
      },
      {
        name = "Gauge",
        entries = {
          integer_menu_item("P1 Max Life", training_settings, "p1_max_life", 0, 288, false, 288, nil, "The max life, 288 is two bats"),
          integer_menu_item("P1 Refill Timer (seconds)", training_settings, "p1_refill_timer", 0, 20, false, 0, nil,"This timer controls when the life meter will be refilled.\nOccurs this many seconds after being hit"),
          checkbox_menu_item("P1 Infinite Dark Force", training_settings, "p1_infinite_df", 0, "The darkforce timer will be held at a value.\nDeactivate to end!"),
          integer_menu_item("P2 Max Life", training_settings, "p2_max_life", 0, 288, false, 288, nil, "The max life, 288 is two bats"),
          integer_menu_item("P2 Refill Timer (seconds)", training_settings, "p2_refill_timer", 0, 20, false, 0, nil, "This timer controls when the life meter will be refilled.\nOccurs this many seconds after being hit"),
          checkbox_menu_item("P2 Infinite Dark Force", training_settings, "p2_infinite_df", 0, "The darkforce timer will be held at a value.\nDeactivate to end!"),
        }
      },
    {
        name = "Player",
        entries = {
            list_menu_item("Pose", training_settings, "dummy_neutral", dummy_neutral,1,"The dummy will hold this direction."),
            list_menu_item("Wakeup", training_settings, "roll_direction", roll_direction,1, "Determines which direction the dummy will roll on knockdown"),
            anak_menu_item,
            lei_lei_stun_menu_item,
            checkbox_menu_item("Tech Throws", training_settings, "p2_throw_tech",0,"The dummy will tech throws at this %."),
            list_menu_item("Guard", training_settings, "guard", guard,1, "Autoguard will block everything, including unblockable setups.\nBlock will make the dummy tap back for one frame to put them in proxy block.\nCurrently does not work with all moves."),
            -- integer_menu_item("# Guard Frames", training_settings, "p2_refill_timer", 0, 20, false, 0, nil, "This timer controls when the life meter will be refilled.\nOccurs this many seconds after being hit"),

            p2_block_chance_menu_item,
            list_menu_item("Guard Action Type", training_settings, "guard_action", guard_action_type, 1, {
              --1 "None",
              --2 "Guard Cancel",
              --3 "Push Block",
              --4 "Reversal - Character Specific",
              --5 "Reversal - Recording",
              --6 "Reversal - Specified",
              --7 "Counter Attack- Character Specific",
              --8 "Counter Attack - Specified",
              --9 "Counter Attack - Recording",
              "No Guard Action will be performed",
              "The dummy will input a guard cancel manually.\nYou can delay this with the delay option in order to get later GC's\nYou can also set the frequency option to have it be performed randomly",
              "The dummy will input a push block manually.\nYou may choose the type, keep in mind guaranteed L/M/H are 12 frames total.\nYou can delay this with the delay option in order to get later PB's\nYou can also set the frequency option to have it be performed randomly",
              "Specify a character specific special move.\nto be performed after the dummy hurt, block, or wakeup",
              "A recording will be played after the opponent guards,is hurt, or wakes up.\nThe recording played can be set in the 'Recording' tab.\nThis can be specified or random\nFor notes on timing please read the notes for 'True Reversal'",
              "Specify an input to be performed after the dummy hurt, block, or wakeup.\nFor notes on timing please read the notes for 'True Reversal'",
              "Specify an action to be performed after the dummy blocks.\nFor notes on timing please read the notes for 'True Reversal'",
              "A recording will be played after the opponent finishes guarding.\nThe recording played can be set in the 'Recording' tab.\nThis can be specified or random\nFor notes on timing please read the notes for 'True Reversal'",
              "Specify a character specific special move.\nto be performed after the dummy is finished blocking",
              "Play recording after pushblock",
              
            }, "Use this to set up various counter attacks."),
            guard_action_frequency_menu_item,
            reversal_calculation_menu_item, 
            counter_attack_stick_menu_item,
            counter_attack_button_menu_item,
            gc_button_menu_item,
            pb_button_menu_item,
            pb_rev_button_menu_item,
            guard_action_delay_menu_item,
            p2_reversal_list_menu_item,
            p2_reversal_strength_menu_item,
        }
    },
    {
      name = "Display",
      entries = {
        -- checkbox_menu_item("Use Custom Palettes *at your own risk*", training_settings, "enable_custom_palette", "Shows Health and Meter values"),
        -- integer_menu_item("P1 Char Palette", training_settings, "p1_char_palette", 0, 255, false, 0,0,"Scroll through these on char select to see if you like one\nMany do not look good"),
        -- integer_menu_item("P2 Char Palette", training_settings, "p2_char_palette", 0, 255, false, 0,0,"Scroll through these on char select to see if you like one\nMany do not look good"),

        integer_menu_item("Scroll input viewer", training_settings, "inp_history_scroll", 0, 80, false, 0,0,"Allows you to scroll through past items in the input viewer."),
        checkbox_menu_item("HUD", training_settings, "display_hud", "Shows Health and Meter values"),
        checkbox_menu_item("Movelist", training_settings, "display_movelist", 1,"Shows a character specific move list"),
        checkbox_menu_item("Frame Data", training_settings, "mo_enable_frame_data",0, "Shows a breakdown of frame data. \nKeep in mind that this is subject to turbo 3 frameskip\nIn addition FBNEO is usually about a frame or two off :(\nIf you are interested, the MAME-RR version is accurate."),
        checkbox_menu_item("Recording GUI", training_settings, "display_recording_gui",1, "Shows the current recording staet"),
        checkbox_menu_item("Display Hitboxes", training_settings, "display_hitbox_default",1, "Display hitboxes for P1 and P2"),
        checkbox_menu_item("Show Pushblock Counter", training_settings, "display_pb_counter",1, "This option tracks how many PB buttons were registered during the pushblock window"),
        checkbox_menu_item("Show Damage Calc", training_settings, "show_damage_calc",1, "This shows a damage calculation.\nDamage calculations are recalculated on hit"),
        checkbox_menu_item("Show Scrolling Input", training_settings, "show_scrolling_input",1, "Display the Scrolling Input Viewer"),
        checkbox_menu_item("Show GC Trainer", training_settings, "show_gc_trainer", 1,"This option shows the GC window in the input viewer.\nThe Green GC shows when the window begins,\nand Red when it is performed or ends."),
        checkbox_menu_item("Show Pushbox Distance", training_settings, "show_x_distance", 1,"Gives a numerical / visual representation of the distances between characters"),
        checkbox_menu_item("Show IAD Trainer", training_settings, "display_airdash_trainer", 0,"This option shows the HEIGHT of your last few aidashes.\nGreen is best! Red is Worst!"),
        checkbox_menu_item("Show Dashes Interval", training_settings, "display_dash_interval_trainer", false,"Shows how long you were grounded between dashes.\nGreen is best! Red is Worst!"),
        checkbox_menu_item("Show Dash Time", training_settings, "display_dash_length_trainer", false,"Shows how many frames you dashed for.\nIf Sas then Smileys describe short hop success.\nGreen is best! Red is Worst!"),
      }
    },
    {
      name = "Timers/Testing",
      entries = {
        checkbox_menu_item("Show Invuln Timer", training_settings, "show_invuln_timer", false,""),
        checkbox_menu_item("Show Mash Timer", training_settings, "show_mash_timer", false,""),
        checkbox_menu_item("Show Throw Invulnerability Timer", training_settings, "show_throw_invuln_timer", false,""),
        checkbox_menu_item("Show Curse Timer", training_settings, "show_curse_timer", false,""),
        checkbox_menu_item("Show Push Block Timer", training_settings, "show_pb_timer", false,""),
        checkbox_menu_item("Show Push Block Push Back Timer", training_settings, "show_pb_pushback_timer", false,""), 
        checkbox_menu_item("Testing: PB Delayed Pushback Bug ", training_settings, "show_move_strength", false,""), 
      }
    }
}
end


main_menu_selected_index = 1
is_main_menu_selected = true
sub_menu_selected_index = 1
current_popup = nil

function togglemenu()
	globals.show_menu =  not globals.show_menu
	if globals.show_menu then
		globals.controllerModule.disable_both_players()
	else 
		globals.controllerModule.enable_both_players()
		globals.inpHistoryModule.reset_inp_history_scroll()
	end
end
function togglegraphmenu()
  globals.show_graph_menu =  not globals.show_graph_menu
  if globals.show_graph_menu then
    globals.graph_data_index = 0
    globals.update_graph_data()
  end
end
function inc_graph()
  if globals.show_graph_menu then
    globals.graph_data_index = globals.graph_data_index + 1   
    globals.update_graph_data()
  end
end
function dec_graph()
  if globals.show_graph_menu then
      globals.graph_data_index = globals.graph_data_index - 1   
      globals.update_graph_data()
  end
end
local is_main_menu_selected = true
menuModule = {
    ["registerStart"] = function()
      return{
        togglemenu = togglemenu,
        togglegraphmenu = togglegraphmenu,
        inc_graph = inc_graph,
        dec_graph = dec_graph
      }
    end,
    ["guiRegister"] = function()
      p1_reversal_names = set_p1_reversal_names()
      p2_reversal_names = set_p2_reversal_names()
      p1_reversal_list_menu_item = list_menu_item("P1 Reversal List", training_settings, "p1_reversal_list", p1_reversal_names, 1, nil, "These are 1f reversals triggered with code hacks. The inputs are not performed.\nPlease use caution! For instance throws cannot be done with lights\nEX should be done with the ES value" )
      p2_reversal_list_menu_item = list_menu_item("P2 Reversal List", training_settings, "p2_reversal_list", p2_reversal_names, 1, nil, "These are 1f reversals triggered with code hacks. The inputs are not performed.\nPlease use caution! For instance throws cannot be done with lights\nEX should be done with the ES value")
      p2_reversal_list_menu_item.is_disabled = char_specific_reversal_is_disabled

      p2_reversal_strength_menu_item = list_menu_item("Strength", training_settings, "p2_reversal_strength", { "Light", "Medium","Heavy","ES"}, 1, nil, "The strength of the reversal,\nPlease use normal game values (e.g. EX for EX moves)")
      p2_reversal_strength_menu_item.is_disabled = char_specific_reversal_is_disabled
      
      menu = get_menu()
      
      if globals then
        globals.p1_current_move_list = p1_reversal_names
        globals.p2_current_move_list = p2_reversal_names
      end

        -- globals.show_menu = true
        if globals.show_menu then
          local _current_entry = menu[main_menu_selected_index].entries[sub_menu_selected_index]
      
          if current_popup then
            _current_entry = current_popup.entries[current_popup.selected_index]
          end
          local _horizontal_autofire_rate = 4
          local _vertical_autofire_rate = 4
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
      
          if check_input_down_autofire(player_objects[1], "down", _vertical_autofire_rate) or check_input_down_autofire(player_objects[2], "down", _vertical_autofire_rate) then
            if is_main_menu_selected then
              is_main_menu_selected = false
              sub_menu_selected_index = 0
              _sub_menu_down()
            elseif _current_entry.down and _current_entry:down() then
              save_training_data()
            elseif current_popup then
              current_popup.selected_index = current_popup.selected_index + 1
              if current_popup.selected_index > #current_popup.entries then
                current_popup.selected_index = 1
              end
            else
              _sub_menu_down()
            end
          end
      
          if check_input_down_autofire(player_objects[1], "up", _vertical_autofire_rate) or check_input_down_autofire(player_objects[2], "up", _vertical_autofire_rate) then
            if is_main_menu_selected then
              is_main_menu_selected = false
              sub_menu_selected_index = #menu[main_menu_selected_index].entries + 1
              _sub_menu_up()
            elseif _current_entry.up and _current_entry:up() then
                save_training_data()
            elseif current_popup then
              current_popup.selected_index = current_popup.selected_index - 1
              if current_popup.selected_index == 0 then
                current_popup.selected_index = #current_popup.entries
              end
            else
              _sub_menu_up()
            end
          end
      
          if check_input_down_autofire(player_objects[1], "left", _horizontal_autofire_rate) or check_input_down_autofire(player_objects[2], "left", _horizontal_autofire_rate) then
            if is_main_menu_selected then
              main_menu_selected_index = main_menu_selected_index - 1
              if main_menu_selected_index == 0 then
                main_menu_selected_index = #menu
              end
            elseif _current_entry.left then
              _current_entry:left()
              save_training_data()
            end
          end
      
          if check_input_down_autofire(player_objects[1], "right", _horizontal_autofire_rate) or check_input_down_autofire(player_objects[2], "right", _horizontal_autofire_rate) then
            if is_main_menu_selected then
              main_menu_selected_index = main_menu_selected_index + 1
              if main_menu_selected_index > #menu then
                main_menu_selected_index = 1
              end
            elseif _current_entry.right then
              _current_entry:right()
              save_training_data()
            end
          end
      
          if P1.input.pressed.LP or P2.input.pressed.LP then
            if is_main_menu_selected then
            elseif _current_entry.validate then
              _current_entry:validate()
              save_training_data()
            end
          end
      
          if P1.input.pressed.MP or P2.input.pressed.MP then
            if is_main_menu_selected then
            elseif _current_entry.reset then
              _current_entry:reset()
              save_training_data()
            end
          end
      
          if P1.input.pressed.LK or P2.input.pressed.LK then
            if is_main_menu_selected then
            elseif _current_entry.cancel then
              _current_entry:cancel()
              save_training_data()
            end
          end
      
          -- screen size 383,223
          local _gui_box_bg_color = 0x293139FF
          local _gui_box_outline_color = 0x840000FF
          local _menu_box_left = 23
          local _menu_box_top = 15
          local _menu_box_right = 360
          local _menu_box_bottom = 195
          gui.box(_menu_box_left, _menu_box_top, _menu_box_right, _menu_box_bottom, _gui_box_bg_color, _gui_box_outline_color)
      
          local _bar_x = _menu_box_left + 10
          local _bar_y = _menu_box_top + 6
          local _base_offset = 0
          for i = 1, #menu do
            local _offset = 0
            local _c = text_disabled_color
            local _t = menu[i].name
            if is_main_menu_selected and i == main_menu_selected_index then
              _t = "< ".._t.." >"
              _c = text_selected_color
            elseif i == main_menu_selected_index then
              _c = text_default_color
              _offset = 8
            else
              _offset = 8
            end
            gui.text(_bar_x + _offset + _base_offset, _bar_y, _t, _c, text_default_border_color)
            _base_offset = _base_offset + (#menu[i].name + 5) * 4
          end
      
      
          local _menu_x = _menu_box_left + 10
          local _menu_y = _menu_box_top + 23
          local _menu_y_interval = 10
          local _menu_x_interval = 10
          local _menu_y_second_column = false
          local _draw_index = 0
          for i = 1, #menu[main_menu_selected_index].entries do            
            if menu[main_menu_selected_index].entries[i].is_disabled == nil or not menu[main_menu_selected_index].entries[i].is_disabled() then
              if _draw_index > 10 then _menu_x_interval = 150 else _menu_x_interval = 0 end
              if _draw_index > 10 then _menu_y_second_column = true else _menu_y_second_column = false end
              if not _menu_y_second_column then 
                menu[main_menu_selected_index].entries[i]:draw(_menu_x + _menu_x_interval, _menu_y + _menu_y_interval * _draw_index, not is_main_menu_selected and not current_popup and sub_menu_selected_index == i)
              else 
                menu[main_menu_selected_index].entries[i]:draw(_menu_x + _menu_x_interval, (_menu_y - 110) + _menu_y_interval * _draw_index, not is_main_menu_selected and not current_popup and sub_menu_selected_index == i)
              end 
              _draw_index = _draw_index + 1
            end
          end
      
          -- recording slots special display
          -- if main_menu_selected_index == 3 then
          --   local _t = string.format("%d frames", #recording_slots[training_settings.current_recording_slot].inputs)
          --   gui.text(_menu_box_left + 83, _menu_y + 2 * _menu_y_interval, _t, text_disabled_color, text_default_border_color)
          -- end
      
          if not is_main_menu_selected then
            if menu[main_menu_selected_index].entries[sub_menu_selected_index].legend then
              gui.text(_menu_x, _menu_box_bottom - 12, menu[main_menu_selected_index].entries[sub_menu_selected_index]:legend(), text_disabled_color, text_default_border_color)
            end
            if menu[main_menu_selected_index].entries[sub_menu_selected_index].description then
              local description = menu[main_menu_selected_index].entries[sub_menu_selected_index]:description()
              gui.text(_menu_x, _menu_box_bottom - 45, description, text_disabled_color, text_default_border_color)
            end
          end
      
          -- popup
          if current_popup then
            gui.box(current_popup.left, current_popup.top, current_popup.right, current_popup.bottom, _gui_box_bg_color, _gui_box_outline_color)
      
            _menu_x = current_popup.left + 10
            _menu_y = current_popup.top + 9
            _draw_index = 0
      
            for i = 1, #current_popup.entries do
              if current_popup.entries[i].is_disabled == nil or not current_popup.entries[i].is_disabled() then
                current_popup.entries[i]:draw(_menu_x, _menu_y + _menu_y_interval * _draw_index, current_popup.selected_index == i)
                _draw_index = _draw_index + 1
              end
            end
      
            if current_popup.entries[current_popup.selected_index].legend then
              gui.text(_menu_x, current_popup.bottom - 12, current_popup.entries[current_popup.selected_index]:legend(), text_disabled_color, text_default_border_color)
            end
          end
      
        else
          gui.box(0,0,0,0,0,0) -- if we don't draw something, what we drawed from last frame won't be cleared
        end
    end
}

return menuModule