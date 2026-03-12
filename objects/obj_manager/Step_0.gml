//ROUTE LOGIC
switch (game_state)
{
    // ────────────
    case GameState.PENDING:
		if (keyboard_check(vk_space)) {
		    global.space_pressed = true;
		}
		
        // Waiting to start
        if (global.space_pressed) {
			show_debug_message("Route started!")
            spawn_managers(current_conditions);
            game_state = GameState.ACTIVE;
			audio_play_sound(mus_route_3_loop_real, 25, true, music_volume);
        }
        break;

    // ────────────
    case GameState.ACTIVE:
        // Section ticking
        section_timer_ticking -= global.gamespeed;
		
		// Gradual depletion of stamina
		stamina -= 0.0075;
		
		// Coffee for first time stamina dips below 33
		if (stamina <= 33 && !first_coffee) {
			if (!first_coffee) first_coffee = true;
		    alarm_set(2, 5 * room_speed);
			show_debug_message("Spawning first coffee...");
		}
		
		// Random spawn ticking
		obstacle_spawn_cooldown = max(obstacle_spawn_cooldown-1, 0);
		coffee_spawn_cooldown = max(coffee_spawn_cooldown-1, 0);
		
		// Deletes and rerolls conditions
        while (section_timer_ticking <= 0)
        {
            layer_destroy_instances("Managers");
            house_spawn();

            current_conditions = roll_section();
            spawn_managers(current_conditions);

            section_timer_ticking += section_timer;
        }

        // 2) Check for route completion
        if (stamina <= 0)
        {
			var total_payout = collected_base_pay + collected_tips;
			layer_destroy_instances("Managers");
            global.money += total_payout;
			show_debug_message(string("Route ended! Earned: ${0}, total money: ${1}", total_payout, global.money));
			
			alarm_set(1, end_timer); // Cooldown before results sbow
			audio_sound_gain(mus_route_3_loop_real, 0.45, 3000)
            game_state = GameState.FINISHED;
        }
		
		// Spawn a coffee randomly
		var coffee_chance_per_frame = 0.0005;  // ~1 spawn every 2000 frames on average

		if (coffee_spawn_cooldown == 0 && stamina <= 66 && random(1) < coffee_chance_per_frame && !instance_exists(obj_coffee)) {
		    spawn_coffee()
			
			coffee_spawn_cooldown = coffee_reset_cooldown;
		}
		
		// Random floor/ceiling obstacles
		var obstacle_chance_per_frame = 0.001;  // ~1 spawn every 500 frames on average
		if (current_section > 0 && obstacle_spawn_cooldown == 0) {
			if (!instance_exists(obj_car) && !instance_exists(obj_witch)) {
			    if (random(1) < obstacle_chance_per_frame) {
			        with (obj_player) {
			            if (y < room_height / 2) {
			                // Player is in the upper half -> spawn witch at ceiling
			                var car = instance_create_layer(room_width, 32+irandom(4), "Instances", obj_witch);
			            } else {
			                // Player is in the lower half -> spawn car on the floor
			                var car = instance_create_layer(room_width, room_height - 32, "Instances", obj_car);
			            }
						car.scroll_speed = irandom_range(1,3);
			        }
					
					obstacle_spawn_cooldown = obstacle_reset_cooldown;
			    }
			}
		}
        break;

    // ────────────
    case GameState.FINISHED:
        // Show “Run Complete” screen, then Space → results
        if (keyboard_check_pressed(vk_space))
        {
            //room_goto(room_results);
        }
        break;
}

/// MONEY INCREMENT
/// Smooth-increment the visual total
if (displayed_money < target_money) {

    var step = min(money_step, target_money - displayed_money);
    displayed_money += step;

} else if (audio_is_playing(snd_increment)) {
    // reached the target – kill the tune
    audio_stop_sound(snd_increment);
}


/*/ Change sections (with for loop)
while (section_timer_ticking <= 0) {
	// Clean up all old managers
	layer_destroy_instances("Managers");
	house_spawn();
	
	if (current_section >= route_length) {		
		break;
	} else {
		// Generate the condition definition(s) for the NEXT section
		current_conditions = roll_section();

		// Spawn the corresponding manager(s) for the new section on the "Managers" layer
		spawn_managers(current_conditions)
	
		// Reset the section timer
		section_timer_ticking = section_timer;
	}
}

if (route_active && delivered_parcels >= route_length) {
	// → ROUTE FINISHED!
	global.money += collected_tips;
	//global.collected_tips = 0;
	route_active = false;
}
/*/

// Exit to menu
if (keyboard_check_pressed(vk_escape)) {
	//collected_tips = 0; // Temporary maybe?
	audio_stop_sound(mus_route_3_loop_real);
    room_goto(room_menu);
}

// Fullscreen mode
if (keyboard_check_pressed(vk_f11)) {
    window_set_fullscreen(!window_get_fullscreen());
}