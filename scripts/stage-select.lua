stageData = require "./scripts/stage-data"

-- might be appropriate to move functionality related to char select to a
-- dedicated char select module someday

P1_CHAR_SEL_CURS_ADDR = 0xFF8403

CHAR_IDS = {
  Bulleta   = 0x00,
  Demitri   = 0x01,
  Gallon    = 0x02,
  Victor    = 0x03,
  Zabel     = 0x04,
  Morrigan  = 0x05,
  Anakaris  = 0x06,
  Felicia   = 0x07,
  Bishamon  = 0x08,
  Aulbath   = 0x09,
  Sasquatch = 0x0A,
  QBee      = 0x0C,
  LeiLei    = 0x0D,
  Lilith    = 0x0E,
  Jedah     = 0x0F
}

local function resolve_char_id_to_stage_value(char_id)
  if     char_id == CHAR_IDS["Bulleta"]   then return stageData["STAGE_VALUES"].WarAgony
  elseif char_id == CHAR_IDS["Demitri"]   then return stageData["STAGE_VALUES"].FeastOfTheDamned
  elseif char_id == CHAR_IDS["Gallon"] 	  then return stageData["STAGE_VALUES"].ConcreteCave
  elseif char_id == CHAR_IDS["Victor"] 	  then return stageData["STAGE_VALUES"].ForeverTorment
  elseif char_id == CHAR_IDS["Zabel"]     then return stageData["STAGE_VALUES"].IronHorseIronTerror
  elseif char_id == CHAR_IDS["Morrigan"] 	then return stageData["STAGE_VALUES"].DesertedChateau
  elseif char_id == CHAR_IDS["Anakaris"] 	then return stageData["STAGE_VALUES"].RedThirst
  elseif char_id == CHAR_IDS["Felicia"]   then return stageData["STAGE_VALUES"].TowerOfArrogance
  elseif char_id == CHAR_IDS["Bishamon"]  then return stageData["STAGE_VALUES"].Abaraya
  elseif char_id == CHAR_IDS["Aulbath"]   then return stageData["STAGE_VALUES"].GreenScream
  elseif char_id == CHAR_IDS["Sasquatch"]	then return stageData["STAGE_VALUES"].ForeverTorment
  elseif char_id == CHAR_IDS["QBee"]      then return stageData["STAGE_VALUES"].VanityParadise
  elseif char_id == CHAR_IDS["LeiLei"]    then return stageData["STAGE_VALUES"].VanityParadise
  elseif char_id == CHAR_IDS["Lilith"]    then return stageData["STAGE_VALUES"].DesertedChateau
  elseif char_id == CHAR_IDS["Jedah"]     then return stageData["STAGE_VALUES"].FetusOfGod
  else                                         return nil
  end
end

local function override_stage_write()
  if globals.desired_stage ~= nil then
    memory.writebyte(stageData["CURRENT_STAGE_ADDR"], globals.desired_stage)
  end
end

local function registerStart()
  memory.registerexec(stageData["STAGE_WRITE_FUNC_ADDR"], override_stage_write)
end

local last_inputs = nil
local function registerAfter()
  local inputs = joypad.getup()
  if last_inputs ~= nil and inputs["P1 Coin"] == nil and last_inputs["P1 Coin"] == false then
    globals.desired_stage = resolve_char_id_to_stage_value(memory.readbyte(P1_CHAR_SEL_CURS_ADDR))
  end
  last_inputs = inputs
end

stageSelectModule = {
  ["registerStart"] = registerStart,
  ["registerAfter"] = registerAfter
}
return stageSelectModule