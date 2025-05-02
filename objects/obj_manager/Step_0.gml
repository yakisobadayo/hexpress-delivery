obstacle_timer -= global.gamespeed;
collectable_timer -= global.gamespeed;
missile_timer -= global.gamespeed;
section_timer -= global.gamespeed;

// Change sections
if (section_timer <= 0 && route_active) {
    // 1) Tear down the old manager
    layer_destroy_instances("Managers");

    // 2) Spawn the house and bump the counter
    instance_create_layer(room_width, 352, "BackgroundObjects", obj_house);
    currentdelivery += 1;

    // 3) Check “are we done?”
    if (currentdelivery >= global.routelength) {
        // → ROUTE FINISHED!  
        route_active = false;          // stop further section logic
    }
    else {
        // → KEEP GOING: pick next obstacle, spawn manager, reset timer
        randomize_obstacles();
        spawn_manager();

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
    layer_destroy_instances("Managers");
    
    // Set the new obstacle type by cycling through the array.
    global.current_obstacle_type = global.obstacle_types[nextIndex];
    
    // Spawn the new manager based on the type.
    spawn_manager();
    
    // Output a debug message.
    show_debug_message("Switched to obstacle type index " + string(nextIndex));
}
#endregion

if (global.deliveredpackages >= global.routelength && !over) {
	calculate_tips();
    over = true;
}

// Exit to menu
if (keyboard_check_pressed(vk_escape)) {
    room_goto(room_menu);
}