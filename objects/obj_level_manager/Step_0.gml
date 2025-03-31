section_timer -= global.gamespeed;

// Change sections
if (section_timer <= 0) {
    // Destroy the current obstacle manager instance
    if (instance_exists(global.current_obstacle_manager)) {
         instance_destroy(global.current_obstacle_manager);
    }
    
    // Choose a new obstacle manager type at random
    var index = irandom(array_length(global.obstacle_types) - 1);
    global.current_obstacle_type = instance_create_layer(0, 0, "Instances", global.obstacle_types[index]);
    
    // Reset the section timer for the next section
    section_timer = 1000 * spacing_modifier;
}