auto_scroll();

// Register if house exists
house = instance_nearest(x, y, obj_house);

// Calculate velocity
y_velocity += grav;

// Particle system to current position
part_system_position(ps_id, (bbox_left+bbox_right)*0.5, bbox_top);

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
				audio_play_sound(snd_impact_fragile, 10, false, 1, 0, random_range(0.9, 1.1));
			} else {
				audio_play_sound(snd_impact,         10, false, 1, 0, random_range(0.9, 1.1));
			}
		}
		
		// Registers if house exists
		if (house != noone) {
			var total_multiplier = get_hit_multiplier() * get_dist_multiplier();
			
			// Massive debug message
			show_debug_message(string("Delivery made, earned ${2} in tips with total_mult: {5}, hit_mult: {0} ({3}/4 hits) and dist_mult: {1} ({4})", get_hit_multiplier(), get_dist_multiplier(), total_multiplier * obj_manager.base_tip, hits, get_dist_multiplier("type"), total_multiplier));
			
			obj_manager.register_delivery(total_multiplier);
			if (get_dist_multiplier() != 0.00)
			{
				house.success = true
				show_debug_message("Successful delivery!");
			}
			
			audio_play_sound(snd_cash, 10, false);
			spawn_circle();
			
			if (total_multiplier >= 1.00) {
				audio_play_sound(snd_ding, 10, false);
				spawn_sparkle();
				if (total_multiplier > 1.00) {
					obj_manager.stamina = min(obj_manager.max_stamina, obj_manager.stamina + 5);
				}
			}
		}
    }
}

y += y_velocity;      // Apply movement
destroy_offscreen();  // Cleanup