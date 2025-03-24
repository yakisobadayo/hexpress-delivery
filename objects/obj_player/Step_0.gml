// obj_player: Step Event

// Check if space is held down for boosting
if (keyboard_check(vk_space)) {
    booster = true;
} else {
    booster = false;
}

// Adjust vertical velocity based on booster state
if (booster) {
    y_velocity -= grav;  // move upward
} else {
    y_velocity += grav;  // apply gravity
}

// Vertical collision handling
if place_meeting(x, y+y_velocity, obj_collide)
{
	while !place_meeting(x, y+sign(y_velocity), obj_collide) // Sign will check upward and downward collision
	{
		y += sign(y_velocity); // Moves player as close to floor as possible
	}
	y_velocity = 0;
}

// CRASH!
if place_meeting(x, y, obj_collide)
{
    room_restart();
}

// Update the player's vertical position
y += y_velocity;

// Collecting coins
if place_meeting(x, y, obj_collectible)
{
    with instance_place(x, y, obj_collectible)
    {
        instance_destroy()
		global.coins += 1;
    }
}