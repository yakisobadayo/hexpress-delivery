/*/
x -= global.gamespeed;
if x <= -32
{
	instance_create_layer(x+room_width, y, "Instances", obj_ground);
	instance_create_layer(x+room_width, y, "Instances", obj_ground);
	instance_destroy(self);
}
/*/

/*/ Keep this for weird shattered world condition?
if x <= 0
{
	instance_create_layer(x+room_width, irandom_range(32, room_height-32), "Instances", obj_ground);
	instance_destroy(self);
}
/*/