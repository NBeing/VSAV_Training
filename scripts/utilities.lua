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

utilitiesModule = {
    ["do_tables_match"] = do_tables_match,
    ["to_hex"] = to_hex
}
return utilitiesModule