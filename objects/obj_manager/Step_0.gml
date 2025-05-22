//ROUTE LOGIC
switch (game_state)
{
    // ────────────
    case GameState.PENDING:
        // Waiting to start
        if (keyboard_check_pressed(vk_space))
        {
			show_debug_message("Route started!")
            spawn_managers(current_conditions);
            game_state = GameState.ACTIVE;
        }
        break;

    // ────────────
    case GameState.ACTIVE:
        // Section ticking
        section_timer_ticking -= global.gamespeed;
		
		// Gradual depletion of stamina
		stamina -= 0.005;
		
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
			layer_destroy_instances("Managers");
            global.money += collected_tips;
			show_debug_message(string("Route ended! Earned: ${0}, total money: ${1}", collected_tips, global.money));
            game_state = GameState.FINISHED;
        }

        // 3) Quick exit
        if (keyboard_check_pressed(vk_escape))
        {
            room_goto(room_menu);
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
	collected_tips = 0; // Temporary maybe?
    room_goto(room_menu);
}