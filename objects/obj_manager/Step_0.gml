obstacle_timer -= global.gamespeed;
collectable_timer -= global.gamespeed;
missile_timer -= global.gamespeed;
section_timer -= global.gamespeed;

/*/ Timer triggered for collectibles when obstacle_timer hits a specific value
if (obstacle_timer <= 50 && obstacle_timer + global.gamespeed > 50) {
	instance_create_layer(room_width, random(room_height), "Instances", obj_collectible);
}
/*/

// Spawn obstacles when timer runs out
if (obstacle_timer <= 0)
{
	// Spawn the obstacle using the current type.
    instance_create_layer(room_width, irandom_range(32, room_height-32), "Instances", global.current_obstacle_type);
	
	// Reset the timer (this value represents a "distance" rather than fixed time)
	obstacle_timer = 100 * spacing_modifier;
}

// Spawn projectiles when timer runs out or on key press
if (missile_timer <= 0 || keyboard_check_pressed(vk_enter))
{
	instance_create_layer(room_width, irandom_range(32, room_height-32), "Instances", obj_projectile);
	if (missile_timer <= 0) {
		missile_timer = 500 * spacing_modifier;
	}
}

// Change sections
if (section_timer <= 0) {
    // Switch to a new obstacle type.
    var index = irandom(array_length(global.obstacle_types) - 1);
    global.current_obstacle_type = global.obstacle_types[index];
    // Reset section timer for the next section.
    section_timer = 1000 * spacing_modifier;
}