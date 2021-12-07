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
    elseif char_id == 0x0B 	then return "Zabel"
    elseif char_id == 0x0C 	then return "Q-Bee"
    elseif char_id == 0x0D 	then return "Lei-Lei"
    elseif char_id == 0x0E 	then return "Lilith"
    elseif char_id == 0x0F 	then return "Jedah"
    elseif char_id == 0x12 	then return "Dark Gallon"
    elseif char_id == 0x18 	then return "Oboro" end
end

function get_moves_Morrigan()
    -- PL1 (MO) FF8506
    -- 00 = Finishing Shower
    -- 02 = Shadow Blade
    -- 04 = Soul Fist
    -- 06 = Air Soul Fist
    -- 08 = Darkness Illusion
    -- 0A = Cryptic Needle
    -- 0C = Valkyrie Turn
    -- 0E = Vector Drain
    -- 10 = Pursuit
    -- 12 = Taunt
    -- 14 = Incomplete Animation - Invincible
    return {
        {value = 0x00, name = "Finishing Shower",   conditions = {}, isReversalMove = true  , isEX = true},
        {value = 0x02, name = "Shadow Blade",       conditions = {}, isReversalMove = true  },
        {value = 0x04, name = "Soul Fist",          conditions = {}, isReversalMove = true  },
        {value = 0x06, name = "Air Soul Fist",      conditions = {}, isReversalMove = false },
        {value = 0x08, name = "Darkness Illusion",  conditions = {}, isReversalMove = true  , isEX = true},
        {value = 0x0A, name = "Cryptic Needle",     conditions = {}, isReversalMove = true  , isEX = true},
        {value = 0x0C, name = "Valkyrie Turn",      conditions = {}, isReversalMove = true  , isEX = true},
        {value = 0x0E, name = "Vector Drain",       conditions = {}, isReversalMove = true  },
        {value = 0x10, name = "Pursuit",            conditions = {}, isReversalMove = false },
        {value = 0x12, name = "Taunt",              conditions = {}, isReversalMove = true },
        -- {value = 0x14, name = "Incomplete Animation - Invincible"},
    }
end
function get_moves_Demitri()
    -- PL1 (DE) FF8506
    -- 00 = Ground Chaos Flare
    -- 02 = Air Chaos Flare
    -- 04 = Demon Cradle
    -- 06 = Dash DP
    -- 08 = Negative Stolen
    -- 0A = Pursuit
    -- 0C = Bat Spin
    -- 0E = Demon Billion
    -- 10 = Midnight Bliss
    -- 12 = Taunt
    -- 14 = Midnight Pleasure
    -- 16 = Crash
    return {
        {value = 0x00, name = "Ground Chaos Flare", conditions = {}, isReversalMove = true  },
        {value = 0x02, name = "Air Chaos Flare",    conditions = {}, isReversalMove = false },
        {value = 0x04, name = "Demon Cradle",       conditions = {}, isReversalMove = true  },
        {value = 0x06, name = "Dash DP",            conditions = {}, isReversalMove = true  },
        {value = 0x08, name = "Negative Stolen",    conditions = {}, isReversalMove = true  },
        {value = 0x0A, name = "Pursuit",            conditions = {}, isReversalMove = false },
        {value = 0x0C, name = "Bat Spin",           conditions = {}, isReversalMove = true  },
        {value = 0x0E, name = "Demon Billion",      conditions = {}, isReversalMove = true  , isEX = true  },
        {value = 0x10, name = "Midnight Bliss",     conditions = {}, isReversalMove = true  , isEX = true  },
        {value = 0x12, name = "Taunt",              conditions = {}, isReversalMove = true  },
        {value = 0x14, name = "Midnight Pleasure",  conditions = {}, isReversalMove = true  , isEX = true  },
    }
