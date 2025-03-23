if can_hit == true
{
	with other
	{
		instance_destroy();
	}
	global.points += 1;
	instance_destroy();
}