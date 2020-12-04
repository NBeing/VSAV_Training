
-- print("WARNING! Set game to 'NORMAL' speed or you will get back incorrect frame data!")
-- print("This is due to inherent frameskip")
-- print("> 'startup' is the period before the 1st active frame")
-- print("> hitfreeze '*' means the attacker did not get frozen")

local print_header = function()
	print("startup\tatkrecov.\thitstun\tfr.adv.\thitfreeze")
end

local print_results = function(c)
	print(string.format("%d\t%d\t%d\t%+d\t%d%s\t%s", 
		c.startup, c.atkrecov, c.hitstun, c.advantage, c.hitfreeze, c.non_projectile, c.freeze_details))
end

local profile = {
	{
		games = {"vsav","vhunt2","vsav2"},
		address = {0xFF8400, 0xFF8800},
		attacking = function(addr) return memory.readbyte(addr + 0x105) == 0x01 end,
		supering  = function(addr) return memory.readbyte(addr + 0x006) == 0x12 end,
		hurt      = function(addr) return memory.readbyte(addr + 0x005) == 0x02 end,
		thrown    = function(addr) return memory.readbyte(addr + 0x005) == 0x06 end,
		hitfreeze = function(addr) return memory.readbyte(addr + 0x05C) ~= 0x00 end,
		delay = {startup = -1, atk_recover = 1, hit_recover = 1},
	}
}

for _, game in ipairs(profile) do
	game.update = game.update or {func = emu.registerafter, cycle = 1}
end

--------------------------------------------------------------------------------

local game, player_old, count, register_count, last_frame, dummy_recovered
local super_mode = false
local dummy_cooldown = 10
-- input.registerhotkey(1, function()
-- 	print()
-- end)

-- input.registerhotkey(2, function()
-- 	if not game.supering then
-- 		return
-- 	end
-- 	super_mode = not super_mode
-- 	print() print("now tracking: " .. (super_mode and "super moves only" or "all moves"))
-- 	print_header()
-- end)


local function initialize_count()
	count = {active = true, total = 0, total_superfreeze = 0, hitfreeze = 0, non_projectile = "*", freeze_details = ""}
end

local function initialize()
	player_old = {{}, {}}
	register_count, last_frame = 0, 0
	initialize_count()
end

local function no_op()
	return true
end

local get_attack_state = {
	[false] = function(addr) --non-super mode
		return game.attacking(addr)
	end,

	[true] = function(addr) --super mode
		return game.supering(addr)
	end,
}

