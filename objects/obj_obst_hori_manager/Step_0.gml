obstacle_timer -= global.gamespeed;

// Spawn obstacles when timer runs out
if (obstacle_timer <= 0)
{
	// Spawn the obstacle using the current type.
    instance_create_layer(room_width, irandom_range(32, room_height-32), "Instances", global.current_obstacle_type);
	
	// Reset the timer (this value represents a "distance" rather than fixed time)
	obstacle_timer = 100 * spacing_modifier;
}