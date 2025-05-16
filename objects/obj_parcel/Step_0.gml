auto_scroll();

// Register if house exists
var house = instance_nearest(x, y, obj_house);

// Check if in house bounds
var in_house_bounds = false;
if (house != noone) {
    in_house_bounds =
        (bbox_left  >= house.bbox_left) &&
        (bbox_right <= house.bbox_right);
}

// Calculate velocity
y_velocity += grav;

// Calculate collision
if place_meeting(x, y + y_velocity, obj_boundary) {
    // push up until flush with the floor
    while !place_meeting(x, y + sign(y_velocity), obj_boundary) {
        y += sign(y_velocity);
    }
    y_velocity = 0;
    grounded    = true;    // checks if on ground

    // Trigger delivery event once
    if (!landed) {
        landed = true;
		obj_manager.collected_tips += global.base_tip*dmg_mult;
    }
}

y += y_velocity;      // Apply movement
destroy_offscreen();  // Cleanup