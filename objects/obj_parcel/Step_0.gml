auto_scroll();

// Register if house exists
house = instance_nearest(x, y, obj_house);

// Calculate velocity
y_velocity += grav;

// Calculate collision
if place_meeting(x, y + y_velocity, obj_boundary) {
    // push up until flush with the floor
    while !place_meeting(x, y + sign(y_velocity), obj_boundary) {
        y += sign(y_velocity);
    }
    y_velocity = 0;
    grounded    = true;    // checks if on ground

    // Trigger delivery event once
    if (!landed) {
        landed = true;
		
		// Damage from high-altitude drop
		if (high_drop) {
			hits = max(0, hits - 1);
			show_debug_message("Parcel fell from too high up (-1 hit)")
			
			// Play sound (fragile if package is at 0)
			if hits <= 0 {
				image_index = 3;
				audio_play_sound(snd_impact_fragile, 10, false, 1, 0, random_range(0.9, 1.1));
			} else {
				image_index = irandom_range(1, 2);
				audio_play_sound(snd_impact,         10, false, 1, 0, random_range(0.9, 1.1));
			}
		}
		
		// Registers if house exists
		if (house != noone) {
			var total_payout = global.base_tip * get_hit_multiplier() * get_dist_multiplier();
			obj_manager.register_delivery(total_payout);

			// Debug message
			show_debug_message(string("Delivery made, earned ${2} with hit_mult: {0} ({3}/4 hits) and dist_mult: {1} ({4})", get_hit_multiplier(), get_dist_multiplier(), total_payout, hits, get_dist_multiplier("type")));
		}
    }
}

y += y_velocity;      // Apply movement
destroy_offscreen();  // Cleanup