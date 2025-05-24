// obj_player: Create Event
grav = 0.15;
y_velocity = 0;
booster = false;
stunned = false;
i_frame = false;
grounded = false;
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
    stun(0.3, 1);

    // Choose the sound based on the threshold  
    if (obj_manager.current_parcel.hits <= 0) {
        audio_play_sound(snd_impact_fragile, 10, false, 1, 0, random_range(0.9, 1.1));
    } else {
        audio_play_sound(snd_impact,         10, false, 1, 0, random_range(0.9, 1.1));
    }
}

// Stamina gravity modification
function stamina_mod()
{
	if !instance_exists(obj_manager) return 1;
	var stamina_soft_floor   = 0.33;  // %  – where the slowdown begins
	var strength_floor_ratio = 0.50;  // %  – min booster strength & max gravity buff
    var r = obj_manager.stamina / obj_manager.max_stamina;             // 0–1
    if (r >= stamina_soft_floor) return 1;     // above threshold, full power

    // linear fade from 1→strength_floor_ratio as stamina drops from 50 %→0
    var t = r / stamina_soft_floor;            // 1→0   (at 50 % … 0 %)
    return lerp(strength_floor_ratio, 1, t);   // 0.5→1
}