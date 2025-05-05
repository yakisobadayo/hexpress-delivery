// obj_player: Step Event

// Check if space is held down for boosting
if !stunned {
	if (keyboard_check(vk_space)) {
	    booster = true;
	} else {
	    booster = false;
	}
} else {
	booster = false;
}

// Adjust vertical velocity based on booster state
if (booster) {
    y_velocity -= grav;  // move upward
} else {
    y_velocity += grav;  // apply gravity
}

// Check collision state
var isColliding = place_meeting(x, y, obj_collide) || place_meeting(x, y, obj_kill);

// Vertical collision handling
if place_meeting(x, y+y_velocity, obj_collide) && !isColliding
{
	while !place_meeting(x, y+sign(y_velocity), obj_collide) // Sign will check upward and downward collision
	{
		y += sign(y_velocity); // Moves player as close to floor as possible
	}
	y_velocity = 0;
}

// Boundary collision handling
if place_meeting(x, y+y_velocity, obj_boundary)
{
	while !place_meeting(x, y+sign(y_velocity), obj_boundary) // Sign will check upward and downward collision
	{
		y += sign(y_velocity); // Moves player as close to floor as possible
	}
	y_velocity = 0;
}

// CRASH!
if (isColliding)
{
    // Only trigger stun when collision state just began.
    if (!colliding && !stunned)
    {
        if (y_velocity < 0)
        {
            y_velocity = 0;
        }
        stunned = true;
        alarm_set(0, 0.4 * room_speed); // Triggers stun duration
		
		// Package damage, decrease tip multiplier by 10%
        global.tip_multiplier -= 0.1;
        // Optionally clamp it so it doesn't drop below zero:
        if (global.tip_multiplier < 0)
            global.tip_multiplier = 0;
			
		// Play sound
		audio_play_sound(snd_impact, 10, false, 1, 0, random_range(0.9, 1.1));
    }
    
    // Mark that we are colliding this frame.
    colliding = true;
}
else
{
    // Reset the collision flag when not colliding.
    colliding = false;
}

// Update the player's vertical position
y += y_velocity;

/*/ Collecting coins
if place_meeting(x, y, obj_collectible)
{
    with instance_place(x, y, obj_collectible)
    {
        instance_destroy()
		global.coins += 1;
    }
}
/*/


// Drop parcel
if (instance_exists(obj_house)) {
    var house = instance_nearest(x, y, obj_house);
    if (x >= house.bbox_left+32 && x <= house.bbox_right) {
        if (!in_house_bounds) {
            in_house_bounds = true;
            // Spawn parcel object
            instance_create_layer(x, y, "Instances", obj_parcel);
			
			// Deliver
			deliver_parcel();
        }
    } else {
        in_house_bounds = false;
    }
}