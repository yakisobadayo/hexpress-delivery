section_timer -= global.gamespeed;

// Change sections
if (section_timer <= 0) {
	if global.current_condition == obj_obstacle || global.current_condition == obj_obstaclediagonal || global.current_condition == obj_obstaclevert
	{
		// Destroy the obstacle manager
	    if (instance_exists(obj_obstacle_manager)) {
	         instance_destroy(obj_obstacle_manager);
	    }
	}
	else
	{
	    // Destroy the current condition manager
	    if (instance_exists(global.current_condition)) {
	         instance_destroy(global.current_condition);
	    }
	}
	
	// Choose a new obstacle manager type at random
	var index = irandom(array_length(global.conditions) - 1);
	global.current_condition = global.conditions[index];
	
	// Check if condition is under the great obstacle tree
	if global.current_condition == obj_obstacle
	{
		var condition_instance = instance_create_layer(0, 0, "Instances", obj_obstacle_manager);
		condition_instance.state = "Horizontal";
	}
	else if global.current_condition == obj_obstaclediagonal
	{
		var condition_instance = instance_create_layer(0, 0, "Instances", obj_obstacle_manager);
		condition_instance.state = "Diagonal";
	}
	else if global.current_condition == obj_obstaclevert
	{
		var condition_instance = instance_create_layer(0, 0, "Instances", obj_obstacle_manager);
		condition_instance.state = "Vertical";
	}
	else
	{
		var condition_instance = instance_create_layer(0, 0, "Instances", global.current_condition);
	}
    // Reset the section timer for the next section
    section_timer = 1000 * spacing_modifier;
}