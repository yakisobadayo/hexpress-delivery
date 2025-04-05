obstacle_timer -= global.gamespeed;
collectable_timer -= global.gamespeed;
missile_timer -= global.gamespeed;
section_timer -= global.gamespeed;

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
    section_timer = 1000 * spacing_modifier;
}

// Change sections
if (section_timer <= 0) {
    // Switch to a new obstacle type.
    var index = irandom(array_length(global.obstacle_types) - 1);
    global.current_obstacle_type = global.obstacle_types[index];
    // Reset section timer for the next section.
    section_timer = 1000 * spacing_modifier;
}