for _,var in ipairs({ 
						use_hb_config, 
						hb_config_blank_screen, 
						hb_config_draw_axis, 
						hb_config_draw_pushboxes, 
						hb_config_draw_throwable_boxes, 
						hb_config_no_alpha
					 }) do
	var = nil
end
-- dofile("macro-options.lua", "r") --load the globals
local boxes = {
	      ["vulnerability"] = {color = 0x7777FF, fill = 0x40, outline = 0xFF},
	             ["attack"] = {color = 0xFF0000, fill = 0x40, outline = 0xFF},
	["proj. vulnerability"] = {color = 0x00FFFF, fill = 0x40, outline = 0xFF},
	       ["proj. attack"] = {color = 0xFF66FF, fill = 0x40, outline = 0xFF},
	               ["push"] = {color = 0x00FF00, fill = 0x20, outline = 0xFF},
	           ["tripwire"] = {color = 0xFF66FF, fill = 0x40, outline = 0xFF}, --sfa3
	             ["negate"] = {color = 0xFFFF00, fill = 0x40, outline = 0xFF}, --dstlk, nwarr
	              ["throw"] = {color = 0xFFFF00, fill = 0x40, outline = 0xFF},
	         ["axis throw"] = {color = 0xFFAA00, fill = 0x40, outline = 0xFF}, --sfa, sfa2, nwarr
	          ["throwable"] = {color = 0xF0F0F0, fill = 0x20, outline = 0xFF},
}

local globals = {
	axis_color           = 0xFFFFFFFF,
	blank_color          = 0xFFFFFFFF,
	axis_size            = 12,
	mini_axis_size       = 2,
	blank_screen         = false,
	draw_axis            = true,
	draw_mini_axis       = false,
	draw_pushboxes       = true,
	draw_throwable_boxes = false,
	no_alpha             = false, --fill = 0x00, outline = 0xFF for all box types
	ground_throw_height  = 0x50, --default for sfa & sfa2 if pushbox unavailable
}
if use_hb_config == true then
	globals.blank_screen = hb_config_blank_screen
	globals.draw_axis = hb_config_draw_axis
	globals.draw_pushboxes = hb_config_draw_pushboxes
	globals.draw_throwable_boxes = hb_config_draw_throwable_boxes
	globals.no_alpha = hb_config_no_alpha
end
--------------------------------------------------------------------------------
-- game-specific modules

local rb, rbs, rw, rws, rd = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned, memory.readdword
local any_true, get_thrower, insert_throw, signed_register, define_box, get_x, get_y
local game, frame_buffer, throw_buffer

