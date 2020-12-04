
local default_training_settings = {
	infinite_time = true,
    gc_button = 0,
    gc_freq = 0,
    gc_delay = 0,
    roll_direction = 0,
    guard_action = 0,
    pb_type = 0,
    dummy_neutral = 0,
    guard = 0,
    counter_attack = 0,
	show_hitboxes = 0,
	counter_attack_random_upback = 0
  }
  

previous_config_matrix = nil

configModule = {
    ["default_training_settings"] = default_training_settings,
    ["registerBefore"] = function()
        
        config_matrix = training_settings
        return config_matrix
    end
}

return configModule