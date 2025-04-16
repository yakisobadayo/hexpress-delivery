obstacle_timer -= global.gamespeed;
collectable_timer -= global.gamespeed;
missile_timer -= global.gamespeed;
section_timer -= global.gamespeed;

// Change sections
if (section_timer <= 0) {
	if global.current_obstacle_type == obj_obstacle || global.current_obstacle_type == obj_obstaclediagonal || global.current_obstacle_type == obj_obstaclevert
	{
		// Destroy the obstacle manager
	    if (instance_exists(obj_obstacle_manager)) {
	         instance_destroy(obj_obstacle_manager);
	    }
	}
	else
	{
	    // Destroy the current condition manager
	    if (instance_exists(global.current_obstacle_type)) {
	         instance_destroy(global.current_obstacle_type);
	    }
	}
	
	if (currentdelivery < global.routelength)
	{
		// Spawn house
		instance_create_layer(room_width, 352, "BackgroundObjects", obj_house);
		
		// Increment current delivery
		currentdelivery += 1;
		
		// Choose a new obstacle manager type at random
		var index = irandom(array_length(global.obstacle_types) - 1);
		global.current_obstacle_type = global.obstacle_types[index];
	
		// Check if condition is under the great obstacle tree
		if global.current_obstacle_type == obj_obstacle || global.current_obstacle_type == obj_obstaclediagonal || global.current_obstacle_type == obj_obstaclevert
		{
			instance_create_layer(0, 0, "Instances", obj_obstacle_manager);
		}
		else
		{
			var condition_instance = instance_create_layer(0, 0, "Instances", global.current_obstacle_type);
		}
	
	    // Reset the section timer for the next section
	    section_timer = 5000;
	}
}



// DEBUG CODE: Cycle obstacle types when Enter is pressed.
#region
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
#endregion

// Exit to menu
if (keyboard_check_pressed(vk_escape)) {
    room_goto(room_menu);
}
