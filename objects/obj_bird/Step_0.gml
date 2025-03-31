x -= (global.gamespeed + speedmodifier);

if x < -120
{
	instance_destroy(self);
}