end
function get_moves_Bulleta()
    -- 00 = High Missile
    -- 02 = Low Missile
    -- 04 = Molotov Cocktail
    -- 06 = Basket
    -- 08 = Apple 4 You
    -- 0A = Pursuit
    -- 0C = Vert Missile
    -- 0E = Beautiful Memory
    -- 10 = Sentimental Typhoon
    -- 12 = Guard Cancel
    -- 14 = Huntsman
    -- 16 = Tell Me Why
    -- 18 = Taunt
    -- 1A = Not Allocated - No crash
    -- 1C = Crash
    return {
        {value = 0x00, name = "High Missile",           conditions = {}, isReversalMove = true  },
        {value = 0x02, name = "Low Missile",            conditions = {}, isReversalMove = true  },
        {value = 0x04, name = "Molotov Cocktail",       conditions = {}, isReversalMove = true  },
        {value = 0x06, name = "Basket",                 conditions = {}, isReversalMove = true  },
        {value = 0x08, name = "Apple 4 You",            conditions = {}, isReversalMove = true  , isEX = true  },
        {value = 0x0A, name = "Pursuit",                conditions = {}, isReversalMove = false },
        {value = 0x0C, name = "Vert Missile",           conditions = {}, isReversalMove = true  },
        {value = 0x0E, name = "Beautiful Memory",       conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x10, name = "Sentimental Typhoon",    conditions = {}, isReversalMove = true  },
        {value = 0x12, name = "Guard Cancel",           conditions = {}, isReversalMove = true  },
        {value = 0x14, name = "Cool Hunting",           conditions = {}, isReversalMove = true  , isEX = true},
        {value = 0x16, name = "Tell Me Why",            conditions = {}, isReversalMove = true  },
        {value = 0x18, name = "Taunt",            conditions = {}, isReversalMove = true  },
    }
end
function get_moves_Gallon()
    -- PL1 (GA) FF8506
    -- 00 = Climb Razor
    -- 02 = Million Flicker
    -- 04 = Dragon Cannon
    -- 06 = Moment Slice
    -- 08 = Horiz. Beast.C
    -- 0A = Vert. Beast.C
    -- 0C = 3- Beast.C
    -- 0E = 8-Beast.C
    -- 10 = 2-Beast.C
    -- 12 = Pursuit
    -- 14 = Wild Circular
    -- 16 = Quick Move
    -- 18 = Taunt
    -- 1A = Unlisted - No Crash
    -- 1C = Crash
    return {
        {value = 0x00, name = "Climb Razor",        conditions = {}, isReversalMove = true  },
        {value = 0x02, name = "Million Flicker",    conditions = {}, isReversalMove = true  },
        {value = 0x04, name = "Dragon Cannon",      conditions = {}, isReversalMove = true  , isEX = true},
        {value = 0x06, name = "Moment Slice",       conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x08, name = "Horiz. Beast Cannon (qcf)",  conditions = {}, isReversalMove = true },
        {value = 0x0A, name = "Vert. Beast Cannon (dp)",    conditions = {}, isReversalMove = false },
        {value = 0x0C, name = "3-Beast Cannon",             conditions = {}, isReversalMove = false },
        {value = 0x0E, name = "8 Beast Cannon",     conditions = {}, isReversalMove = true  },
        {value = 0x10, name = "2 Beast Cannon",     conditions = {}, isReversalMove = false },
        {value = 0x12, name = "Pursuit",            conditions = {}, isReversalMove = false },
        {value = 0x14, name = "Wild Circular",      conditions = {}, isReversalMove = true  },
        {value = 0x16, name = "Quick Move",         conditions = {}, isReversalMove = true  },
        {value = 0x18, name = "Taunt",            conditions = {}, isReversalMove = true  },
    }
