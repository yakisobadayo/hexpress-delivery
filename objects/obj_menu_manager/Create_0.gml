/// @description Insert description here
// You can write your code in this editor

selected = 1;
animation_time = 0;

play_text = "Play";
exit_text = "Exit";

/*/ PARTICLE TEST
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
part_type_scale(ptype_left, 1.5, 1.5);
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
part_type_scale(ptype_right, 1.5, 1.5);
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
function spawn_particle()
{
    // Move the system to the object
    part_system_position(ps_id, mouse_x, mouse_y);

    // Burst each emitter
    part_emitter_burst(ps_id, pemit_circle, ptype_circle, 1);
    part_emitter_burst(ps_id, pemit_left,   ptype_left,   5);
    part_emitter_burst(ps_id, pemit_right,  ptype_right,  5);
}