serialize = require './scripts/ser'

function swap_inputs_p1_to_p2(_in_input_table, _out_input_table)
	-- print("Read",serialize(joypad.get()))
  function swap(_input)
	local carry = _in_input_table["P1 ".._input]
	local carry2 = _in_input_table["P2 ".._input]

    _out_input_table["P1 ".._input] = false
    _out_input_table["P2 ".._input] = nil

	-- _out_input_table["P1 ".._input] = _in_input_table["P2 ".._input]

	_out_input_table["P2 ".._input] = _in_input_table["P1 ".._input]

	-- _out_input_table["P2 ".._input] = carry
	-- _out_input_table["P1 ".._input] = carry2
  end

	swap("Up")
	swap("Down")
	swap("Left")
	swap("Right")
	swap("Button 1")
	swap("Button 2")
	swap("Button 3")
	swap("Button 4")
	swap("Button 5")
	swap("Button 6")
end
run_once = false
run_once_frame = nil
num_run = 0
last_frame = 0
acc_input = {}

function string.starts(String,Start)
	return string.sub(String,1,string.len(Start))==Start
 end

controllerModule = {

  ["registerBefore"] = function()
	if globals.controlling_p1 == true then
		return
	end
	if run_once == false and run_once_frame == nil then
		run_once_frame = emu.framecount()
	end
	cur_input = joypad.get()
	p1_inputs = {}
	for k,v in pairs(cur_input) do
		if string.starts(k, "P1") then
			p1_inputs[k] = v
		end
	end 

	if emu.framecount() == last_frame then
		-- print("running before hook on", emu.framecount())

		for k,v in pairs(p1_inputs) do 
			if v == true then
				acc_input[k] = v 
			end
		end
		-- print("Acc", serialize(acc_input))
		__input = {}
		swap_inputs_p1_to_p2(acc_input, __input)
		joypad.set(__input)
		-- print("Result", serialize(__input))
	
	end
	if emu.framecount() > last_frame then
		-- print("Resetting")
		last_frame = emu.framecount()
		acc_input = {}
	end
	-- memory.writebyte(0xFF8000 + 0xA0, 0x10)
	-- test_1 = memory.readword(0xFFB894)
	-- memory.writedword(0xFF8796, 0x00000000)	
	-- memory.writedword(0xFF805A, 0x00000000)	
	-- memory.writedword(0xFF8524, 0x00000000)	
	-- memory.writedword(0x00FFBA0E, 0x00000032A)
	-- memory.writedword(0x00FF2FF8, 0xB880BA00)
	-- memory.writedword(0x00FF325A, 0xB880BA00)
	-- if emu.framecount() <= run_once_frame + 36 then
	-- 	print("Ran Init logic on", emu.framecount())
	-- 	memory.writebyte(0xFF8454, 0x1D)
	-- 	memory.writebyte(0xFF8405, 0x02)
	-- else 
	-- 	run_once = true
	-- 	print("Setting the dizzy timer")
	-- 	memory.writebyte(0xFF855D, 0xFF)
	-- end
	--continuous
	-- attack flag enabled proxy block
	-- if( opponent has attack flag ) then do proxy_block
	-- for a few frames (8-10) then stop
	-- memory.writebyte(0xFF810E, 0x1)

	-- so on init, we want to run the get hit 
	--run status one value as being hurt
	-- FF8405 as 2, forces them to be hit
	-- memory.writebyte(0xFF8454, 0x0C)
	-- memory.writebyte(0xFF8405, 0x02)

	-- now 


	-- memory.writebyte(0xFF8400 + 0x10D, 0xFF)
	-- memory.writebyte(0xFF8400 + 0x15C, 0x10)
	-- memory.writebyte(0xFF8400 + 0x44, 0x1)
	-- memory.writebyte(0xFF8400 + 0x3A, 0x1)
	-- memory.writebyte(0xFF8400 + 0x14, 0x1)
	-- memory.writebyte(0xFF8400 + 0x11B, 0x1)
	-- memory.writebyte(0xFF8109, 0x0)

	-- memory.writebyte(0xFF8593, 0x0)
	-- memory.writebyte(0xFF8493, 0x0)
	-- memory.writebyte(0xFF8494, 0x0)
	-- memory.writebyte(0xFF8495, 0x0)
	-- memory.writebyte(0xFF8496, 0x0)
	-- memory.writebyte(0xFF8497, 0x0)
	-- memory.writebyte(0xFF8400 + 0xCB4, 0x0)
	-- memory.writebyte(0xFF8400 + 0x101, 0x0)
	-- memory.writebyte(0xFF8400 + 0x103, 0x0)
	-- memory.writeword(0xFF8400 + 0x40, 0x0)
	-- memory.writeword(0xFF8400 + 0x42, 0x0)
	-- memory.writeword(0xFF8400 + 0x44, 0x0)
	-- memory.writeword(0xFF8400 + 0x46, 0x0)
	-- memory.writeword(0xFF8400 + 0x48, 0x0)
	-- memory.writebyte(0xFF8400 + 0x120, 0x0)
	-- memory.writebyte(0xFF8400 + 0x121, 0x0)
	-- memory.writebyte(0xFF8400 + 0x122, 0x0)
	-- memory.writebyte(0xFF8400 + 0x123, 0x0)
	-- memory.writebyte(0xFF8400 + 0x124, 0x0)
	-- memory.writebyte(0xFF8400 + 0x125, 0x0)
	-- memory.writebyte(0xFF8400 + 0x126, 0x0)
	-- memory.writebyte(0xFF8400 + 0x127, 0x0)
	-- memory.writebyte(0xFF8400 + 0x129, 0x0)
	-- memory.writebyte(0xFF8400 + 0x129, 0x0)
	-- memory.writebyte(0xFF8400 + 0x12A, 0x0)
	-- memory.writebyte(0xFF8400 + 0x12B, 0x0)
	-- memory.writebyte(0xFF8400 + 0x12C, 0x0)
	-- memory.writebyte(0xFF8400 + 0x12D, 0x0)
	-- memory.writebyte(0xFF8794, 0x0)
	-- memory.writebyte(0xFF8795 , 0x0)
	-- memory.writebyte(0xFF8796 , 0x0)
	-- memory.writebyte(0xFF8797 , 0x0)
	-- memory.writebyte(0xFF8700 , 0x0)
	-- memory.writebyte(0xFF8701 , 0x0)

end
}
return controllerModule