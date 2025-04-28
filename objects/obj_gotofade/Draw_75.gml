/// @description Draw fade

// Calculate the alpha based on the remaining time
var alpha = 1 - (fade_timer_ticking / (room_speed * fade_timer));

// Set the drawing alpha
draw_set_alpha(alpha);

// Draw the rectangle with the fade effect
draw_rectangle_color(0, 0, room_width, room_height, fcol, fcol, fcol, fcol, false);

// Reset the drawing alpha to 1 for other drawing operations
draw_set_alpha(1);