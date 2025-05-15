// Ticking
section_timer_ticking -= global.gamespeed;

// Change sections (with for loop)
while (section_timer_ticking <= 0) {
	// Clean up all old managers
	layer_destroy_instances("Managers");
	spawn_house()
	
	if (current_dropoff >= route_length) {		
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

if (route_active && delivered_packages >= route_length) {
	// → ROUTE FINISHED!
	global.money += collected_tips;
	//global.collected_tips = 0;
	route_active = false;
}

// Exit to menu
if (keyboard_check_pressed(vk_escape)) {
	collected_tips = 0; // Temporary maybe?
    room_goto(room_menu);
}