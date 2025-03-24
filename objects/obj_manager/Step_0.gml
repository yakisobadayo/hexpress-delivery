spawn_timer -= 1;
missile_timer -= 1;

// Timer triggered
if spawn_timer = 50
{
	instance_create_layer(room_width, random(room_height), "Instances", obj_collectible);
}

if spawn_timer <= 0
{
	instance_create_layer(room_width, random(room_height), "Instances", obj_flying);
	spawn_timer = 100;
}

if missile_timer <= 0 || keyboard_check_pressed(vk_enter)
{
	instance_create_layer(room_width, random(room_height), "Instances", obj_projectile);
	if missile_timer <= 0 {
		missile_timer = 1000;
	}
}