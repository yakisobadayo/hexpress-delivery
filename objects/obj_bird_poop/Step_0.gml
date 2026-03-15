auto_scroll();

y_velocity += grav;

if (place_meeting(x, y + y_velocity, obj_boundary)) {
    while (!place_meeting(x, y + sign(y_velocity), obj_boundary)) {
        y += sign(y_velocity);
    }
    y_velocity = 0;
}

y += y_velocity;

destroy_offscreen();
