auto_scroll();

// Check if in house bounds
var in_house_bounds = instance_exists(obj_house) && bbox_left >= obj_house.bbox_left && bbox_right <= obj_house.bbox_right;

// Calculate velocity
y_velocity += grav;

if place_meeting(x, y + y_velocity, obj_boundary) {
    // push up until flush with the floor
    while !place_meeting(x, y + sign(y_velocity), obj_boundary) {
        y += sign(y_velocity);
    }
    y_velocity = 0;
    grounded    = true;    // checks if on ground

    // 2) one-shot landing logic
    if (!landed) {
        landed = true;
		confirm_delivery(in_house_bounds);
    }
}


y += y_velocity;      // Apply movement
destroy_offscreen();  // Cleanup