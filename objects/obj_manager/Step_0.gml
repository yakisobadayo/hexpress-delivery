spawn_timer -= 1;

// Timer triggered
if spawn_timer <= 0
{
	instance_create_layer(room_width, random(room_height), "Instances", obj_enemy);
	instance_create_layer(room_width, random(room_height), "Instances", obj_collectible);
	spawn_timer = 100
}