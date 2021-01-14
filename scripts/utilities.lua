local json              = require './scripts/dkjson'

function swap_inputs(keys)
	newKeys = {}

	p1_pattern = "^P1"
	for k, v in pairs(keys) do
		if k:find(p1_pattern) ~= nil then
			old_k = k
			swapped_k = k:gsub("1","2")
			-- print("after", old_k, swapped_k)
			newKeys[swapped_k] = keys[old_k] 
		end
	end
	p1_pattern = "^P2"
	for k, v in pairs(keys) do
		if k:find(p1_pattern) ~= nil then
			old_k = k
			swapped_k = k:gsub("2","1")
			-- print("after", old_k, swapped_k)
			newKeys[swapped_k] = keys[old_k] 
		end
	end
	return newKeys
end


function do_tables_match (o1, o2, ignore_mt)
    if o1 == o2 then return true end
    local o1Type = type(o1)
    local o2Type = type(o2)
    if o1Type ~= o2Type then return false end
    if o1Type ~= 'table' then return false end

    if not ignore_mt then
        local mt1 = getmetatable(o1)
        if mt1 and mt1.__eq then
            --compare using built in method
            return o1 == o2
        end
    end

    local keySet = {}

    for key1, value1 in pairs(o1) do
        local value2 = o2[key1]
        if value2 == nil or do_tables_match(value1, value2, ignore_mt) == false then
            return false
        end
        keySet[key1] = true
    end

    for key2, _ in pairs(o2) do
        if not keySet[key2] then return false end
    end
    return true
end

function to_hex(num)
    local charset = {"0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"}
    local tmp = {}
    repeat
        table.insert(tmp,1,charset[num%16+1])
        num = math.floor(num/16)
    until num==0
    return table.concat(tmp)
end
-- History
function get_text_width(_text)
	if #_text == 0 then
	  return 0
	end
  
	return #_text * 4
  end
function string_hash(_str)
	if #_str == 0 then
		return 0
  end

  local _DJB2_INIT = 5381;
	local _hash = _DJB2_INIT
  for _i = 1, #_str do
    local _c = _str.byte(_i)
    _hash = bit.lshift(_hash, 5) + _hash + _c
  end
	return _hash
end
function string_to_color(_str)
	local _HRange = { 0.0, 360.0 }
	  local _SRange = { 0.8, 1.0 }
	  local _LRange = { 0.7, 1.0 }
  
	  local _HAmplitude = _HRange[2] - _HRange[1];
	  local _SAmplitude = _SRange[2] - _SRange[1];
	  local _LAmplitude = _LRange[2] - _LRange[1];
  
	local _hash = string_hash(_str)
  
	local _HI = bit.rshift(bit.band(_hash, 0xFF000000), 24)
	local _SI = bit.rshift(bit.band(_hash, 0x00FF0000), 16)
	  local _LI = bit.rshift(bit.band(_hash, 0x0000FF00), 8)
	  local _base = bit.lshift(1, 8)
  
	  local _H = _HRange[1] + (_HI / _base) * _HAmplitude;
	  local _S = _SRange[1] + (_SI / _base) * _SAmplitude;
	  local _L = _LRange[1] + (_LI / _base) * _LAmplitude;
  
	  local _HDiv60 = _H / 60.0
	  local _HDiv60_Floor = math.floor(_HDiv60);
	  local _HDiv60_Fraction = _HDiv60 - _HDiv60_Floor;
  
	  local _RGBValues = {
		  _L,
		  _L * (1.0 - _S),
		  _L * (1.0 - (_HDiv60_Fraction * _S)),
		  _L * (1.0 - ((1.0 - _HDiv60_Fraction) * _S))
	  }
  
	  local _RGBSwizzle = {
		  {1, 4, 2},
		  {3, 1, 2},
		  {2, 1, 4},
		  {2, 3, 1},
		  {4, 2, 1},
		  {1, 2, 3},
	  }
	  local _SwizzleIndex = (_HDiv60_Floor % 6) + 1
	local _R = _RGBValues[_RGBSwizzle[_SwizzleIndex][1]]
	local _G = _RGBValues[_RGBSwizzle[_SwizzleIndex][2]]
	local _B = _RGBValues[_RGBSwizzle[_SwizzleIndex][3]]
  
	--print(string.format("H:%.1f, S:%.1f, L:%.1f | R:%.1f, G:%.1f, B:%.1f", _H, _S, _L, _R, _G, _B))
  
	local _color = bit.lshift(math.floor(_R * 255), 24) + bit.lshift(math.floor(_G * 255), 16) + bit.lshift(math.floor(_B * 255), 8) + 0xFF
	return _color
  end
