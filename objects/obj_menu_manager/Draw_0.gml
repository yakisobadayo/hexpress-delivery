/// @description Draw the options and selection indicator

// Calculate the scale using a sine wave for smooth oscillation
var scale_factor = 1 + 0.06 * sin(animation_time); // Adjust the 0.1 to change the amplitude

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Menu options
var main_options = [play_text, exit_text];
var current_options = main_options;
var option_height = 32; // Height of each option

// Set the color to white
draw_set_color(c_white);

// Draw options and selection circles
for (var i = 0; i < array_length(current_options); i++) {
    var y_pos = (room_height / 2) + i * option_height;
    var x_pos = room_width / 3;

    // Calculate adjustment for y position based on angle
    var angle_adjustment = 3; // This is the rotation angle
    var y_adjustment = sin(degtorad(angle_adjustment)) * string_height(current_options[i]) / 2;

    // Draw options
    if (selected == i + 1) { // Hover
        draw_text(x_pos, y_pos, current_options[i]);
    } else { // Normal
        draw_text(x_pos, y_pos, current_options[i]);
    }

    // Draw selector
    if (selected == i + 1) {
        var selector_x_offset = 32 + 2.5 * sin(animation_time); // Adjust '5' for the amplitude of the wobble
        draw_sprite(spr_selector, -1, x_pos - selector_x_offset, y_pos + 10);
    }
}