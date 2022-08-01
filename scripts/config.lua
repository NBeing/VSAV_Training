
local default_training_settings = {
	infinite_time = true,
    gc_button = 1,
    gc_freq = 1,
    gc_delay = 1,
    roll_direction = 1,
    guard_action = 1,
    pb_type = 1,
    dummy_neutral = 1,
    guard = 1,
    counter_attack = 1,
	show_hitboxes = 1,
    counter_attack_random_upback = 1,
    enable_slot_3 = false,
    display_movelist = false,
    recording_slot = 4,
    random_playback = false,
    enable_slot_1 = false,
    p1_refill_timer = 1,
    p2_refill_timer = 1,
    show_hitboxes = false,
    enable_slot_2=true,
    push_block_type=1,
    p1_max_life= 288,
    p2_max_life= 288,
    enable_slot_4=true,
    enable_slot_5=false,
    mo_enable_frame_data=true,
    display_recording_gui= false,
    display_hitbox_default = true,
    display_hud=true,
    input_event_type = 0,
    inp_history_scroll = 0,
    graph_data_index = 0,
    counter_attack_button = 1,
    counter_attack_stick = 1,
    delay_after = false,
    p1_reversal_list = 1,
    p1_reversal_strength = 1,
    p2_reversal_list = 1,
    p2_reversal_strength = 1,
    true_reversal = false,
    p1_infinite_df = true,
    p2_infinite_df = true,
    use_character_specific_slots = true,
    enable_custom_palette = true,
    p1_char_palette = 0,
    p2_char_palette = 0,
    p2_throw_tech = true,
    p2_block_chance = 1,
    looped_playback = true,
    pb_type_rec = 0,
    anak_projectile = 1,
    lei_lei_stun_item = 0,
    show_move_strength = 0,
    show_pb_pushback_timer = 0,
    show_pb_timer = 0,
    show_throw_invuln_timer = 0,
    show_mash_timer = 0,
    show_invuln_timer = 0,
    display_airdash_trainer = 0,
    show_x_distance = 0,
    display_dash_interval_trainer = false,
    display_dash_length_trainer = false,
    display_short_hop_counter = false,
    show_projectile_count_limiter = 0,
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