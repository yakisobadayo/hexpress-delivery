// obj_player: Step Event
var trigger_boost = keyboard_check(vk_space) || mouse_check_button(mb_left);
var trigger_drop = keyboard_check_pressed(vk_down) || mouse_check_button_pressed(mb_right);

// Check if space is held down for boosting
booster = trigger_boost && !stunned;

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

// Check if in house bounds
in_house_bounds = instance_exists(obj_house) && x-8 >= obj_house.bbox_left && x+8 <= obj_house.bbox_right;

// Drop parcel
if (trigger_drop) {
	obj_manager.drop_parcel(x, y);
}