// obj_player: Step Event
var trigger_boost = keyboard_check(vk_space) || mouse_check_button(mb_left);
var trigger_drop = keyboard_check_pressed(vk_down) || mouse_check_button_pressed(mb_right);

// Register if house exists
house = instance_nearest(x, y, obj_house);

if obj_manager.game_state == GameState.ACTIVE {
	// Check if space is held down for boosting
	booster = trigger_boost && !stunned;
} else {
	booster = false;
}

// Drop only when a house is on screen, and if it's been delivered to
if (house != noone && house.delivered == false && obj_manager.game_state == GameState.ACTIVE) {
	if (trigger_drop) {
		obj_manager.drop_parcel(x, y);
		house.delivered = true
		obj_manager.next_delivery();
	}
}

// Adjust vertical velocity based on booster state
if (booster) {
    // upward thrust gets weaker as stamina drains
    y_velocity -= grav * stamina_mod();
} else {
    // gravity feels stronger as stamina drains
    y_velocity += grav * (2 - stamina_mod());   // 1.0→1.5
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

// Check if on ground
grounded = place_meeting(x, y + 1, obj_boundary);

// CRASH!
if (isColliding) {
    if (!colliding && !i_frame) {
		get_hit();
		// Bounce (car)
		if place_meeting(x, y+y_velocity, obj_car) {
			y_velocity = -6;
		}
    }
    colliding = true;
}
else {
    colliding = false;
}

// Update the player's vertical position
y += y_velocity;

/*/ Check if in house bounds
in_house_bounds = instance_exists(obj_house) && x-8 >= obj_house.bbox_left && x+8 <= obj_house.bbox_right;
/*/

// Set the emitter's region to Willow's position
var _x = bbox_left-6;
var _y = y+9;

part_emitter_region(broom_ps, pemit_broom, _x, _x, _y, _y, ps_shape_rectangle, ps_distr_linear);

// Turn on/off stream based on booster
if (booster)
{
    sparkle_timer -= 1;

    if (sparkle_timer <= 0)
    {
        // burst exactly ONE particle
        part_emitter_burst(broom_ps, pemit_broom, ptype_broom, 1);

        // reset for next burst
        sparkle_timer = sparkle_interval;
        //   – or –  sparkle_timer = irandom_range(3,7)  // slight randomness
    }
}
else
{
    // reset so first frame of next boost spawns instantly
    sparkle_timer = 0;
}