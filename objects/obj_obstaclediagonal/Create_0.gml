var random_chance = irandom(100);
if random_chance > 50
{
	image_yscale = 1;
}
else
{
	image_yscale = -1;
}

//if y < room_height/2 {
	if random_chance > 50 {
		image_index = 0;
	} else {
		image_index = 1;
	}
/*/} else {
	if random_chance > 50 {
		image_index = 0;
	} else {
		image_index = 1;
	}
}