local profile = {

{	games = {"vsav", "vhunt2", "vsav2"},
	number = {players = 2, projectiles = 32},
	address = {
		player      = 0xFF8400,
		projectile  = 0xFF9400,
		screen_left = 0xFF8290,
	},
	offset = {
		object_space = 0x100,
		flip_x       = 0x0B,
		hitbox_ptr   = nil,
	},
	box_list = {
		-- Box List is a list of hitboxes
		-- 0x80 	LONGWORD Head Box Table Pointer
		-- 0x84 	LONGWORD Body Box Table Pointer
		-- 0x88 	LONGWORD Foot Box Table Pointer
		-- 0x8C 	LONGWORD Attack Box Table Pointer
		-- 0x90 	LONGWORD Push Box Table Pointer
		-- 0x94 	Head Box ID
		-- 0x95 	Body Box ID
		-- 0x96 	Foot Box ID
		-- 0x97 	Push Box ID 
		-- 0x1C 	LONGWORD Animation Pointer 
		{anim_ptr =  nil, addr_table_ptr = 0x90, id_ptr = 0x97, id_shift = 0x3, type = "push"},
		{anim_ptr =  nil, addr_table_ptr = 0x80, id_ptr = 0x94, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr =  nil, addr_table_ptr = 0x84, id_ptr = 0x95, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr =  nil, addr_table_ptr = 0x88, id_ptr = 0x96, id_shift = 0x3, type = "vulnerability"},
		{anim_ptr =  nil, addr_table_ptr = 0x90, id_ptr = 0x97, id_shift = 0x3, type = "throwable"}, --identical to pushbox
		{anim_ptr = 0x1C, addr_table_ptr = 0x8C, id_ptr = 0x0A, id_shift = 0x5, type = "attack"},
	},
	breakpoints = {
		{["vsav"] = 0x029450, ["vsav2"] = 0x02874A, ["vhunt2"] = 0x028778, 
		func = function() --non-ranged throws
			local stack, pc = rd(memory.getregister("m68000.a7")), memory.getregister("m68000.pc")
			if stack ~= pc + 0x30 and stack ~= pc + 0xB2 and stack ~= pc + 0xBE then
				return --don't draw the initial range check of command throws
			end
			insert_throw({
				id = bit.band(memory.getregister("m68000.d0"), 0xFF),
				anim_ptr = nil, addr_table_ptr = 0x8C, id_ptr = 0x98, id_shift = 0x5, type = "throw",
			})
		end},
		{["vsav"] = 0x0191A2, ["vsav2"] = 0x017BA4, ["vhunt2"] = 0x017BAA, ["vhunt2r1"] = 0x017B3A, 
		func = function() --attempt cmd throws from any range
			local stack = {rd(memory.getregister("m68000.a7")), rd(memory.getregister("m68000.a7") + 4)}
			local target = {["vsav"] = 0x029472, ["vsav2"] = 0x02876C, ["vhunt2"] = 0x02879A, ["vhunt2r1"] = 0x0286E8}
			target = target[emu.romname()] or target[emu.parentname()]
			-- print("RD", rd(memory.getregister("m68000.a7")))
			if any_true({
				stack[1] ~= target, --must be a command throw setup
				stack[2] == target + 0x0E, --don't interfere with actual throw attempts
				stack[2] == target + 0x90, --don't interfere with attacks
				stack[2] == target + 0x9C, --don't interfere with vsav2/vhunt2 air throws
				}) then
				return
			end
			memory.setregister("m68000.d1", 0)
		end},
		{["vsav"] = 0x029638, ["vsav2"] = 0x02893E, ["vhunt2"] = 0x02896C, 
		func = function() --ranged throws
			-- print("RD", rd(memory.getregister("m68000.a7")))

			local base = memory.getregister("m68000.a4")
			insert_throw({
				id = bit.band(memory.getregister("m68000.d0"), 0xFF),
				pos_x = get_x(rws(base + game.offset.pos_x)),
				pos_y = get_y(rws(base + game.offset.pos_y)),
				anim_ptr = nil, addr_table_ptr = 0x8C, id_ptr = 0x98, id_shift = 0x5, type = "throw",
			})
		end},
	},
	clones = {
		["vsava"] = 0, ["vsavd"] = 0, ["vsavh"] = 0, ["vsavj"] = 0, ["vsavu"] = 0, 
		["vsav2"] = 0, ["vsav2d"] = 0, ["vhunt2"] = 0, ["vhunt2d"] = 0, ["vhunt2r1"] = -0xB2
	},
	process_throw = function(obj, box)
		return define_box[game.box_type](obj, box)
	end,
	friends = {0x08, 0x10, 0x11, 0x37},
	active = function() return any_true({
		(rd(0xFF8004) == 0x40000 and rd(0xFF8008) == 0x40000),
		(rw(0xFF8008) == 0x2 and rw(0xFF800A) > 0),
	}) end,
	invulnerable = function(obj, box) 
		return any_true({
		rb(obj.base + 0x134) > 0,
		rb(obj.base + 0x147) > 0,
		rb(obj.base + 0x11E) > 0,
		rb(obj.base + 0x145) > 0 and rb(obj.base + 0x1A4) == 0,
	}) end,
	unpushable = function(obj, box) return any_true({
		rb(obj.base + 0x134) > 0,
	}) end,
	unthrowable = function(obj, box) return any_true({
		not (rw(obj.base + 0x004) == 0x0200 or rw(obj.base + 0x004) == 0x0204),
		rb(obj.base + 0x143) > 0,
		rb(obj.base + 0x147) > 0,
		rb(obj.base + 0x11E) > 0,
		bit.band(rd(obj.base + 0x094), 0xFFFFFF00) == 0,
	}) end,
},
}

