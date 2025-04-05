x -= global.gamespeed;
y -= risespeed;

if x < -120 || y < -64
{
	instance_destroy(self);
}