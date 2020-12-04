serialize = require './scripts/ser'

function swap_inputs(_out_input_table)
  function swap(_input)
    local carry = _out_input_table["P1 ".._input]
    _out_input_table["P1 ".._input] = _out_input_table["P2 ".._input]
    _out_input_table["P2 ".._input] = carry
  end

  swap("Up")
  swap("Down")
  swap("Left")
  swap("Right")
  swap("Weak Punch")
  swap("Medium Punch")
  swap("Strong Punch")
  swap("Weak Kick")
  swap("Medium Kick")
  swap("Strong Kick")
end
local serialize  	    = require './scripts/ser'

controllerModule = {

  ["registerBefore"] = function()
	if globals.controlling_p1 == true then
		return
	end
	
  _input = joypad.get()
  swap_inputs(_input)
	joypad.set(_input)

end
}
return controllerModule