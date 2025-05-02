obstacle_timer -= global.gamespeed;
// Spawn obstacles when timer runs out
if (obstacle_timer <= 0)
{
	if global.current_obstacle_type == obj_obstacle
	{
		instance_create_layer(room_width, irandom_range(32, room_height-32), "Instances", obj_obstacle);
	}
	
	if global.current_obstacle_type == obj_obstaclediagonal
	{
		instance_create_layer(room_width, irandom_range(32, room_height-32), "Instances", obj_obstaclediagonal);
	}
	
	if global.current_obstacle_type == obj_obstaclevert
	{
		instance_create_layer(room_width, irandom_range(32, room_height-32), "Instances", obj_obstaclevert);
	}
	
	// Reset the timer (this value represents a "distance" rather than fixed time)
	obstacle_timer = 100 * spacing_modifier;
}