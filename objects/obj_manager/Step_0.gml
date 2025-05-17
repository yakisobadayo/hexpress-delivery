//ROUTE LOGIC
switch (game_state)
{
    // ────────────
    case GameState.PENDING:
        // Waiting to start
        if (keyboard_check_pressed(vk_space))
        {
            spawn_managers(current_conditions);
            game_state = GameState.ACTIVE;
        }
        break;

    // ────────────
    case GameState.ACTIVE:
        // 1) Section scrolling & respawn logic
        section_timer_ticking -= global.gamespeed;
		
        while (section_timer_ticking <= 0)
        {
            layer_destroy_instances("Managers");
            house_spawn();

            if (current_section < route_length)
            {
                current_conditions = roll_section();
                spawn_managers(current_conditions);
            }

            section_timer_ticking += section_timer;
        }

        // 2) Check for route completion
        if (delivered_parcels >= route_length || houses_passed >= route_length)
        {
            global.money += collected_tips;
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