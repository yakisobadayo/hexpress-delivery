grav = 0.26;
y_velocity = 0;
grounded    = false;  // is it on the floor?
landed      = false;  // has it already landed? (one-shot guard)

// Default package sprite
if (hits <= 0) {
	image_index = 3;
} else {
	image_index = 0;
}

// Height parcel was spawned from
drop_y = y;
high_drop = drop_y < room_height/2;

// Register if house exists
house = instance_nearest(x, y, obj_house);


// FUNCTIONS
// Returns damage multiplier based on hit count
function get_hit_multiplier() {
    switch (hits) {
        case 4: return 1.00;
        case 3: return 0.80;
        case 2: return 0.55;
        case 1: return 0.30;
        default: return 0.00;
    }
}

// Returns distance multiplier based on proximity to house
/// @func get_dist_multiplier([_mode])
/// @param _mode   If `"type"`, returns a descriptive string; otherwise returns the numeric multiplier.
/// @returns       Number (multiplier) or String (tier name)
function get_dist_multiplier(_mode)
{
    // Figure out which tier we’re in
    var mult, tier;
    
    // 1) Within porch bounds
    if (bbox_left >= house.porch.bbox_left && bbox_right <= house.porch.bbox_right) {
        mult = 1.50; tier = "Full Porch";
    }
    // 2) Partially within porch bounds
    else if (bbox_left < house.porch.bbox_right && bbox_right > house.porch.bbox_left) {
        mult = 1.00; tier = "Partial Porch";
    }
    // 3) Within house bounds
    else if (bbox_left >= house.bbox_left && bbox_right <= house.bbox_right) {
        mult = 0.75; tier = "Outside Porch";
    }
    // 4) Partially within house bounds
    else if (bbox_left < house.bbox_right && bbox_right > house.bbox_left) {
        mult = 0.50; tier = "Partial House";
    }
    // 5) Outside
    else {
        mult = 0.00; tier = "Miss";
    }

    // If caller asked for a string, give them the tier name
    if (argument_count > 0 && string(_mode) == "type") {
        return tier;
    }
    // Outside house bounds
    return mult;
}