end
function get_moves_Victor()
    -- PL1 (VI) FF8506
    -- 00 = Gyro Crush
    -- 02 = Giga Burn
    -- 04 = Giga Hammer - !!Night Warriors!!
    -- 06 = Giga Buster - !!Night Warriors!!
    -- 08 = Pursuit
    -- 0A = Mega Shock
    -- 0C = Minimum Step
    -- 0E = 360
    -- 10 = Thunder Break
    -- 12 = Mega Forehead
    -- 14 = Mega Stake
    -- 16 = Taunt
    -- 18 = 720
    -- 1A = 720-Taunt
    -- 1C = Crash
    return {
        {value = 0x00, name = "Gyro Crush",                 conditions = {}, isReversalMove = true  },
        {value = 0x02, name = "Giga Burn ",                 conditions = {}, isReversalMove = true  },
        {value = 0x04, name = "Giga Hammer ~~Easter Egg~~", conditions = {}, isReversalMove = true  },
        {value = 0x06, name = "Giga Buster ~~Easter Egg~~", conditions = {}, isReversalMove = true  },
        {value = 0x08, name = "Pursuit",                    conditions = {}, isReversalMove = false },
        {value = 0x0A, name = "Mega Shock",                 conditions = {}, isReversalMove = true  },
        {value = 0x0C, name = "Minimum Step",               conditions = {}, isReversalMove = true  },
        {value = 0x0E, name = "Mega Spike",                 conditions = {}, isReversalMove = true  },
        {value = 0x10, name = "Thunder Break",              conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x12, name = "Mega Forehead",              conditions = {}, isReversalMove = true  },
        {value = 0x14, name = "Mega Stake",                 conditions = {}, isReversalMove = true  },
        {value = 0x16, name = "Taunt",                      conditions = {}, isReversalMove = true  },
        {value = 0x18, name = "Gerdenheim 3",               conditions = {}, isReversalMove = true  , isEX = true},
    }
end
function get_moves_Zabel()
    -- 00 = Skull Sting
    -- 02 = Air Death Hurricane
    -- 04 = Death Voltage
    -- 06 = Skull Punish
    -- 08 = Evil Scream
    -- 0A = Hell Dunk
    -- 0C = Hell Gate
    -- 0E = Pursuit
    -- 10 = Guard Cancel
    -- 12 = Taunt
    -- 14 = Incomplete no animation
    return {
        {value = 0x00, name = "Skull Sting",            conditions = {}, isReversalMove = true  },
        {value = 0x02, name = "Air Death Hurricane",    conditions = {}, isReversalMove = false },
        {value = 0x04, name = "Death Voltage",          conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x06, name = "Skull Punish",           conditions = {}, isReversalMove = true  },
        {value = 0x08, name = "Evil Scream",            conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x0A, name = "Hell Dunk",              conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x0C, name = "Hell Gate",              conditions = {}, isReversalMove = true  },
        {value = 0x0E, name = "Pursuit",                conditions = {}, isReversalMove = false },
        {value = 0x10, name = "Guard Cancel",           conditions = {}, isReversalMove = true  },
        {value = 0x12, name = "Taunt",                  conditions = {}, isReversalMove = true  },
    }
end
function get_moves_Anakaris()
    -- 00 = Coffin
    -- 02 = Spell of Turn - IN
    -- 04 = Spell of Turn - OUT
    -- 06 = Curse
    -- 08 = Cobra Blow
    -- 0A = Hands
    -- 0C = Float
    -- 0E = Pit to Underworld
    -- 10 = P.Magic
    -- 1E = P.Magic
    -- 12 = Pursuit
    -- 14 = P.Decoration
    -- 16 = Pit of Blame
    -- 18 = Guard Cancel
    -- 1A = Taunt
    -- 1C = P.Salvation
    return {
        {value = 0x00, name = "Coffin",             conditions = {}, isReversalMove = true },
        {value = 0x02, name = "Spell of Turn - IN", conditions = {}, isReversalMove = true },
        {value = 0x04, name = "Spell of Turn - OUT",conditions = {}, isReversalMove = true },
        {value = 0x06, name = "Curse",              conditions = {}, isReversalMove = true },
        {value = 0x08, name = "Cobra Blow",         conditions = {}, isReversalMove = true },
        {value = 0x0A, name = "Hands",              conditions = {}, isReversalMove = true },
        {value = 0x0C, name = "Float",              conditions = {}, isReversalMove = true },
        {value = 0x0E, name = "Pit to Underworld",  conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x10, name = "Pharoah Magic",      conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x1E, name = "Pharoah Magic",      conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x12, name = "Pursuit",            conditions = {}, isReversalMove = false },
        {value = 0x14, name = "Pharoah Decoration", conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x16, name = "Pit of Blame",       conditions = {}, isReversalMove = true  },
        {value = 0x18, name = "Guard Cancel",       conditions = {}, isReversalMove = false },
        {value = 0x1C, name = "Pit of Blame",       conditions = {}, isReversalMove = true  },
        {value = 0x1A, name = "Taunt",              conditions = {}, isReversalMove = true  },
        {value = 0x1C, name = "P. Salvation",       conditions = {}, isReversalMove = true  },
    }
