// obj_player: Step Event

// 1. Input & gravity/boost
if (!stunned) {
    if (keyboard_check(vk_space)) {
        booster = true;
        y_velocity -= grav;
    } else {
        booster = false;
        y_velocity += grav;
    }
} else {
    booster = false;
    y_velocity += grav;
}

// 2. Collision checks (only when not stunned)
if (!stunned) {
    var _vel_y = y_velocity;

    // 1) obj_kill always hurts
    if (place_meeting(x, y + _vel_y, obj_kill)) {
        show_debug_message("Hit KILL!");
        trigger_hit();
        _vel_y = 0;
    }
    // 2) Safe landing: moving DOWN and the pixel just below us is solid
    else if (_vel_y > 0 && place_meeting(x, y + 1, obj_collide)) {
        show_debug_message("Safe landing on top of collide!");
        // Slide down until just above the surface
        while (!place_meeting(x, y + 1, obj_collide)) {
            y += 1;
        }
        _vel_y = 0;
        y_velocity = 0;
    }
    // 3) Any other collide contact is a hit
    else if (place_meeting(x, y + _vel_y, obj_collide)) {
        show_debug_message("Side/bottom or upward collide — HIT!");
        trigger_hit();
        _vel_y = 0;
    }

    y_velocity = _vel_y;
}

// 3. Apply movement
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
			
			// Record the delivered parcel's health
            array_push(global.parcel_scores, global.current_parcel_health);
            
            // Increment delivered package count.
            global.deliveredpackages += 1;
            
            // Reset for the next delivery: Restore parcel health to 100%.
            global.current_parcel_health = 1;
        }
    } else {
        in_house_bounds = false;
    }
}