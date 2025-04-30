obstacle_timer -= global.gamespeed;
// Spawn obstacles when timer runs out
if (obstacle_timer <= 0)
{
	instance_create_layer(room_width, room_height-32, "Obstacles", obj_riser);
	
	// Reset the timer (this value represents a "distance" rather than fixed time)
	obstacle_timer = 75 * spacing_modifier;
}