end
function get_moves_Felicia()
    -- 00 = Taunt
    -- 02 = 22+KK
    -- 04 = Rolling Buckler
    -- 06 = Delta Kick
    -- 08 = Cat Spike
    -- 0A = Hell Cat
    -- 0C = Dancing Flash
    -- 0E = Please Help Me
    -- 10 = Head Ride
    -- 12 = Toy Touch
    -- 14 = Pursuit
    -- 16 = Command Taunt
    -- 18 = Delta Kick (Previously could have been Sand Scratch ???)
    return {
        {value = 0x00, name = "Taunt",              conditions = {}, isReversalMove = true  },
        {value = 0x02, name = "22+KK",              conditions = {}, isReversalMove = true  },
        {value = 0x04, name = "Rolling Buckler",    conditions = {}, isReversalMove = true  },
        {value = 0x06, name = "Delta Kick",         conditions = {}, isReversalMove = true  },
        {value = 0x08, name = "Cat Spike",          conditions = {}, isReversalMove = true  },
        {value = 0x0A, name = "Hell Cat",           conditions = {}, isReversalMove = true  },
        {value = 0x0C, name = "Dancing Flash",      conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x0E, name = "Please Help me",     conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x10, name = "Head Ride",          conditions = {}, isReversalMove = false },
        {value = 0x12, name = "Toy Touch",          conditions = {}, isReversalMove = false },
        {value = 0x14, name = "Pursuit",            conditions = {}, isReversalMove = false },
        {value = 0x16, name = "Command Taunt",      conditions = {}, isReversalMove = true  },
        -- {value = 0x18, name = "Delta Kick ?", conditions = {}, isReversalMove = false},
    }
end
function get_moves_Bishamon()
    -- 00 = Kienzan - Uppercut
    -- 02 = Iai Giri High
    -- 04 = Iai Giri Low
    -- 06 = Air K.D.
    -- 08 = K.D.
    -- 0A = Command Throw
    -- 0C = Oni Kubi
    -- 0E = Bricks
    -- 10 = Pursuit
    -- 12 = OTG Slap-Chop
    -- 14 = K.D. 4+P
    -- 16 = K.D. Hayate
    -- 18 = K.D. ES-Hayate
    -- 1A = Taunt
    -- 1C = Not allocated
    return {
        {value = 0x00, name = "Kienzan",        conditions = {}, isReversalMove = true  },
        {value = 0x02, name = "Iai Giri High",  conditions = {}, isReversalMove = true  },
        {value = 0x04, name = "Iai Giri Low",   conditions = {}, isReversalMove = true  },
        {value = 0x06, name = "Air K.D.",       conditions = {}, isReversalMove = false },
        {value = 0x08, name = "K.D.",           conditions = {}, isReversalMove = true  },
        {value = 0x0A, name = "Command Throw",  conditions = {}, isReversalMove = true  },
        {value = 0x0C, name = "Oni Kubi",       conditions = {}, isReversalMove = true  },
        {value = 0x0E, name = "Bricks",         conditions = {}, isReversalMove = true  , isEX = true},
        {value = 0x10, name = "Pursuit",        conditions = {}, isReversalMove = false },
        {value = 0x12, name = "OTG Slap Chop",  conditions = {}, isReversalMove = false , isEX = true},
        {value = 0x14, name = "K.D. 4+P",       conditions = {}, isReversalMove = false },
        {value = 0x16, name = "K.D. Hayate",    conditions = {}, isReversalMove = false },
        {value = 0x18, name = "K.D. ES-Hayate?",conditions = {}, isReversalMove = false },
        {value = 0x1A, name = "Taunt",          conditions = {}, isReversalMove = true  },

    }