local function update_frame_data()
	if game.address.projectile_slowdown and
		memory.readbyte(game.address[1] + 0x02) ~= 0x04 and memory.readbyte(game.address[2] + 0x02) ~= 0x04 then
		memory.writebyte(game.address.projectile_slowdown, 0) --disable projectile slowdown
	end
	if game.no_frameskip then
		game.no_frameskip() --disable frameskip
	end

	local player = {{}, {}}
	for p = 1, 2 do --get the current status of the players from RAM
		local addr = game.address[p]
		local opp_addr = (p == 1 and game.address[2]) or game.address[1]
		player[p].attacking   = get_attack_state[super_mode](addr)
		player[p].hurt        = game.hurt(addr)
		player[p].thrown      = game.thrown(addr)
		player[p].hitfreeze   = game.hitfreeze(addr, opp_addr)
		player[p].superfreeze = game.superfreeze and game.superfreeze(addr, opp_addr)
	end

	if not count.active and player[1].attacking and not player_old[1].attacking then --check for start of the attack
		-- print("Started up")
		initialize_count()
	end
	if count.active then
		-- print("dimitri gettin in dat")
	end
	if count.active and not count.startup then --check for hit
		if player[1].superfreeze and not player_old[1].superfreeze and not count.prefreeze then --superfreeze just started
			count.prefreeze = count.total + game.delay.prefreeze
		elseif player_old[1].superfreeze and not player[1].superfreeze then --superfreeze just ended
			count.superfreeze = count.total - count.prefreeze
		end

		if player[2].hurt and not player_old[2].hurt then --attack hit
			count.startup = count.total + game.delay.startup
		elseif player[2].thrown and not player_old[2].thrown then --throw grabbed
			count.startup = count.total
		elseif not player[1].attacking then --attack whiffed; stop counting
			count.active = false
		end
	end

	if count.startup and not count.atkrecov then
		if player_old[1].hurt and not player[1].hurt then --check if the attacker got hit/traded
			count.atkrecov = count.total - count.hitfreeze - count.startup + game.delay.hit_recover
		elseif player_old[1].attacking and not (player[1].attacking or player[1].hurt) then --check for attacker recovery
			count.atkrecov = count.total - count.hitfreeze - count.startup + game.delay.atk_recover
		end
	end

	if count.startup and --check for dummy recovery
		(player_old[2].hurt or player_old[2].thrown) and not (player[2].hurt or player[2].thrown) then
		count.hitstun  = count.total - count.hitfreeze - count.startup + game.delay.hit_recover
	end

	if count.active and count.atkrecov and count.hitstun then --print results and stop counting
		count.advantage = count.hitstun - count.atkrecov
		if not count.non_projectile then --if it was a projectile...
			count.atkrecov = count.atkrecov + count.hitfreeze --...then p1 didn't have any hitfreeze so add it back
		end
		if count.prefreeze then
			count.superfreeze = count.superfreeze + game.delay.superfreeze
			count.postfreeze = count.startup - count.superfreeze + game.delay.postfreeze[count.non_projectile]
			count.startup = count.prefreeze + count.postfreeze
			count.freeze_details = count.prefreeze .. " (" .. count.superfreeze .. ") " .. count.postfreeze
		end
		print_results(count)
		count.active = false
	end

	player_old = player

	if (player[1].superfreeze or player[2].superfreeze) then --check for superfreeze
		count.total_superfreeze = count.total_superfreeze + 1
	end
	if player[1].hitfreeze or player[2].hitfreeze then --check for hitfreeze
		count.hitfreeze = count.hitfreeze + 1
	end
	if player[1].hitfreeze then
		count.non_projectile = "" --only a non-projectile would freeze p1 (remove the "*")
	end

	count.total = count.total + 1

	if count.active then --display count if counting
		-- print("Donez")
		emu.message(count.total .. " (" .. count.total_superfreeze .. ")" .. " [" .. count.hitfreeze .. "]")
	end
end

gc_command = nil
frameDataModule = {
	["registerLoad"] = function() --prevent strange behavior after loading
		initialize()
	end,
	["registerAfter"] = function(mo_enable_frame_data, command_func)
		gc_command = command_func
		-- print("world",gc_command)
		if mo_enable_frame_data == true then
			register_count = register_count + 1
			if register_count == game.update.cycle then
				update_frame_data()
			end
			if last_frame < emu.framecount() then
				register_count = 0
			end
			last_frame = emu.framecount()
		end
	end,
	["registerStart"] = function(mo_enable_frame_data)
		game = nil
		super_mode = false
		initialize()
		print()
		for n, module in ipairs(profile) do
			for m, shortname in ipairs(module.games) do
				if emu.romname() == shortname or emu.parentname() == shortname then
					game = module
					-- print("tracking " .. shortname .. " frame data")
					if fba and (emu.sourcename() == "CPS1" or emu.sourcename() == "CPS2") then
						print("Warning: FBA gives inaccurate results for CPS1/CPS2.")
					end
					if game.supering then
						-- print("Lua hotkey 2: toggle normal/super-only mode")
					end
					if game.no_frameskip then
						print("* disabling frameskip")
					end
					if game.address.projectile_slowdown then
						print("* disabling projectile slowdown")
					end

					print()
					print_header()
					
					return
				end
			end
		end
		print("not prepared for " .. emu.romname() .. " frame data")
	end
}

return frameDataModule