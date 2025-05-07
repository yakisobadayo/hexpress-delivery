// Initialise money
global.money = 0;
global.base_tip = 50;

function register_hit(_damage){
    if (instance_exists(global.Manager))
    {
        global.Manager.hits += _damage;
    }
}

function get_hit() {
	// Get hit
	register_hit(1);
	
    // 1) knockback & stun  
    if (y_velocity < 0) y_velocity = 0;
    stunned = true;
    alarm_set(0, 0.4 * room_speed);

    // 2) grab the real hit count from your manager  
    var hitCount = 0;
    if (instance_exists(global.Manager)) {
        hitCount = global.Manager.hits;
    }

    // 3) choose the sound based on the threshold  
    if (hitCount >= 5) {
        audio_play_sound(snd_impact_fragile, 10, false, 1, 0, random_range(0.9, 1.1));
    } else {
        audio_play_sound(snd_impact,         10, false, 1, 0, random_range(0.9, 1.1));
    }
}



function deliver_parcel(){
	// Collected tips (base tip of 50 multiplied by health multiplier)
	global.collected_tips += global.base_tip*global.tip_multiplier;
            
    // Increment delivered package count.
    global.deliveredpackages += 1;
	
	// Reset for the next delivery: Restore parcel health to 100%.
    global.tip_multiplier = 1;
	global.hits = 0;
}

function reset_tip_multiplier(){
    // Reset for the next delivery: Restore parcel health to 100%.
    global.tip_multiplier = 1;
}