end
function get_moves_Aulbath()
    -- PL1 (AU) 0xFF8506

    -- 00 = Sonic Wave
    -- 02 = Gas
    -- 04 = Aqua Spread
    -- 06 = Incomplete - Crash
    -- 08 = Sea Rage
    -- 0A = Water Jail
    -- 0C = Direct Scissors
    -- 0E = Gem's Anger
    -- 10 = Crystal Lancer
    -- 12 = Trick Fish
    -- 14 = Pursuit
    -- 16 = Incomplete - Backdash startup ?
    -- 18 = Taunt
    return {
        {value = 0x00, name = "Sonic Wave",     conditions = {}, isReversalMove = true },
        {value = 0x02, name = "Gas",            conditions = {}, isReversalMove = true },
        {value = 0x04, name = "Aqua Spread",    conditions = {}, isReversalMove = true  , isEX = true },
        -- {value = 0x06, name = "Incomplete - Crash", conditions = {}, isReversalMove = false },
        {value = 0x08, name = "Sea Rage",       conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x0A, name = "Water Jail",     conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x0C, name = "Direct Scissors",conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x0E, name = "Gem's Anger",    conditions = {}, isReversalMove = true },
        {value = 0x10, name = "Crystal Lancer", conditions = {}, isReversalMove = true },
        {value = 0x12, name = "Trick Fish",     conditions = {}, isReversalMove = true },
        {value = 0x14, name = "Pursuit",        conditions = {}, isReversalMove = true },
        -- {value = 0x16, name = "Incomplete", conditions = {}, isReversalMove = false},
        {value = 0x18, name = "Taunt",          conditions = {}, isReversalMove = true },
    }
end
function get_moves_Sasquatch()
--     PL1 (SA) 0xFF8506

--     00 = Big Breath
--     02 = Big Banana
--     04 = Big Blow
--     06 = Big Towers
--     08 = Big Typhoon
--     0A = Big Freezer
--     0C = Big Swing
--     0E = Big Sledge
--     10 = Big Brunch
--     12 = Big Eisbhan
--     14 = Pursuit
--     16 = Taunt
--     18 = Incomplete - Can Crash
    return {
        {value = 0x00, name = "Big Breath",     conditions = {}, isReversalMove = true  },
        {value = 0x02, name = "Big Banana",     conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x04, name = "Big Blow",       conditions = {}, isReversalMove = true  },
        {value = 0x06, name = "Big Towers",     conditions = {}, isReversalMove = true  },
        {value = 0x08, name = "Big Typhoon",    conditions = {}, isReversalMove = true  },
        {value = 0x0A, name = "Big Freezer",    conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x0C, name = "Big Swing",      conditions = {}, isReversalMove = true  },
        {value = 0x0E, name = "Big Sledge",     conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x10, name = "Big Brunch",     conditions = {}, isReversalMove = true  },
        {value = 0x12, name = "Big Eisban",     conditions = {}, isReversalMove = true  , isEX = true },
        {value = 0x14, name = "Pursuit",        conditions = {}, isReversalMove = false },
        {value = 0x16, name = "Taunt",          conditions = {}, isReversalMove = true  },
        -- {value = 0x18, name = "Incomplete", conditions = {}, isReversalMove = false},
    }
end
function get_moves_QBee()
    -- 00 = Delta-A
    -- 02 = SxP
    -- 04 = OM
    -- 06 = C>R
    -- 08 = Pursuit
    -- 0A = QJ
    -- 0C = +B
    -- 10 = Taunt
    -- 12 = R.M.
    -- 14 = Not allocated - Can crash
    return {
        {value = 0x00, name = "Delta-A",    conditions = {}, isReversalMove = true  },
        {value = 0x02, name = "SxP",        conditions = {}, isReversalMove = true  },
        {value = 0x04, name = "OM",         conditions = {}, isReversalMove = true  },
        {value = 0x06, name = "C>R",        conditions = {}, isReversalMove = true  },
        {value = 0x08, name = "Pursuit",    conditions = {}, isReversalMove = false },
        {value = 0x0A, name = "QJ",         conditions = {}, isReversalMove = true  , isEX = true},
        {value = 0x0C, name = "+B",         conditions = {}, isReversalMove = true  , isEX = true},
        {value = 0x10, name = "Taunt",      conditions = {}, isReversalMove = true  },
        {value = 0x12, name = "R.M.",       conditions = {}, isReversalMove = true  },
        -- {value = 0x14, name = "Pursuit", conditions = {}, isReversalMove = false},
    }
