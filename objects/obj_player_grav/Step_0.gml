// obj_player: Step Event
gravity = grav;

// Check if space is held down for boosting
if (keyboard_check(vk_space)) {
    booster = true;
} else {
    booster = false;
}

// Thrust
if (booster) {
	motion_add(90, 0.3);
}

if place_meeting(x, y+vspeed, obj_collide)
{
	while !place_meeting(x, y+sign(vspeed), obj_collide) // Sign will check upward and downward collision
	{
		y += sign(vspeed); // Moves player as close to floor as possible
	}
	gravity = 0;
	speed = 0;
}