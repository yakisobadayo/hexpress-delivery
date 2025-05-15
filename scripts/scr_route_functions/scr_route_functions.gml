// Initialise money
global.money = 0;
global.base_tip = 50;

function register_hit(_hit, _tip_modifier){
    obj_manager.hits += _hit;
	if (obj_manager.hits > obj_manager.max_hits){
		obj_manager.hits = obj_manager.max_hits;
	}
	
	obj_manager.tip_multiplier += _tip_modifier;
	if (obj_manager.tip_multiplier < 0){ // Clamp multuplier
		obj_manager.tip_multiplier = 0;
	}
}

function get_hit() {
	// Get hit
	register_hit(1, -0.25);
	
    // Knockback & stun  
    if (y_velocity < 0) y_velocity = 0;
    stunned = true;
    alarm_set(0, 0.4 * room_speed);

    // Choose the sound based on the threshold  
    if (obj_manager.hits >= obj_manager.max_hits) {
        audio_play_sound(snd_impact_fragile, 10, false, 1, 0, random_range(0.9, 1.1));
    } else {
        audio_play_sound(snd_impact,         10, false, 1, 0, random_range(0.9, 1.1));
    }
}

function drop_parcel(){
	// Drop parcel
	var _dropped_parcel = instance_create_layer(x, y, "Instances", obj_parcel);
	_dropped_parcel.tip_multiplier = obj_manager.tip_multiplier;
	
	// Reset for the next delivery: Restore parcel health to 100%.
    obj_manager.tip_multiplier = 1;
	obj_manager.hits = 0;
}

function confirm_delivery(_tip_multiplier, _success){
	// True = successful delivery, False = failed delivery
	// Collected tips (base tip of 50 multiplied by health multiplier)
	if _success {
		obj_manager.collected_tips += global.base_tip*_tip_multiplier;
	}
            
    // Increment delivered package count.
    obj_manager.delivered_packages += 1;
}

function reset_tip_multiplier(){
    // Reset for the next delivery: Restore parcel health to 100%.
    obj_manager.tip_multiplier = 1;
}