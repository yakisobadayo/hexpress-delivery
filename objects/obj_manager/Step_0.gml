// Ticking
section_timer_ticking -= global.gamespeed;

// Change sections (with for loop)
if (section_timer_ticking <= 0) {
	// Clean up all old managers
	layer_destroy_instances("Managers");

	// Spawn the house and bump the counter
	instance_create_layer(room_width, 352, "BackgroundObjects", obj_house);
	currentsection += 1;
	
	if (currentsection >= global.routelength) {
		// Generate the condition definition(s) for the NEXT section
		global.current_section_conditions = roll_section();

		// Spawn the corresponding manager(s) for the new section on the "Managers" layer
		spawn_managers(global.current_section_conditions)
	
		// Reset the section timer
		section_timer_ticking = section_timer;
	}
}

if (route_active && global.deliveredpackages >= global.routelength) {
	// → ROUTE FINISHED!
	global.money += global.collected_tips;
	//global.collected_tips = 0;
	route_active = false;
}



// DEBUG CODE: Cycle obstacle types when Enter is pressed.
#region
/*
if (keyboard_check_pressed(vk_enter))
{
    // Find the current index in the obstacle_types array.
    var currentIndex = 0;
    for (var i = 0; i < array_length(global.obstacle_types); i++)
    {
        if (global.obstacle_types[i] == global.current_obstacle_type)
        {
            currentIndex = i;
            break;
        }
    }
    
    // Calculate the next index (wrap-around if necessary).
    var nextIndex = currentIndex + 1;
    if (nextIndex >= array_length(global.obstacle_types))
    {
        nextIndex = 0;
    }
    
    // Destroy the current manager depending on what type is active.
    if (global.current_obstacle_type == obj_obstacle ||
        global.current_obstacle_type == obj_obstaclediagonal ||
        global.current_obstacle_type == obj_obstaclevert)
    {
        // Destroy the obstacle manager if it exists.
        if (instance_exists(obj_obstacle_manager))
        {
            instance_destroy(obj_obstacle_manager);
        }
    }
    else
    {
        // Otherwise destroy the condition manager.
        if (instance_exists(global.current_obstacle_type))
        {
            instance_destroy(global.current_obstacle_type);
        }
    }
    
    // Set the new obstacle type by cycling through the array.
    global.current_obstacle_type = global.obstacle_types[nextIndex];
    
    // Spawn the new manager based on the type.
    if (global.current_obstacle_type == obj_obstacle ||
        global.current_obstacle_type == obj_obstaclediagonal ||
        global.current_obstacle_type == obj_obstaclevert)
    {
        // If it’s an obstacle type, create the obstacle manager.
        instance_create_layer(0, 0, "Instances", obj_obstacle_manager);
    }
    else
    {
        // Otherwise, create the condition manager (or equivalent).
        instance_create_layer(0, 0, "Instances", global.current_obstacle_type);
    }
    
    // Output a debug message.
    show_debug_message("Switched to obstacle type index " + string(nextIndex));
}
*/
#endregion

// Exit to menu
if (keyboard_check_pressed(vk_escape)) {
	global.collected_tips = 0; // Temporary maybe?
    room_goto(room_menu);
}