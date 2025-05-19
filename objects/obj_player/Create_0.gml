// obj_player: Create Event
grav = 0.15;
y_velocity = 0;
booster = false;
stunned = false;
i_frame = false;
colliding = false;
in_house_bounds = false;



// FUNCTIONS
// Stun & knockback (lose control)
function stun(_stun_time, _i_time) { // Time is in seconds
	if (y_velocity < 0) y_velocity = 0;
	stunned = true;
    alarm_set(0, _stun_time * room_speed); // stun
	i_frame = true;
	alarm_set(1, _i_time * room_speed);    // i-frame
}

// Trigger when hitting obstacle
function get_hit() {
	// Get hit
	obj_manager.register_hit(1);
	
    // Stun
    stun(0.3, 1.2);

    // Choose the sound based on the threshold  
    if (obj_manager.current_parcel.hits <= 0) {
        audio_play_sound(snd_impact_fragile, 10, false, 1, 0, random_range(0.9, 1.1));
    } else {
        audio_play_sound(snd_impact,         10, false, 1, 0, random_range(0.9, 1.1));
    }
}