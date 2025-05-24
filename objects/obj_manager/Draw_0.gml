/// Draw debug UI
draw_set_halign(fa_left);

var base_y = 32;      // where the first line starts
var line_h = 16;      // vertical spacing between lines

if (game_state != GameState.PENDING) {
	// Stuff to print, in order
	var lines = [
	    "Time until next section: " + string(section_timer_ticking),
	    "Current conditions: "   + conditions_to_string(current_conditions),
	    "Packages delivered: "   + string(delivered_parcels),
		"Package health: "          + string(current_parcel.hits) + "/" + string(current_parcel.max_hits),
	    "Collected cash: $"      + string(collected_base_pay + collected_tips)
	];
} else var lines = [];

// One loop to rule them all
for (var i = 0; i < array_length(lines); ++i) {
	draw_text_with_shadow(16, base_y + i * line_h, lines[i], c_white, c_black, 0.33);
}

// Stamina bar
draw_healthbar(room_width-128, 32, room_width-16, 44, stamina, c_black, c_navy, c_aqua, 1, true, false);
draw_text_with_shadow(room_width-126, 31, "Energy", c_white, c_black, 0.33);

// Show controls
if (keyboard_check(vk_space)) {
	global.space_pressed = true;
}

if (!global.space_pressed) {
	draw_set_halign(fa_center);
	draw_text_with_shadow(room_width/2, room_height/2, "Press SPACE to fly!", c_white, c_black, 0.33);
}

if (game_state = GameState.FINISHED) {
	draw_set_halign(fa_center);
	draw_text_with_shadow(room_width/2, room_height/2, "Money earned: $" + string(collected_base_pay + collected_tips), c_white, c_black, 0.33);
	draw_text_with_shadow(room_width/2, room_height/2 + 16, "Press ESC to go to menu!", c_white, c_black, 0.33);
}