missile_timer -= global.gamespeed;

// Spawn projectiles when timer runs out or on key press
if (missile_timer > 0)
{
	if aim > obj_player.y
	{
		aim -= 1;
	}
	else
	{
		aim += 1;
	}
}

if (missile_timer <= 0)
{
	var random_height = irandom_range(32+32, room_height-32)
	instance_create_layer(room_width, aim, "Obstacles", obj_bird);
	instance_create_layer(room_width+16, aim-16, "Obstacles", obj_bird);
	instance_create_layer(room_width+16+16, aim-16-16, "Obstacles", obj_bird);
	missile_timer = 150 * spacing_modifier;
	aim = obj_player.y;
}