local last_frame_data = nil
function printRamAddresses(start_addr, end_addr)
	local current_frame_data = {}
	for i = start_addr, end_addr, 1 do 
		current_frame_data[to_hex(i)] = memory.readbyte(i)
	end
	diffs = {}
	if last_frame_data ~= nil then 
		for k,v in pairs(current_frame_data) do
			if last_frame_data[k] ~= current_frame_data[k] then 
				diffs[k] = v
			end
		end
		print("\t",last_frame_data["frame"], "\t", emu.framecount())
		
	end
	for k,v in pairs(diffs) do
		print(k,"\t", v,"\t", last_frame_data[k], "\n")
	end

	last_frame_data = current_frame_data
	last_frame_data["frame"] = emu.framecount()
end
function read_object_from_json_file(_file_path)
	local _f = io.open(_file_path, "r")
	if _f == nil then
	  return nil
	end
  
	local _object
	local _pos, _err
	_object, _pos, _err = json.decode(_f:read("*all"))
	_f:close()
  
	if (err) then
	  print(string.format("Failed to find json file \"%s\" : %s", _file_path, _err))
	end
  
	return _object
  end
  
  function write_object_to_json_file(_object, _file_path)
	local _f = io.open(_file_path, "w")
	if _f == nil then
	  return false
	end
  
	local _str = json.encode(_object, { indent = true })
	_f:write(_str)
	_f:close()
  
	return true
end
function save_training_data()
	-- backup_recordings()
	if not write_object_to_json_file(training_settings, training_settings_file) then
		print(string.format("Error: Failed to save training settings to \"%s\"", training_settings_file))
	end

	globals.dummy = globals.dummy.refresh_dummy()
end
function load_training_data()
	local _training_settings = read_object_from_json_file(training_settings_file)
	if _training_settings == nil then
		_training_settings = {}
	end
	-- update old versions data
	-- if _training_settings.recordings then
	--   for _key, _value in pairs(_training_settings.recordings) do
	-- 	for _i, _slot in ipairs(_value) do
	-- 	  if _value[_i].inputs == nil then
	-- 		_value[_i] = make_recording_slot()
	-- 	  else
	-- 		_slot.delay = _slot.delay or 0
	-- 		_slot.random_deviation = _slot.random_deviation or 0
	-- 	  end
	-- 	end
	--   end
	-- end
	for _key, _value in pairs(_training_settings) do
		training_settings[_key] = _value
	end
	-- restore_recordings()
end
function disable_taunts()
		-- Set remaining taunts to 0 for better start button behavior
		memory.writebyte(0xFF8400 + 0x179, 0)
		memory.writebyte(0xFF8800 + 0x179, 0)
end
local function mergeTables(first_table, second_table)
	if first_table == nil or second_table == nil then
		return {}
	end
	for k,v in pairs(second_table) do first_table[k] = v end
end

function lookForValue(start_addr, end_addr, player)
	for i = start_addr, end_addr, 1 do 
		val = memory.readbyte(i)
		-- if val == 12 then print("found 12", to_hex(i), val) end
		if val == 11 then print(player.."==== found 11", to_hex(i), val) end
	end
end
function to_hex(num)
	local charset = {"0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"}
	local tmp = {}
	repeat
		table.insert(tmp,1,charset[num%16+1])
		num = math.floor(num/16)
	until num==0
	return table.concat(tmp)
end
function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end
local function get_character(base_addr)
    local char_id = memory.readbyte(base_addr + 0x382)
    if     char_id == 0x00  then return "Bulleta"
    elseif char_id == 0x01 	then return "Demitri"
    elseif char_id == 0x02 	then return "Gallon"
    elseif char_id == 0x03 	then return "Victor"
    elseif char_id == 0x04 	then return "Zabel"
    elseif char_id == 0x05 	then return "Morrigan"
    elseif char_id == 0x06 	then return "Anakaris"
    elseif char_id == 0x07 	then return "Felicia"
    elseif char_id == 0x08 	then return "Bishamon"
    elseif char_id == 0x09 	then return "Aulbath"
    elseif char_id == 0x0A 	then return "Sasquatch"
    elseif char_id == 0x0B 	then return "Random Select"
    elseif char_id == 0x0C 	then return "Q-Bee"
    elseif char_id == 0x0D 	then return "Lei-Lei"
    elseif char_id == 0x0E 	then return "Lilith"
    elseif char_id == 0x0F 	then return "Jedah"
    elseif char_id == 0x12 	then return "Dark Gallon"
    elseif char_id == 0x18 	then return "Oboro" end
end
utilitiesModule = {
    ["save_training_data"]         = save_training_data,
    ["load_training_data"]         = load_training_data,
    ["do_tables_match"]            = do_tables_match,
    ["to_hex"]                     = to_hex,
    ["read_object_from_json_file"] = read_object_from_json_file,
	["write_object_to_json_file"]  = write_object_to_json_file,
	["string_to_color"]			   =  string_to_color,
	["tablelength"]                = tablelength,
	["get_character"]			   = get_character,
	["registerStart"]              = function()
		return {
			printRamAddresses = printRamAddresses,
			disable_taunts = disable_taunts,
		}
	end
}
return utilitiesModule