
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
    counter_attack_random_upback = 0,
    max_life = 0,
    enable_slot_3 = false,
    display_movelist = false,
    recording_slot = 4,
    random_playback = false,
    enable_slot_1 = false,
    refill_timer = 1,
    show_hitboxes = false,
    enable_slot_2=true,
    push_block_type=0,
    max_life= 288,
    enable_slot_4=true,
    enable_slot_5=false,
    mo_enable_frame_data=true,
    display_recording_gui= false,
    display_hitbox_default = true,
    display_hud=true,
    input_event_type = 0,
    inp_history_scroll = 0
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