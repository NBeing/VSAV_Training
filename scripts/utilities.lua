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

	globals.dummy.setNextGCValue(training_settings["gc_freq"])
	globals.dummy.setNextGCDelay(training_settings["gc_delay"])

	globals.dummy.setNextUpbackValue(training_settings["upback_freq"])

	globals.dummy.setNextGCSeed(nil)
	globals.dummy.setNextUpbackSeed(nil)

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
  
utilitiesModule = {
    ["save_training_data"]         = save_training_data,
    ["load_training_data"]         = load_training_data,
    ["do_tables_match"]            = do_tables_match,
    ["to_hex"]                     = to_hex,
    ["read_object_from_json_file"] = read_object_from_json_file,
    ["write_object_to_json_file"]  = write_object_to_json_file
}
return utilitiesModule