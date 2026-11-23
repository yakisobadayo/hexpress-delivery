/// @description Handle hover and click logic
//  This code is an absolute mess, sorry in advance

// This code is also spaghetti code I pasted from ChatGPT that I stole from my last year project, I was too lazy to make another menu system so I retrofitted this one. Sorry for whoever's eyes grace this

animation_time += 0.06;
shop_flash = max(0, shop_flash - 1);

// ─────────────────────────────────────────────────────────────
// SHOP (Willow's Workshop)
// ─────────────────────────────────────────────────────────────
shop_x = room_width / 2 - shop_w / 2;
shop_y = room_height / 2 - shop_h / 2;

if (shop_open) {
	// Row hover
	shop_hover = -1;
	for (var i = 0; i < array_length(global.upgrades); i++) {
		var _ry = shop_y + shop_rows_y + i * shop_row_h;
		if (mouse_x >= shop_x + 10 && mouse_x <= shop_x + shop_w - 10 && mouse_y >= _ry && mouse_y < _ry + shop_row_h - 4) {
			shop_hover = i;
			break;
		}
	}

	// Back button hover
	var _back_y = shop_y + shop_h - 26;
	shop_back_hover = (mouse_x >= room_width / 2 - 40 && mouse_x <= room_width / 2 + 40 && mouse_y >= _back_y && mouse_y <= _back_y + 18);

	// Buy
	if (mouse_check_button_pressed(mb_left)) {
		if (shop_hover != -1) {
			if (upgrade_buy(shop_hover)) {
				audio_play_sound(snd_kaching, 10, false);
			} else if (!upgrade_is_maxed(shop_hover)) {
				audio_play_sound(snd_impact_subdued, 10, false);
				shop_flash = 30;
				shop_flash_row = shop_hover;
			}
		} else if (shop_back_hover) {
			shop_open = false;
			audio_play_sound(snd_button_press, 10, false);
		}
	}

	// Close with ESC or right click
	if (keyboard_check_pressed(vk_escape) || mouse_check_button_pressed(mb_right)) {
		shop_open = false;
		audio_play_sound(snd_button_press, 10, false);
	}

	// Debug: free money for testing upgrades
	if (global.debug_mode && keyboard_check_pressed(ord("M"))) {
		global.money += 500;
		save_game();
		audio_play_sound(snd_cash, 10, false);
	}

	// Fullscreen still works in the shop
	if (keyboard_check_pressed(vk_f11)) {
	    window_set_fullscreen(!window_get_fullscreen());
	}
	exit;
}

// Menu options
var main_options = [play_text, shop_text, exit_text];
var current_options = main_options;
var option_height = 32; // Height of each option

// Check hover
var new_selected = -1;
for (var i = 0; i < array_length(current_options); i++) {
    var y_pos = ((room_height / 2) + i * option_height) - 40;

    // Check if mouse is over this option
    if (mouse_x >= room_width / 3 * 2 && mouse_x <= room_width / 3 * 2 + string_width(current_options[i]) && mouse_y >= y_pos && mouse_y <= y_pos + option_height) {
        new_selected = i + 1; // Set selected option to hovered option
		/*if (selected != new_selected) { // Only play sound if the hovered option changes
            audio_play_sound(snd_button_hover, 10, false);
        }*/
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
				//var goto_run = instance_create_layer(0,0,"Instances",obj_gotofade);
				//goto_run.target_room = room_run;
                return; // Ensure the rest of the code does not execute
            case 2:
				shop_open = true;
				shop_hover = -1;
				audio_play_sound(snd_button_press, 10, false);
                return;
            case 3:
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

// Debug: wipe save data (Shift + Delete)
if (global.debug_mode && keyboard_check(vk_shift) && keyboard_check_pressed(vk_delete)) {
	reset_save();
	audio_play_sound(snd_impact, 10, false);
}

// Fullscreen mode
if (keyboard_check_pressed(vk_f11)) {
    window_set_fullscreen(!window_get_fullscreen());
}
