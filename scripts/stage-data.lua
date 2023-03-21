STAGE_WRITE_FUNC_ADDR = 0xAEFA
CURRENT_STAGE_ADDR    = 0xFF8101

STAGE_VALUES = {
	FeastOfTheDamned    = 0x00,
	ConcreteCave        = 0x02,
	TowerOfArrogance    = 0x04,
	RedThirst           = 0x06,
	DesertedChateau     = 0x08,
	Abaraya             = 0x0A,
	VanityParadise      = 0x0C,
	WarAgony            = 0x0E,
	ForeverTorment      = 0x10,
	GreenScream         = 0x12,
	IronHorseIronTerror = 0x14,
	FetusOfGod          = 0x16
}

local function get_stage_name(stage_value)
	if     stage_value == STAGE_VALUES["FeastOfTheDamned"]    then return "Feast of the Damned"
	elseif stage_value == STAGE_VALUES["ConcreteCave"]        then return "Concrete Cave"
	elseif stage_value == STAGE_VALUES["TowerOfArrogance"]    then return "Tower of Arrogance"
	elseif stage_value == STAGE_VALUES["RedThirst"]           then return "Red Thirst"
	elseif stage_value == STAGE_VALUES["DesertedChateau"]     then return "Deserted Chateau"
	elseif stage_value == STAGE_VALUES["Abaraya"]             then return "Abaraya"
	elseif stage_value == STAGE_VALUES["VanityParadise"]      then return "Vanity Paradise"
	elseif stage_value == STAGE_VALUES["WarAgony"]            then return "War Agony"
	elseif stage_value == STAGE_VALUES["ForeverTorment"]      then return "Forever Torment"
	elseif stage_value == STAGE_VALUES["GreenScream"]         then return "Green Scream"
	elseif stage_value == STAGE_VALUES["IronHorseIronTerror"] then return "Iron Horse Iron Terror"
	elseif stage_value == STAGE_VALUES["FetusOfGod"]          then return "Fetus of God"
	else                                                           return "Feast of the Damned"
	end
end

local function get_current_stage()
	return get_stage_name(memory.readbyte(CURRENT_STAGE_ADDR))
end

stagesModule = {
	["get_stage_name"] = get_stage_name,
	["get_current_stage"] = get_current_stage,
	["CURRENT_STAGE_ADDR"] = CURRENT_STAGE_ADDR,
	["STAGE_WRITE_FUNC_ADDR"] = STAGE_WRITE_FUNC_ADDR,
	["STAGE_VALUES"] = STAGE_VALUES
}
return stagesModule