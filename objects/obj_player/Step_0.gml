// obj_player: Step Event

// Check if space is held down for boosting
booster = keyboard_check(vk_space) && !stunned;

// Adjust vertical velocity based on booster state
if (booster) {
    y_velocity -= grav;  // move upward
} else {
    y_velocity += grav;  // apply gravity
}

// Check collision state
var isColliding = place_meeting(x, y, obj_collide) || place_meeting(x, y, obj_kill);

// Vertical collision handling
if (place_meeting(x, y+y_velocity, obj_collide) && !isColliding) {
	while !place_meeting(x, y+sign(y_velocity), obj_collide) // Sign will check upward and downward collision
	{
		y += sign(y_velocity); // Moves player as close to floor as possible
	}
	y_velocity = 0;
}

// Boundary collision handling
if (place_meeting(x, y+y_velocity, obj_boundary)) {
	while !place_meeting(x, y+sign(y_velocity), obj_boundary) // Sign will check upward and downward collision
	{
		y += sign(y_velocity); // Moves player as close to floor as possible
	}
	y_velocity = 0;
}

// CRASH!
if (isColliding) {
    if (!colliding && !stunned) {
		get_hit();
    }
    colliding = true;
}
else {
    colliding = false;
}

// Update the player's vertical position
y += y_velocity;

if (keyboard_check_pressed(vk_down)) {
	instance_create_layer(x, y, "Instances", obj_parcel);
}

/*/ Drop parcel
if (instance_exists(obj_house)) {
    var house = instance_nearest(x, y, obj_house);
    if (x >= house.bbox_left+64 && x <= house.bbox_right) {
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