end
function get_moves_LeiLei()    
--     00 = Pursuit
--     02 = Ankihou
--     04 = Henkyouki
--     06 = Senpuubu
--     08 = Houtengeki
--     0A = Chireitou
--     0C = Tenraiha
--     0E = Chuukadan
--     10 = Taunt
--     12 = Not allocated - can crash
    return {
        {value = 0x00, name = "Pursuit",    conditions = {}, isReversalMove = true },
        {value = 0x02, name = "Ankihou",    conditions = {}, isReversalMove = true },
        {value = 0x04, name = "Henkyouki",  conditions = {}, isReversalMove = true },
        {value = 0x06, name = "Senpuubu",   conditions = {}, isReversalMove = true },
        {value = 0x08, name = "Houtengeki", conditions = {}, isReversalMove = true },
        {value = 0x0A, name = "Chireitou",  conditions = {}, isReversalMove = true , isEX = true },
        {value = 0x0C, name = "Tenraiha",   conditions = {}, isReversalMove = true , isEX = true },
        {value = 0x0E, name = "Chuukadan",  conditions = {}, isReversalMove = true , isEX = true },
        {value = 0x10, name = "Taunt",      conditions = {}, isReversalMove = true },
    }
end
function get_moves_Lilith()
    -- 00 = Shining Blade
    -- 02 = Soul Flash
    -- 04 = Air Soul Flash
    -- 06 = Merry Twirl
    -- 08 = Splendor Love
    -- 0A = Super Jump
    -- 0C = Mystic Arrow
    -- 0E = Soul Flash (Lower) ?
    -- 10 = Air Soul Flash (Lower) ?
    -- 12 = Pursuit
    -- 14 = Taunt
    -- 16 = Puppet Show
    -- 18 = LI
    -- 1A = Not allocated - can crash
    return {
        {value = 0x00, name = "Shining Blade",  conditions = {}, isReversalMove = true  },
        {value = 0x02, name = "Soul Flash",     conditions = {}, isReversalMove = true  },
        {value = 0x04, name = "Air Soul Flash", conditions = {}, isReversalMove = false },
        {value = 0x06, name = "Merry Twirl",    conditions = {}, isReversalMove = true  },
        {value = 0x08, name = "Splendor Love",  conditions = {}, isReversalMove = true  , isEX = true},
        {value = 0x0A, name = "Super Jump",     conditions = {}, isReversalMove = true  },
        {value = 0x0C, name = "Mystic Arrow",   conditions = {}, isReversalMove = true  },
        -- {value = 0x0E, name = "Soul Flash (Lower?)", conditions = {}, isReversalMove = true },
        -- {value = 0x10, name = "Air Soul Flash (Lower?)", conditions = {}, isReversalMove = true },
        {value = 0x12, name = "Pursuit",        conditions = {}, isReversalMove = false },
        {value = 0x14, name = "Taunt",          conditions = {}, isReversalMove = true  },
        {value = 0x16, name = "Puppet Show",    conditions = {}, isReversalMove = true  , isEX = true},
        {value = 0x18, name = "LI",             conditions = {}, isReversalMove = true  , isEX = true},
    }
end
function get_moves_Jedah()
    -- 00 = Dio Sega
    -- 02 = Air Dio Sega
    -- 04 = Splecio - Guard Cancel
    -- 06 = Finale Rosso
    -- 08 = Prova di Servo
    -- 0A = Ira Spinta
    -- 0C = Nero fatica
    -- 0E = Pursuit
    -- 10 = San Bassale
    -- 12 = Taunt
    -- 14 = Unknown fly state - Weird
    return {
        {value = 0x00, name = "Dio Sega",       conditions = {}, isReversalMove = true  },
        {value = 0x02, name = "Air Dio Sega",   conditions = {}, isReversalMove = false },
        {value = 0x04, name = "Guard Cancel",   conditions = {}, isReversalMove = false },
        {value = 0x06, name = "Finale Rosso",   conditions = {}, isReversalMove = true  , isEX = true  },
        {value = 0x08, name = "Prova di servo", conditions = {}, isReversalMove = true  , isEX = true  },
        {value = 0x0A, name = "Ira Spinta",     conditions = {}, isReversalMove = true  },
        {value = 0x0C, name = "Nero Fatica",    conditions = {}, isReversalMove = true  },
        {value = 0x0E, name = "Pursuit",        conditions = {}, isReversalMove = false },
        {value = 0x10, name = "San Bassale",    conditions = {}, isReversalMove = true  },
        {value = 0x12, name = "Taunt",          conditions = {}, isReversalMove = true },
        -- {value = 0x14, name = "Unknown Fly State", conditions = {}, isReversalMove = true},
    }
