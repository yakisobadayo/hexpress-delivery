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
			if (shield > 0) {
				// Bubble Wrap cushions the fall
				shield -= 1;
				audio_play_sound(snd_boing, 10, false, 0.6, 0, 1.4);
				show_debug_message("Parcel fell from too high up, but Bubble Wrap saved it")
			} else {
				obj_manager.play_hit_sound(hits);
				hits = max(0, hits - 1);
				show_debug_message("Parcel fell from too high up (-1 hit)")
			}
		}
		
		var _popup_x = (bbox_left + bbox_right) * 0.5;
		var _popup_y = bbox_top - 12;
		
		// Registers if house exists
		if (house != noone && get_dist_multiplier() > 0.00) {
			var total_multiplier = get_hit_multiplier() * get_dist_multiplier();
			
			// Massive debug message
			show_debug_message(string("Delivery made, earned ${2} in tips with total_mult: {5}, hit_mult: {0} ({3}/4 hits) and dist_mult: {1} ({4})", get_hit_multiplier(), get_dist_multiplier(), total_multiplier * obj_manager.base_tip, hits, get_dist_multiplier("type"), total_multiplier));
			var _stars  = multiplier_to_stars(total_multiplier);
			obj_manager.register_rating(_stars);
			var _earned = obj_manager.register_delivery(total_multiplier);
			
			// Floating feedback
			var _praise = obj_manager.stars_to_praise(_stars);
			obj_manager.add_popup(_popup_x, _popup_y - 14, _praise.text, _praise.col);
			obj_manager.add_popup(_popup_x, _popup_y, "+$" + string(_earned), #FFE45C);
			house.success = true
			show_debug_message("Successful delivery!");
			show_debug_message("Earned rating of " + string(multiplier_to_stars(total_multiplier)));
			audio_play_sound(snd_cash, 10, false);
			spawn_circle();
			
			if (total_multiplier >= 1.00) {
				audio_play_sound(snd_ding, 10, false);
				spawn_sparkle();
			}
			
			if (get_dist_multiplier() > 1.00) {
				obj_manager.stamina = min(obj_manager.max_stamina, obj_manager.stamina + 15);
				audio_play_sound(snd_restore, 10, false);
			}
		} else {
			if (house != noone) {
				obj_manager.register_rating(0);
				obj_manager.add_popup(_popup_x, _popup_y, "Missed!", #FF6060);
			}
			obj_manager.streak = 0;
			audio_play_sound(snd_place, 10, false,0.8,,0.75);
		}
    }
}

y += y_velocity;      // Apply movement
destroy_offscreen();  // Cleanup