/// @description Handle hover and click logic
//  This code is an absolute mess, sorry in advance

animation_time += 0.06;

// Menu options
var main_options = [play_text, exit_text];
var current_options = main_options;
var option_height = 32; // Height of each option

// Check hover
var new_selected = -1;
for (var i = 0; i < array_length(current_options); i++) {
    var y_pos = (room_height / 2) + i * option_height;

    // Check if mouse is over this option
    if (mouse_x >= room_width / 3 && mouse_x <= room_width / 3 + string_width(current_options[i]) && mouse_y >= y_pos && mouse_y <= y_pos + option_height) {
        new_selected = i + 1; // Set selected option to hovered option
        break;
    }
}

selected = new_selected;

// Handle click event
if (mouse_check_button_pressed(mb_left) && selected != -1) {
        // Actions for main options
        switch (selected) {
            case 1:
                room_goto(room_run); // Action for option 1
                return; // Ensure the rest of the code does not execute
            case 2:
				game_end();
                return; // Ensure the rest of the code does not execute
        }
}


// DEBUG MODE
var key = noone;

// detect any relevant keypress
if keyboard_check_pressed(vk_up)    key = vk_up;
else if keyboard_check_pressed(vk_down)  key = vk_down;
else if keyboard_check_pressed(vk_left)  key = vk_left;
else if keyboard_check_pressed(vk_right) key = vk_right;
else if keyboard_check_pressed(ord("B")) key = ord("B");
else if keyboard_check_pressed(ord("A")) key = ord("A");

if key != noone {
    if key == konami_pattern[konami_index] {
        konami_index += 1;

        // full code entered!
        if konami_index == konami_length {
            // TOGGLE DEBUG MODE
            global.debug_mode = !global.debug_mode;

            // reset sequence
            konami_index = 0;
			
			// sound!
			audio_play_sound(snd_ding, 10, false);
        }
    } else {
        // if they pressed the very first key, start from 1, else reset
        konami_index = (key == konami_pattern[0]) ? 1 : 0;
    }
}