missile_timer -= global.gamespeed;

// Spawn projectiles when timer runs out or on key press
if (missile_timer <= 0)
{
	var random_height = irandom_range(32+32, room_height-32)
	instance_create_layer(room_width, random_height, "Instances", obj_bird);
	instance_create_layer(room_width+16, random_height-16, "Instances", obj_bird);
	instance_create_layer(room_width+16+16, random_height-16-16, "Instances", obj_bird);
	missile_timer = 150 * spacing_modifier;
}