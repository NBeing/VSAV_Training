
local default_training_settings = {
	-- blocking_style = 1,
	-- blocking_mode = 1,
	-- tech_throws_mode = 1,
	-- dummy_player = 2,
	-- red_parry_hit_count = 1,
	-- counter_attack_stick = 1,
	-- counter_attack_button = 1,
	-- fast_recovery_mode = 1,
	infinite_time = true,
	-- life_mode = 1,
	-- meter_mode = 1,
	-- p1_meter = 0,
	-- p2_meter = 0,
	-- infinite_sa_time = false,
	-- no_stun = true,
	-- display_input = true,
	-- display_hitboxes = false,
	-- auto_crop_recording = false,
	-- current_recording_slot = 1,
	-- replay_mode = 1,
	-- music_volume = 10,
	-- life_refill_delay = 20,
	-- meter_refill_delay = 20,
    gc_button = 0,
    gc_freq = 0,
    gc_delay = 0,
    roll_direction = 0,
    guard_action = 0,
    pb_type = 0,
    dummy_neutral = 0,
    guard = 0,
    counter_attack = 0,
    show_hitboxes = 0
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