--------------------------------------------------------------------------------
-- post-process the modules

for game in ipairs(profile) do
	local g = profile[game]
	g.box_type = g.offset.id_ptr and "id ptr" or "hitbox ptr"
	g.ground_level = g.ground_level or -0x0F
	g.offset.player_space = g.offset.player_space or 0x400
	g.offset.pos_x = g.offset.pos_x or 0x10
	g.offset.pos_y = g.offset.pos_y or g.offset.pos_x + 0x4
	g.offset.hitbox_ptr = g.offset.hitbox_ptr or {}
	g.box = g.box or {}
	g.box.radius_read = g.box.radius_read or rw
	g.box.offset_read = g.box.radius_read == rw and rws or rbs
	g.box.val_x    = g.box.val_x or 0x0
	g.box.val_y    = g.box.val_y or 0x2
	g.box.rad_x    = g.box.rad_x or 0x4
	g.box.rad_y    = g.box.rad_y or 0x6
	g.box.radscale = g.box.radscale or 1
	g.no_hit       = g.no_hit       or function() end
	g.invulnerable = g.invulnerable or function() end
	g.unpushable   = g.unpushable   or function() end
	g.unthrowable  = g.unthrowable  or function() end
	g.projectile_active = g.projectile_active or function(obj)
		if rw(obj.base) > 0x0100 and rb(obj.base + 0x04) == 0x02 then
			return true
		end
	end
	g.special_projectiles = g.special_projectiles or {number = 0}
	g.breakables = g.breakables or {number = 0}
end

for _, box in pairs(boxes) do
	box.fill    = bit.lshift(box.color, 8) + (globals.no_alpha and 0x00 or box.fill)
	box.outline = bit.lshift(box.color, 8) + (globals.no_alpha and 0xFF or box.outline)
end

local projectile_type = {
	       ["attack"] = "proj. attack",
	["vulnerability"] = "proj. vulnerability",
}

local DRAW_DELAY = 1
if fba then
	DRAW_DELAY = DRAW_DELAY + 1
end
emu.registerfuncs = fba and memory.registerexec --0.0.7+


--------------------------------------------------------------------------------
-- functions referenced in the modules

any_true = function(condition)
	for n = 1, #condition do
		if condition[n] == true then return true end
	end
end


get_thrower = function(frame)
	local base = bit.band(0xFFFFFF, memory.getregister("m68000.a6"))
	for _, obj in ipairs(frame) do
		if base == obj.base then
			return obj
		end
	end
end


insert_throw = function(box)
	local f = frame_buffer[DRAW_DELAY]
	local obj = get_thrower(f)
	if not f.match_active or not obj then
		return
	end
	table.insert(throw_buffer[obj.base], game.process_throw(obj, box))
end


signed_register = function(register, bytes)
	print(memory.getregister)
	local bits = bit.lshift(4, bytes or 2)
	local val = bit.band(memory.getregister("m68000." .. register), bit.lshift(1, bits) - 1)
	if bit.arshift(val, bits-1) > 0 then
		val = val - bit.lshift(1, bits)
	end
	return val
end


get_x = function(x)
	return x - frame_buffer[DRAW_DELAY+1].screen_left
end


get_y = function(y)
	return emu.screenheight() - (y + game.ground_level) + frame_buffer[DRAW_DELAY+1].screen_top
end


--------------------------------------------------------------------------------
-- prepare the hitboxes

