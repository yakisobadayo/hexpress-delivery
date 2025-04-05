draw_set_color(c_black);
draw_text(16, 32, "Current: " + object_get_name(global.current_obstacle_type));
draw_text(16, 48, "Time until next section: " + string(section_timer));