// ANIM CURVE STUFF

if (game_state = GameState.ACTIVE) {
	badge_ease = lerp(badge_ease, 11, 0.05);
}

// WIP
draw_set_halign(fa_left);
var base_x = badge_ease;
var base_y = 24;

/// When package hit registers
var parcel_index = 0;
switch (current_parcel.hits) {
 case 3: parcel_index = 1; break;
 case 2: parcel_index = 1; break;
 case 1: parcel_index = 2; break;
 case 0: parcel_index = 3; break;
}

/// Willow expression states
var portrait;
if (obj_player.i_frame == true && stamina > 0) {
	portrait = spr_willow_stunned;
}
else if (stamina > 66) {
    portrait = spr_willow_alert;
}
else if (stamina > 33) {
    portrait = spr_willow_neutral;
}
else if (stamina > 10) {
    portrait = spr_willow_tired;
}
else if (stamina > 0) {
    portrait = spr_willow_zonked;
}
else {
	portrait = spr_willow_zonked_asleep;
}

// Bar colour
var bar_color;
if (stamina > 33) {
	bar_color = 0;
}
else if (stamina > 10) {
	bar_color = 1;
}
else {
    bar_color = 2;
}

// Unused
//draw_sprite(spr_energy_bar, 0, base_x+62, base_y+4);
//draw_sprite_part(spr_energy_bar, 0, 0, 0, 100*(stamina/100), 15, base_x+62, base_y+4);
//draw_sprite(spr_parcel_hexpress, parcel_index, base_x+56+10, base_y+28-2);

// Base
draw_sprite(spr_ui_badge, 0, base_x, base_y);
// Portrait
draw_sprite(portrait, 0, base_x+5, base_y+4);
// Energy bar
draw_sprite_part(spr_energy_bar, bar_color, 0, 0, stamina, 15, base_x+62, base_y+4);
// Coin
draw_sprite(spr_coin, 0, base_x+86, base_y+26);
// Money counter
draw_text_with_shadow(base_x+86+10, base_y+23, string(displayed_money), c_white, c_black, 0.33);
// Delivery counter
draw_text_with_shadow(base_x+86, base_y+23+10, "Delivered: " + string(delivered_parcels), c_white, c_black, 0.33);
// Parcel with shake
draw_sprite(spr_parcel_hexpress, parcel_index, base_x+56+10+irandom_range(-shake, shake), base_y+28-2);

// Streak counter
if (streak >= 2) {
	draw_text_with_shadow(base_x+86, base_y+23+20, "Streak: " + string(streak), c_white, c_black, 0.33);
}


// Show controls
if (keyboard_check(vk_space)) {
	global.space_pressed = true;
}

var button_height = 64;
var button_width = 172;
if (!global.space_pressed) {
	draw_sprite_stretched(spr_ui_button, 0, room_width/2-(button_width/2), room_height/2-(button_height/2),button_width,button_height);
	draw_set_halign(fa_center);
	draw_text_with_shadow(room_width/2, room_height/2-16, "Press SPACE or LClick to fly!", #555555, c_black, 0.10);
	draw_text_with_shadow(room_width/2, room_height/2, "DOWN or RClick to drop packages!", #555555, c_black, 0.10);
	draw_text_with_shadow(room_width/2, room_height/2+12, "(space to start)", #555555, c_black, 0.10);
}

if (game_state = GameState.FINISHED) {
	draw_sprite_stretched(spr_ui_button, 0, room_width/2-(button_width/2), room_height/2-(button_height/2),button_width,button_height);
	draw_set_halign(fa_center);
	draw_text_with_shadow(room_width/2, room_height/2-16, "Money earned: $" + string(collected_base_pay + collected_tips), #555555, c_black, 0.10);
	draw_text_with_shadow(room_width/2, room_height/2, "Press ESC to go to menu!", #555555, c_black, 0.10);
}



/// Draw debug UI
if (global.debug_mode) {
	draw_set_halign(fa_right);

	var base_y = 32;	// where the first line starts
	var line_h = 16;	// vertical spacing between lines

	if (game_state != GameState.PENDING) {
		// Stuff to print, in order
		var lines = [
		    //"Time until next section: " + string(section_timer_ticking),
		    "Current conditions: "   + conditions_to_string(current_conditions),
			"Current section: "      + string(current_section),
		    "Packages delivered: "   + string(delivered_parcels),
			"Package health: "       + string(current_parcel.hits) + "/" + string(current_parcel.max_hits),
		    "Collected cash: $"      + string(collected_base_pay + collected_tips),
			"Streak: "				 + string(get_streak_multiplier())
		];
	} else var lines = [];

	// One loop to rule them all
	for (var i = 0; i < array_length(lines); ++i) {
		draw_text_with_shadow(room_width-16, base_y + i * line_h, lines[i], c_white, c_black, 0.33);
	}
}

/*/ Stamina bar
if (game_state != GameState.PENDING) {
	draw_healthbar(16, 32, 128, 46, stamina, c_black, #00177d, #00a1ff, 0, true, false);
	draw_text_with_shadow(20, 32, "Energy", c_white, c_black, 0.33);
}