local process_box_type = {
	["vulnerability"] = function(obj, box)
		if game.invulnerable(obj, box) or obj.friends then
			return false
		end
	end,

	["attack"] = function(obj, box)
		if game.no_hit(obj, box) then
			return false
		end
	end,

	["push"] = function(obj, box)
		if game.unpushable(obj, box) or obj.friends then
			return false
		end
	end,

	["negate"] = function(obj, box)
	end,

	["tripwire"] = function(obj, box)
		box.id = bit.rshift(box.id, 1) + 0x3E
		box.pos_x = box.pos_x or rws(obj.base + 0x1E4)
		if box.pos_x == 0 or rb(obj.base + 0x102) ~= 0x0E then
			return false
		elseif box.clear and not (rb(obj.base + 0x07) == 0x04 and rb(obj.base + 0xAA) == 0x0C) then
			memory.writeword(obj.base + 0x1E4, 0) --sfa3 w/o registerfuncs (bad)
		end
		box.pos_x = obj.pos_x + box.pos_x
	end,

	["throw"] = function(obj, box)
		if box.clear then
			memory.writebyte(obj.base + box.id_ptr, 0) --sfa3 w/o registerfuncs (bad)
		end
	end,

	["axis throw"] = function(obj, box)
	end,

	["throwable"] = function(obj, box)
		if game.unthrowable(obj, box) or obj.projectile then
			return false
		end
	end,
}

define_box = {
	["hitbox ptr"] = function(obj, box_entry)
		local box = copytable(box_entry)

		if obj.projectile and box.no_projectile then
			return nil
		end

		if not box.id then
			box.id_base = (box.anim_ptr and rd(obj.base + box.anim_ptr)) or obj.base
			box.id = rb(box.id_base + box.id_ptr)
		end

		if process_box_type[box.type](obj, box) == false or box.id == 0 then
			return nil
		end

		local addr_table
		if not obj.hitbox_ptr then
			addr_table = rd(obj.base + box.addr_table_ptr)
		else
			local table_offset = obj.projectile and box.p_addr_table_ptr or box.addr_table_ptr
			addr_table = obj.hitbox_ptr + rws(obj.hitbox_ptr + table_offset)
		end
		box.address = addr_table + bit.lshift(box.id, box.id_shift)

		box.rad_x = game.box.radius_read(box.address + game.box.rad_x)/game.box.radscale
		box.rad_y = game.box.radius_read(box.address + game.box.rad_y)/game.box.radscale
		box.val_x = game.box.offset_read(box.address + game.box.val_x)
		box.val_y = game.box.offset_read(box.address + game.box.val_y)
		if box.type == "push" then
			obj.val_y, obj.rad_y = box.val_y, box.rad_y
		end

		box.val_x  = (box.pos_x or obj.pos_x) + box.val_x * obj.flip_x
		box.val_y  = (box.pos_y or obj.pos_y) - box.val_y
		box.left   = box.val_x - box.rad_x
		box.right  = box.val_x + box.rad_x
		box.top    = box.val_y - box.rad_y
		box.bottom = box.val_y + box.rad_y

		box.type = obj.projectile and not obj.friends and projectile_type[box.type] or box.type

		return box
	end,

	["id ptr"] = function(obj, box_entry) --ringdest only
		local box = copytable(box_entry)

		if process_box_type[box.type](obj, box) == false then
			return nil
		end

		if box.addr_table_base then
			box.address = box.addr_table_base + bit.lshift(obj.id_offset, 2)
		else
			box.address = rd(obj.base + box.addr_table_ptr)
		end

		box.rad_x = game.box.radius_read(box.address + game.box.rad_x)/game.box.radscale
		box.rad_y = game.box.radius_read(box.address + game.box.rad_y)/game.box.radscale
		if box.rad_x == 0 or box.rad_y == 0 then
			return nil
		end
		box.val_x = game.box.offset_read(box.address + game.box.val_x)
		box.val_y = game.box.offset_read(box.address + game.box.val_y)

		box.val_x  = obj.pos_x + (box.rad_x + box.val_x) * obj.flip_x
		box.val_y  = obj.pos_y - (box.rad_y + box.val_y)
		box.left   = box.val_x - box.rad_x
		box.right  = box.val_x + box.rad_x
		box.top    = box.val_y - box.rad_y
		box.bottom = box.val_y + box.rad_y

		box.type = obj.projectile and projectile_type[box.type] or box.type

		return box
	end,

	["range given"] = function(obj, box_entry) --dstlk/nwarr throwable; nwarr ranged
		local box = copytable(box_entry)

		box.base_x  = rw(obj.base + box.base_x)
		box.range_x = rb(obj.base + box.range_x)
		if process_box_type[box.type](obj, box) == false or box.base_x == 0 or box.range_x == 0 then
			return nil
		end
		box.right = get_x(box.base_x) - box.range_x
		box.left  = get_x(box.base_x) + box.range_x
		if box.type == "axis throw" then --nwarr ranged
			box.bottom = get_y(game.ground_level)
			box.top    = get_y(rw(obj.base + box.range_y))
		else
			box.top    = obj.pos_y - rb(obj.base + box.range_y)
			if rb(obj.base + box.air_state) > 0 then
				box.bottom = box.top + 0xC --air throwable; verify range @ 033BE0 [dstlk] & 029F50 [nwarr]
			else
				box.bottom = obj.pos_y --ground throwable
			end
		end
		box.val_x = (box.left + box.right)/2
		box.val_y = (box.bottom + box.top)/2

		return box
	end,

	["dimensions"] = function(obj, box_entry) --cybots throwable
		local box = copytable(box_entry)

		if process_box_type[box.type](obj, box) == false then
			return nil
		end
		box.hval = rws(obj.base + box.dimensions + 0x0)
		box.vval = rws(obj.base + box.dimensions + 0x2)
		box.hrad =  rw(obj.base + box.dimensions + 0x4)
		box.vrad =  rw(obj.base + box.dimensions + 0x6)

		box.hval   = obj.pos_x + box.hval * obj.flip_x
		box.vval   = obj.pos_y - box.vval
		box.left   = box.hval - box.hrad
		box.right  = box.hval + box.hrad
		box.top    = box.vval - box.vrad
		box.bottom = box.vval + box.vrad

		return box
	end,
}


