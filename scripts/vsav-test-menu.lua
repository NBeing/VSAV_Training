-- this module contains and exposes functionality that is in the test menu
-- to the in-game training mode menu
TEST_MENU_BASE_ADDR      = 0xFF8000
Y_FLIP_OFFSET            = 0x96
COIN_MODE_OFFSET         = 0x97
ENABLE_CONTINUES_OFFSET  = 0x98
ENABLE_DEMO_SOUND_OFFSET = 0x99
SOUND_STEREO_MONO_OFFSET = 0x9A
DIFFICULTY_OFFSET        = 0xA0
DAMAGE_LEVEL_OFFSET      = 0xA1
TIMER_SPEED_OFFSET       = 0xA2
GAME_SPEED_MENU_OFFSET   = 0xA3
FRAMESKIP_OFFSET         = 0x116
BATS_PER_GAME_OFFSET     = 0xA4
EVENT_MODE_OFFSET        = 0xA5
AUTO_GUARD_SELECT_OFFSET = 0xBB

local current_speed = nil

local function get_frameskip_value(game_speed)
	if game_speed == 3 then return 0x08
	elseif game_speed == 2 then return 0x07
	elseif game_speed == 1 then return 0x06
	else return 0x00
	end
end

-- TODO: find and hook function that updates test menu config, then overwrite
-- what's in the globals.options with what is selected? if possible, so that
-- making a new selection in the actual game test menu isn't overridden by this
-- functionality literally all the time
local function set_game_speed(game_speed)
	local frameskip_addr = TEST_MENU_BASE_ADDR + FRAMESKIP_OFFSET
	local game_speed_menu_addr = TEST_MENU_BASE_ADDR + GAME_SPEED_MENU_OFFSET
	memory.writebyte(frameskip_addr, get_frameskip_value(game_speed))
	memory.writebyte(game_speed_menu_addr, game_speed)
	current_speed = game_speed
end

vsavTestMenuModule = {
	["registerBefore"] = function(game_speed)
		if current_speed ~= game_speed then
			set_game_speed(game_speed)
		end
	end
}
return vsavTestMenuModule
