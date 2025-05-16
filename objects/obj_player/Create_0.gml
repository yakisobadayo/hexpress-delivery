// obj_player: Create Event
grav = 0.15;
y_velocity = 0;
booster = false;
stunned = false;
colliding = false;
in_house_bounds = false;



// FUNCTIONS
// Trigger when hitting obstacle
function get_hit() {
	// Get hit
	obj_manager.register_hit(1);
	
    // Knockback & stun  
    if (y_velocity < 0) y_velocity = 0;
    stunned = true;
    alarm_set(0, 0.4 * room_speed);

    // Choose the sound based on the threshold  
    if (obj_manager.current_parcel.hits <= 0) {
        audio_play_sound(snd_impact_fragile, 10, false, 1, 0, random_range(0.9, 1.1));
    } else {
        audio_play_sound(snd_impact,         10, false, 1, 0, random_range(0.9, 1.1));
    }
}