local get_ptr = {
	["hitbox ptr"] = function(obj)
		obj.hitbox_ptr = obj.projectile and game.offset.hitbox_ptr.projectile or game.offset.hitbox_ptr.player
		obj.hitbox_ptr = obj.hitbox_ptr and rd(obj.base + obj.hitbox_ptr) or nil
	end,

	["id ptr"] = function(obj) --ringdest only
		obj.id_offset = rw(obj.base + game.offset.id_ptr)
	end,
}


local update_object = function(obj)
	obj.flip_x = rb(obj.base + game.offset.flip_x) > 0 and -1 or 1
	obj.pos_x  = get_x(rws(obj.base + game.offset.pos_x))
	obj.pos_y  = get_y(rws(obj.base + game.offset.pos_y))
	get_ptr[game.box_type](obj)
	for _, box_entry in ipairs(game.box_list) do
		table.insert(obj, define_box[box_entry.method or game.box_type](obj, box_entry))
	end
	return obj
end


local friends_status = function(id)
	for _, friend in ipairs(game.friends or {}) do
		if id == friend then
			return true
		end
	end
end


local read_projectiles = function(f)
	for i = 1, game.number.projectiles do
		local obj = {base = game.address.projectile + (i-1) * game.offset.object_space}
		if game.projectile_active(obj) then
			obj.projectile = true
			obj.friends = friends_status(rb(obj.base + 0x02))
			table.insert(f, update_object(obj))
		end
	end

	for i = 1, game.special_projectiles.number do --for nwarr only
		local obj = {base = game.special_projectiles.start + (i-1) * game.special_projectiles.space}
		local id = rb(obj.base + 0x02)
		for _, valid in ipairs(game.special_projectiles.no_box) do
			if id == valid then
				obj.pos_x = get_x(rws(obj.base + game.offset.pos_x))
				obj.pos_y = get_y(rws(obj.base + game.offset.pos_y))
				table.insert(f, obj)
				break
			end
		end
		for _, valid in ipairs(game.special_projectiles.whitelist) do
			if id == valid then
				obj.projectile, obj.hit_only, obj.friends = true, true, friends_status(id)
				table.insert(f, update_object(obj))
				break
			end
		end
	end
