car_timer -= global.gamespeed;

// Spawn car when timer runs out
if (car_timer <= 0)
{
	instance_create_layer(room_width, 352, "Instances", obj_car);
	car_timer = irandom_range(150,450) * spacing_modifier;
}