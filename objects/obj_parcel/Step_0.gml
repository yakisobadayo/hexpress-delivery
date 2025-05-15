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
		
		if (house != noone) {
			if (in_house_bounds && house.state == HouseState.PENDING) {
                house.state = HouseState.DELIVERED;
                house.manager.dropoffs[house.slot] = HouseState.DELIVERED;
            }
		}
    }
}


y += y_velocity;      // Apply movement
destroy_offscreen();  // Cleanup