--[[
	for i = 1, game.breakables.number do --for dstlk, nwarr
		local obj = {base = game.breakables.start + (i-1) * game.breakables.space}
		local status = rb(obj.base + 0x04)
		if status == 0x02 then
			obj.projectile = true
			obj.x_adjust = 0x1C*((f.screen_left-0x100)/0xC0-1)
			table.insert(f, update_object(obj))
		end
	end
]]
end


local update_hitboxes = function()
	if not game then
		return
	end
	local screen_left_ptr = game.address.screen_left or game.get_cam_ptr()
	local screen_top_ptr  = game.address.screen_top or screen_left_ptr + 0x4
	for f = 1, DRAW_DELAY do
		frame_buffer[f] = copytable(frame_buffer[f+1])
	end

	frame_buffer[DRAW_DELAY+1] = {
		match_active = game.active(),
		screen_left = rws(screen_left_ptr),
		screen_top  = rws(screen_top_ptr),
	}
	local f = frame_buffer[DRAW_DELAY+1]
	if not f.match_active then
		return
	end

	for p = 1, game.number.players do
		local player = {base = game.address.player + (p-1) * game.offset.player_space}
		if rb(player.base) > 0 then
			table.insert(f, update_object(player))
			local tb = throw_buffer[player.base]
			table.insert(player, tb[1])
			for frame = 1, #tb-1 do
				tb[frame] = tb[frame+1]
			end
			table.remove(tb)
		end
	end
	read_projectiles(f)

	f = frame_buffer[DRAW_DELAY]
	for _, obj in ipairs(f or {}) do
		if obj.projectile then
			break
		end
		for _, box_entry in ipairs(game.throw_box_list or {}) do
			if not (emu.registerfuncs and box_entry.clear) then
				table.insert(obj, define_box[box_entry.method or game.box_type](obj, box_entry))
			end
		end
	end

	f.max_boxes = 0
	for _, obj in ipairs(f or {}) do
		f.max_boxes = math.max(f.max_boxes, #obj)
	end
	f.max_boxes = f.max_boxes+1
end


-- emu.registerafter( function()
-- 	update_hitboxes()
-- end)


--------------------------------------------------------------------------------
-- draw the hitboxes
local draw_hitbox = function(hb)
	if not hb or any_true({
		not globals.draw_pushboxes and hb.type == "push",
		not globals.draw_throwable_boxes and hb.type == "throwable",
	}) then return
	end

	if globals.draw_mini_axis then
		gui.drawline(hb.val_x, hb.val_y-globals.mini_axis_size, hb.val_x, hb.val_y+globals.mini_axis_size, boxes[hb.type].outline)
		gui.drawline(hb.val_x-globals.mini_axis_size, hb.val_y, hb.val_x+globals.mini_axis_size, hb.val_y, boxes[hb.type].outline)
	end

	gui.box(hb.left, hb.top, hb.right, hb.bottom, boxes[hb.type].fill, boxes[hb.type].outline)
end


local draw_axis = function(obj)
	gui.drawline(obj.pos_x, obj.pos_y-globals.axis_size, obj.pos_x, obj.pos_y+globals.axis_size, globals.axis_color)
	gui.drawline(obj.pos_x-globals.axis_size, obj.pos_y, obj.pos_x+globals.axis_size, obj.pos_y, globals.axis_color)
	--gui.text(obj.pos_x, obj.pos_y, string.format("%06X", obj.base)) --debug
end

_p2_attacking = false 

local render_hitboxes = function()
	local f = frame_buffer[1]
	if not f.match_active then
		return
	end

	if globals.blank_screen then
		gui.box(0, 0, emu.bufferwidth(), emu.bufferheight(), globals.blank_color)
	end
	-- las_obj
	for entry = 1, f.max_boxes or 0 do
		for _, obj in ipairs(f) do
			if obj[entry] then
				-- if obj[entry] ~= nil and obj[entry] then
				-- 	print("Entry", obj[entry])
				-- end
				if obj[entry]['type'] == "attack" then
					_p2_attacking = true
					-- print("heres the obj:", obj[entry])
				else
					_p2_attacking = false
	
				end
			end
			draw_hitbox(obj[entry])
		end
	end

	if globals.draw_axis then
		for _, obj in ipairs(f) do
			draw_axis(obj)
		end
	end
end


-- gui.register(function()
-- 	render_hitboxes()
-- end)


--------------------------------------------------------------------------------
-- hotkey functions

-- input.registerhotkey(1, function()
-- 	globals.blank_screen = not globals.blank_screen
-- 	render_hitboxes()
-- 	emu.message((globals.blank_screen and "activated" or "deactivated") .. " blank screen mode")
-- end)


-- input.registerhotkey(2, function()
-- 	globals.draw_axis = not globals.draw_axis
-- 	render_hitboxes()
-- 	emu.message((globals.draw_axis and "showing" or "hiding") .. " object axis")
-- end)


-- input.registerhotkey(3, function()
-- 	globals.draw_mini_axis = not globals.draw_mini_axis
-- 	render_hitboxes()
-- 	emu.message((globals.draw_mini_axis and "showing" or "hiding") .. " hitbox axis")
-- end)


-- input.registerhotkey(4, function()
-- 	globals.draw_pushboxes = not globals.draw_pushboxes
-- 	render_hitboxes()
-- 	emu.message((globals.draw_pushboxes and "showing" or "hiding") .. " pushboxes")
-- end)


-- input.registerhotkey(5, function()
-- 	globals.draw_throwable_boxes = not globals.draw_throwable_boxes
-- 	render_hitboxes()
-- 	emu.message((globals.draw_throwable_boxes and "showing" or "hiding") .. " throwable boxes")
-- end)


--------------------------------------------------------------------------------
-- initialize on game startup

local initialize_bps = function()
	for _, pc in ipairs(globals.breakpoints or {}) do
		memory.registerexec(pc, nil)
	end
	for _, addr in ipairs(globals.watchpoints or {}) do
		memory.registerwrite(addr, nil)
	end
	globals.breakpoints, globals.watchpoints = {}, {}
end


local initialize_fb = function()
	frame_buffer = {}
	for f = 1, DRAW_DELAY + 1 do
		frame_buffer[f] = {}
	end
end


local initialize_throw_buffer = function()
	throw_buffer = {}
	for p = 1, game.number.players do
		throw_buffer[game.address.player + (p-1) * game.offset.player_space] = {}
	end
end


local whatgame = function()
	game = nil
	initialize_fb()
	initialize_bps()
	for _, module in ipairs(profile) do
		for _, shortname in ipairs(module.games) do
			if emu.romname() == shortname or emu.parentname() == shortname then
				-- print("drawing hitboxes for " .. emu.gamename())
				game = module
				initialize_throw_buffer()
				if not emu.registerfuncs then
					if game.breakpoints then
						-- print("(FBA-rr 0.0.7+ can show throwboxes for this game.)")
					end
					return
				end
				for _, bp in ipairs(game.breakpoints or {}) do
					local pc = bp[emu.romname()] or bp[shortname] + game.clones[emu.romname()]
					memory.registerexec(pc, bp.func)
					table.insert(globals.breakpoints, pc)
				end
				for _, wp in ipairs(game.watchpoints or {}) do
					for p = 1, game.number.players do
						local addr = game.address.player + (p-1) * game.offset.player_space + wp.offset
						memory.registerwrite(addr, wp.size, wp.func)
						table.insert(globals.watchpoints, addr)
					end
				end
				return
			end
		end
	end
	print("unsupported game: " .. emu.gamename())
end

cps2HitboxModule = {
    ["registerStart"] = function()
		whatgame()
	end,
	["registerLoad"] = function()
		initialize_fb()
	end,
	["registerAfter"] = function()
		update_hitboxes()
	end,
	["guiRegister"] = function(display_hitbox_default, use_hb_config)
		if display_hitbox_default == true then
			render_hitboxes()
		end
	end,
	["registerBefore"] = function()
	end
}
return cps2HitboxModule
