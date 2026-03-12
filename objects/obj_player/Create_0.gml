// obj_player: Create Event
grav = 0.15;
y_velocity = 0;
booster = false;
stunned = false;
i_frame = false;
grounded = false;
colliding = false;
in_house_bounds = false;

last_stamina = 1.0;



// FUNCTIONS
// Stun & knockback (lose control)
function stun(_stun_time, _i_time) { // Time is in seconds
	if (y_velocity < 0) y_velocity = 0;
	stunned = true;
    alarm_set(0, _stun_time * room_speed); // stun
	i_frame = true;
	alarm_set(1, _i_time * room_speed);    // i-frame
}

// Trigger when hitting obstacle
function get_hit() {
	// Get hit
	obj_manager.register_hit(1);
	
    // Stun
    stun(0.3, 1);
}

// Stamina gravity modification
function stamina_mod()
{
	if !instance_exists(obj_manager) return 1;
	var stamina_soft_floor   = 0.33;  // %  – where the slowdown begins
	var strength_floor_ratio = 0.50;  // %  – min booster strength & max gravity buff
    var r = obj_manager.stamina / obj_manager.max_stamina;             // 0–1
    if (r >= stamina_soft_floor) return 1;     // above threshold, full power

    // linear fade from 1→strength_floor_ratio as stamina drops from 50 %→0
    var t = r / stamina_soft_floor;            // 1→0   (at 50 % … 0 %)
    return lerp(strength_floor_ratio, 1, t);   // 0.5→1
}


// PARTICLE
// Create broom sparkle particle system
broom_ps = part_system_create();
part_system_draw_order(broom_ps, true);

// Create particle type
ptype_broom = part_type_create();
part_type_sprite(ptype_broom, spr_sparkle_bw_anim, true, true, false);
part_type_size(ptype_broom, 1, 1, 0, 0);
part_type_scale(ptype_broom, 1, 1);
part_type_speed(ptype_broom, 4, 4, 0, 0);
part_type_direction(ptype_broom, 175, 185, 0, 0);
part_type_gravity(ptype_broom, 0, 270);
part_type_orientation(ptype_broom, 0, 0, 0, 0, false);
part_type_colour3(ptype_broom, $FFFFFF, $FFFFFF, $FFFFFF);
part_type_alpha3(ptype_broom, 1, 0.5, 0);
part_type_blend(ptype_broom, false);
part_type_life(ptype_broom, 60, 65);

// Create emitter
pemit_broom = part_emitter_create(broom_ps);
part_emitter_region(broom_ps, pemit_broom, -2, 2, -4, 4, ps_shape_rectangle, ps_distr_linear);

// Start with no emission
part_emitter_stream(broom_ps, pemit_broom, ptype_broom, 0);

sparkle_timer      = 0;   // counts down each Step
sparkle_interval   = 4;   // one particle every 4 frames  (≈ 15/sec)