grav = 0.26;
y_velocity = 0;
grounded    = false;  // is it on the floor?
landed      = false;  // has it already landed? (one-shot guard)

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
        case 3: return 0.75;
        case 2: return 0.50;
        case 1: return 0.25;
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
        mult = 0.50; tier = "Outside Porch";
    }
    // 4) Partially within house bounds
    else if (bbox_left < house.bbox_right && bbox_right > house.bbox_left) {
        mult = 0.25; tier = "Partial House";
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


/// Returns 0-5 stars
function multiplier_to_stars(mult)
{
    if (mult >= 1.30) return 5;   // perfect porch + no damage
    if (mult >= 1.00) return 4;   // “A+” delivery
    if (mult >= 0.50) return 3;   // okay
    if (mult >= 0.25) return 2;   // meh
    if (mult >  0.00) return 1;   // barely
    return 0;                     // total whiff
}


// PARTICLE
//ParticleSystem1
ps_id = part_system_create();
part_system_draw_order(ps_id, true);

//Circle‐style emitter
ptype_circle = part_type_create();
part_type_shape(ptype_circle, pt_shape_circle);
part_type_size(ptype_circle, 1, 1, 0.7, 0);
part_type_scale(ptype_circle, 0.03, 0.03);
part_type_speed(ptype_circle, 0, 0, 0, 0);
part_type_direction(ptype_circle, 0, 0, 0, 0);
part_type_gravity(ptype_circle, 0, 270);
part_type_orientation(ptype_circle, 0, 0, 0, 0, false);
part_type_colour3(ptype_circle, $FFFFFF, $FFFFFF, $FFFFFF);
part_type_alpha3(ptype_circle, 1, 0.553, 0);
part_type_blend(ptype_circle, false);
part_type_life(ptype_circle, 22, 22);

pemit_circle = part_emitter_create(ps_id);
part_emitter_region(ps_id, pemit_circle, 0, 0, 0, 0, ps_shape_ellipse, ps_distr_linear);

//Left‐arc sparkle emitter
ptype_left = part_type_create();
part_type_sprite(ptype_left, spr_sparkle_bw, false, true, false);
part_type_size(ptype_left, 1, 1, -0.05, 0);
part_type_scale(ptype_left, 1, 1);
part_type_speed(ptype_left, 1, 3, -0.1, 0);
part_type_direction(ptype_left, 20, 80, 0, 0);
part_type_gravity(ptype_left, 0.1, 270);
part_type_orientation(ptype_left, 0, 0, 0, 0, false);
part_type_colour3(ptype_left, $FFFFFF, $FFFFFF, $FFFFFF);
part_type_alpha3(ptype_left, 1, 0.522, 0);
part_type_blend(ptype_left, false);
part_type_life(ptype_left, 10, 25);

pemit_left = part_emitter_create(ps_id);
part_emitter_region(ps_id, pemit_left, -4, 4, -4, 4, ps_shape_ellipse, ps_distr_gaussian);

//Right‐arc sparkle emitter
ptype_right = part_type_create();
part_type_sprite(ptype_right, spr_sparkle_bw, false, true, false);
part_type_size(ptype_right, 1, 1, -0.05, 0);
part_type_scale(ptype_right, 1, 1);
part_type_speed(ptype_right, 1, 3, -0.1, 0);
part_type_direction(ptype_right, 100, 160, 0, 0);
part_type_gravity(ptype_right, 0.1, 270);
part_type_orientation(ptype_right, 0, 0, 0, 0, false);
part_type_colour3(ptype_right, $FFFFFF, $FFFFFF, $FFFFFF);
part_type_alpha3(ptype_right, 1, 0.522, 0);
part_type_blend(ptype_right, false);
part_type_life(ptype_right, 10, 25);

pemit_right = part_emitter_create(ps_id);
part_emitter_region(ps_id, pemit_right, -4, 4, -4, 4, ps_shape_ellipse, ps_distr_gaussian);

/// @func spawn_particle()
/// Bursts all three emitters at this object's current position.
function spawn_circle()
{
    // Burst each emitter
    part_emitter_burst(ps_id, pemit_circle, ptype_circle, 1);
}

function spawn_sparkle()
{
    // Burst each emitter
    part_emitter_burst(ps_id, pemit_left,   ptype_left,   5);
    part_emitter_burst(ps_id, pemit_right,  ptype_right,  5);
}