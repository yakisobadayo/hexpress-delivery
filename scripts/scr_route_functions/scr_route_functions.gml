// Initialise money
global.money = 0;
global.base_tip = 50;

function register_hit(_damage){
    obj_manager.hits += _damage;
}

function get_hit() {
	// Get hit
	register_hit(1);
	
    // knockback & stun  
    if (y_velocity < 0) y_velocity = 0;
    stunned = true;
    alarm_set(0, 0.4 * room_speed);

    // choose the sound based on the threshold  
    if (obj_manager.hits >= 5) {
        audio_play_sound(snd_impact_fragile, 10, false, 1, 0, random_range(0.9, 1.1));
    } else {
        audio_play_sound(snd_impact,         10, false, 1, 0, random_range(0.9, 1.1));
    }
}



function confirm_delivery(success){
	// True = successful delivery, False = failed delivery
	// Collected tips (base tip of 50 multiplied by health multiplier)
	if success {
		obj_manager.collected_tips += global.base_tip*obj_manager.tip_multiplier;
	}
            
    // Increment delivered package count.
    obj_manager.deliveredpackages += 1;
	
	// Reset for the next delivery: Restore parcel health to 100%.
    obj_manager.tip_multiplier = 1;
	obj_manager.hits = 0;
}

function reset_tip_multiplier(){
    // Reset for the next delivery: Restore parcel health to 100%.
    obj_manager.tip_multiplier = 1;
}