/*/
x -= global.gamespeed;
if x <= 0
{
	instance_create_layer(x+room_width, y, "Instances", obj_cloud_ceiling);
	instance_create_layer(x+room_width+64, y, "Instances", obj_cloud_ceiling);
	instance_destroy(self);
}
/*/