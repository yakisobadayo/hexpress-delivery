// Ticking
section_timer_ticking -= global.gamespeed;

// Change sections (with for loop)
while (section_timer_ticking <= 0) {
	// Clean up all old managers
	layer_destroy_instances("Managers");
	
	if (currentsection >= routelength) {		
		break;
	} else {
		// Spawn the house and bump the counter
		currentsection += 1;
		instance_create_layer(room_width, 352, "BackgroundObjects", obj_house);
		if (currentsection >= routelength) break;
		
		// Generate the condition definition(s) for the NEXT section
		current_section_conditions = roll_section();

		// Spawn the corresponding manager(s) for the new section on the "Managers" layer
		spawn_managers(current_section_conditions)
	
		// Reset the section timer
		section_timer_ticking = section_timer;
	}
}

if (route_active && deliveredpackages >= routelength) {
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