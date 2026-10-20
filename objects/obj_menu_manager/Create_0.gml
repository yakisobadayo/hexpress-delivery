/// @description Insert description here
// You can write your code in this editor

// MENU UI (datafiles/hexpress/menu_screen.yui)
menu_ui = {
	items: [
		ui_button("Play", function() { room_goto(room_run); }),
		ui_button("Exit", function() { game_end(); }),
	],
	music_muted: false, // synced in Step (the globals are set up in Game Start, after this runs)
	sfx_muted: false,
	// YUI can only call methods, so wrap the script functions
	toggle_music: function() { ui_toggle_music(); },
	toggle_sfx: function() { ui_toggle_sfx(); },
};
ui_open("hexpress/menu_screen.yui", menu_ui);


// DEBUG MODE
konami_pattern = [
    vk_up, vk_up,
    vk_down, vk_down,
    vk_left, vk_right,
    vk_left, vk_right,
    ord("B"), ord("A")
];
konami_index = 0;
konami_length = array_length(konami_pattern);