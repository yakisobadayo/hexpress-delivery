/// @description Sync menu UI, debug code and fullscreen

// Menu UI (buttons are handled by datafiles/hexpress/menu_screen.yui)
menu_ui.music_muted = global.mute_music;
menu_ui.sfx_muted = global.mute_sfx;


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