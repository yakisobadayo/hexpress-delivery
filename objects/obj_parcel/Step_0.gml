x -= global.gamespeed;

// Adjust vertical velocity
y_velocity += grav;  // apply gravity

// Vertical collision handling
if place_meeting(x, y+y_velocity, obj_collide)
{
	while !place_meeting(x, y+sign(y_velocity), obj_collide) // Sign will check upward and downward collision
	{
		y += sign(y_velocity); // Moves player as close to floor as possible
	}
	y_velocity = 0;
}

// Update the player's vertical position
y += y_velocity;

if x < -120
{
	instance_destroy(self);
}