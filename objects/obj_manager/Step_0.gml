obstacle_timer -= global.gamespeed;
collectable_timer -= global.gamespeed;
missile_timer -= global.gamespeed;
section_timer -= global.gamespeed;

// Change sections
if (section_timer <= 0 && route_active) {
    // 1) Tear down the old manager
    if (global.current_obstacle_type == obj_obstacle 
     || global.current_obstacle_type == obj_obstaclediagonal 
     || global.current_obstacle_type == obj_obstaclevert)
    {
        if (instance_exists(obj_obstacle_manager))
            instance_destroy(obj_obstacle_manager);
    }
    else {
        if (instance_exists(global.current_obstacle_type))
            instance_destroy(global.current_obstacle_type);
    }

    // 2) Spawn the house and bump the counter
    instance_create_layer(room_width, 352, "BackgroundObjects", obj_house);
    currentdelivery += 1;

    // 3) Check “are we done?”
    if (currentdelivery >= global.routelength) {
        // → ROUTE FINISHED!  
        route_active = false;          // stop further section logic
        show_results();                // call your end‐of‐route logic
    }
    else {
        // → KEEP GOING: pick next obstacle, spawn manager, reset timer
        var idx = irandom(array_length(global.obstacle_types)-1);
        global.current_obstacle_type = global.obstacle_types[idx];

        if (global.current_obstacle_type == obj_obstacle 
         || global.current_obstacle_type == obj_obstaclediagonal 
         || global.current_obstacle_type == obj_obstaclevert)
        {
            instance_create_layer(0, 0, "Instances", obj_obstacle_manager);
        }
        else {
            instance_create_layer(0, 0, "Instances", global.current_obstacle_type);
        }

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