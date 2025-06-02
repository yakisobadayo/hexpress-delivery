car_timer -= global.gamespeed;

// Spawn car when timer runs out
if (car_timer <= 0)
{
	if type == "Cars"
	{
		var car = instance_create_layer(room_width, room_height - 32, "Instances", obj_car);
	}
	
	if type == "Witches"
	{
		var car = instance_create_layer(room_width, 32+irandom(4), "Instances", obj_witch);
	}
	car.scroll_speed = irandom_range(1,3);
	car_timer = irandom_range(150,450) * spacing_modifier;
}