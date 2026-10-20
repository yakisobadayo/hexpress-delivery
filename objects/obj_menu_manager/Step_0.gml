/// @description Handle hover and click logic
//  This code is an absolute mess, sorry in advance

// This code is also spaghetti code I pasted from ChatGPT that I stole from my last year project, I was too lazy to make another menu system so I retrofitted this one. Sorry for whoever's eyes grace this

animation_time += 0.06;

// Menu options
var main_options = [play_text, exit_text];
var current_options = main_options;
var option_height = 32; // Height of each option

// Check hover
var hovered = -1;
for (var i = 0; i < array_length(current_options); i++) {
    var y_pos = ((room_height / 2) + i * option_height) - 40;

    // Check if mouse is over this option
    if (mouse_x >= room_width / 3 * 2 && mouse_x <= room_width / 3 * 2 + string_width(current_options[i]) && mouse_y >= y_pos && mouse_y <= y_pos + option_height) {
        hovered = i + 1; // Set selected option to hovered option
		/*if (selected != new_selected) { // Only play sound if the hovered option changes
            audio_play_sound(snd_button_hover, 10, false);
        }*/
        break;
    }
}

// Mouse only changes the selection when it moves, so it doesn't fight the controller
if (InputMouseMoved()) {
	selected = hovered;
}

// Controller / keyboard navigation (wraps around)
var option_count = array_length(current_options);
if (InputPressed(INPUT_VERB.UP)) {
	selected = (selected <= 1) ? option_count : selected - 1;
}
if (InputPressed(INPUT_VERB.DOWN)) {
	selected = (selected == -1 || selected >= option_count) ? 1 : selected + 1;
}

// Handle click / confirm event
var activated = -1;
if (mouse_check_button_pressed(mb_left) && hovered != -1) {
	activated = hovered;
} else if (InputPressed(INPUT_VERB.ACCEPT) && selected != -1) {
	activated = selected;
}

if (activated != -1) {
        // Actions for main options
        switch (activated) {
            case 1:
                room_goto(room_run); // Action for option 1
				//var goto_run = instance_create_layer(0,0,"Instances",obj_gotofade);
				//goto_run.target_room = room_run;
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

// Fullscreen mode
if (keyboard_check_pressed(vk_f11)) {
    window_set_fullscreen(!window_get_fullscreen());
}