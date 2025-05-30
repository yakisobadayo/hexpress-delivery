obstacle_timer -= global.gamespeed;
// Spawn obstacles when timer runs out
if (obstacle_timer <= 0)
{
	if type == "Horizontal"
	{
		instance_create_layer(room_width, irandom_range(32, room_height-32), "BackgroundObjects", obj_obstaclehori);
	}
	
	if type == "Diagonal"
	{
		instance_create_layer(room_width, irandom_range(32, room_height-32), "BackgroundObjects", obj_obstaclediagonal);
	}
	
	if type == "Vertical"
	{
		instance_create_layer(room_width, irandom_range(32, room_height-32), "BackgroundObjects", obj_obstaclevert);
	}
	
	// Reset the timer (this value represents a "distance" rather than fixed time)
	obstacle_timer = 100 * spacing_modifier;
}