end

local moves_lookup = {
    ["Morrigan"]  = get_moves_Morrigan(),   -- https://twitter.com/VMP_KyleW/status/1062578209777082368
    ["Bulleta"]   = get_moves_Bulleta(),	-- https://twitter.com/VMP_KyleW/status/1062246488745500672
    ["Demitri"]   = get_moves_Demitri(),	-- https://twitter.com/VMP_KyleW/status/1062247999198261248
    ["Gallon"]    = get_moves_Gallon(),	    -- https://twitter.com/VMP_KyleW/status/1062251253487398912
    ["Victor"]    = get_moves_Victor(),	    -- https://twitter.com/VMP_KyleW/status/1062255444066881536
    ["Zabel"]     = get_moves_Zabel(),      -- https://twitter.com/VMP_KyleW/status/1062575688199229440
    ["Anakaris"]  = get_moves_Anakaris(),	-- https://twitter.com/VMP_KyleW/status/1062584507331559424
    ["Felicia"]   = get_moves_Felicia(),	-- https://twitter.com/VMP_KyleW/status/1062587739080613889
    ["Bishamon"]  = get_moves_Bishamon(), 	-- https://twitter.com/VMP_KyleW/status/1062592100498198529
    ["Aulbath"]   = get_moves_Aulbath(),	-- https://twitter.com/VMP_KyleW/status/1062595023688986625
    ["Sasquatch"] = get_moves_Sasquatch(), 	-- https://twitter.com/VMP_KyleW/status/1062975241603866624
    ["Q-Bee"]     = get_moves_QBee(),	    -- https://twitter.com/VMP_KyleW/status/1062980478993485825
    ["Lei-Lei"]   = get_moves_LeiLei(),     -- https://twitter.com/VMP_KyleW/status/1062983116220813312
    ["Lilith"]    = get_moves_Lilith(),     -- https://twitter.com/VMP_KyleW/status/1062986908777689088
    ["Jedah"]     = get_moves_Jedah(),      -- https://twitter.com/VMP_KyleW/status/1063252518686253056
-- ["Oboro"]     = get_moves_Morrigan()	    -- https://twitter.com/VMP_KyleW/status/1063641654622441474
-- ["Hyper Zabel"] = get_moves_Morrigan()   -- https://twitter.com/VMP_KyleW/status/1062978029595455489
    ["Dark Gallon"] 	= get_moves_Gallon()  -- https://twitter.com/VMP_KyleW/status/1062251253487398912
} 
local function get_player_moves(base_addr)
    local char_name = get_character(base_addr)
    return moves_lookup[char_name]
end

local function get_reversal_moves(all_moves)
    local reversals = {}

    for k, v in pairs(all_moves) do
        if v["isReversalMove"] == true then
            table.insert(reversals, v)
        end
    end

    return reversals
end
local function get_reversal_moves_names( reversal_moves )
    local names = {}

    for k, v in pairs(reversal_moves) do
        table.insert(names, v["name"])
    end
    return names
end
local function get_moves_obj()
    local p1_all_moves = get_player_moves(0xFF8400)
    local p2_all_moves = get_player_moves(0xFF8800)

    local p1_reversal_moves = get_reversal_moves(p1_all_moves)
    local p2_reversal_moves = get_reversal_moves(p2_all_moves)

    local p1_reversal_moves_names = get_reversal_moves_names(p1_reversal_moves)
    local p2_reversal_moves_names = get_reversal_moves_names(p2_reversal_moves)

    return {
        P1 = {
            all             = p1_all_moves,
            reversals       = p1_reversal_moves,
            reversal_names  = p1_reversal_moves_names,
        },
        P2 = {
            all             = p2_all_moves,
            reversals       = p2_reversal_moves,
            reversal_names  = p2_reversal_moves_names,

        },
    }
end
charMovesModule = {
    ["get_player_movelists"] = function()
        return get_moves_obj()
    end,
    ["registerBefore"] = function(run_dummy_input, macroLua_funcs)
        return get_moves_obj()
    end
}
return charMovesModule