// ANIM CURVE STUFF

if (game_state = GameState.ACTIVE) {
	badge_ease = lerp(badge_ease, 11, 0.05);
}

if (show_results) {
	end_ease = lerp(end_ease, room_height/2, 0.05);
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

// Stamina as a percentage (max stamina can be upgraded)
var stamina_pct = stamina / max_stamina * 100;

/// Willow expression states
var portrait;
if (obj_player.i_frame == true && stamina > 0) {
	portrait = spr_willow_stunned;
}
else if (stamina_pct > 66) {
    portrait = spr_willow_alert;
}
else if (stamina_pct > 33) {
    portrait = spr_willow_neutral;
}
else if (stamina_pct > 10) {
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
if (stamina_pct > 33) {
	bar_color = 0;
}
else if (stamina_pct > 10) {
	bar_color = 1;
}
else {
    bar_color = 2;
}

// Lerped stamina bar
display_stamina = lerp(display_stamina, stamina, 0.1);
var bar_width = display_stamina / max_stamina * 100; // Bar sprite is 100px wide

// Unused
//draw_sprite(spr_energy_bar, 0, base_x+62, base_y+4);
//draw_sprite_part(spr_energy_bar, 0, 0, 0, 100*(stamina/100), 15, base_x+62, base_y+4);
//draw_sprite(spr_parcel_hexpress, parcel_index, base_x+56+10, base_y+28-2);

// Base
draw_sprite(spr_ui_badge, 0, base_x, base_y);
// Portrait
draw_sprite(portrait, 0, base_x+5, base_y+4);
// Energy bar
draw_sprite_part(spr_energy_bar, bar_color, 0, 0, bar_width, 15, base_x+62, base_y+4);
/*/ Fancy energy bar (back)
draw_sprite_part(spr_energy_bar_back, bar_color, 0, 0, display_stamina, 15, base_x+62, base_y+4);
// Fancy energy bar
draw_sprite_part(spr_energy_bar, bar_color, 0, 0, max(display_stamina-1, 0), 15, base_x+62, base_y+4);
*/
// Coin
draw_sprite(spr_coin, 0, base_x+86, base_y+26);
// Star rating
draw_sprite(spr_ui_badge_star, 0, base_x+3, base_y+47);
// Rating counter
draw_set_font(fnt_04b03);
if (array_length(rating_history) == 0) {
    // Render “–.–” (dash, dot, dash) as the “no rating yet” placeholder
    draw_text_with_shadow(base_x+9+1, base_y+46, "-", #A8A8A8, c_black, 0);
	draw_text_with_shadow(base_x+9+7, base_y+46, "-", #A8A8A8, c_black, 0);
} else {
    // Render the real one‐decimal rating
	draw_text_with_shadow(base_x+9, base_y+46, string_format(current_rating, 1, 1), c_black, c_black, 0.00);
}
// Set font for all other stuff
draw_set_font(fnt_at01);
// Money counter
draw_text_with_shadow(base_x+86+10, base_y+23, string(displayed_money), c_white, c_black, 0.33);
// Delivery counter
draw_text_with_shadow(base_x+86, base_y+23+10, "Delivered: " + string(delivered_parcels), c_white, c_black, 0.33);
// Parcel with shake
draw_sprite(spr_parcel_hexpress, parcel_index, base_x+56+10+irandom_range(-shake, shake), base_y+28-2);

// Bubble Wrap: a shimmery ring around the parcel icon for each hit it can still absorb
if (current_parcel.shield > 0) {
	var _pulse = 0.5 + 0.25 * sin(current_time * 0.006);
	draw_set_color(#9FE7FF);
	draw_set_alpha(_pulse);
	for (var i = 0; i < current_parcel.shield; i++) {
		draw_circle(base_x+56+10, base_y+28-2, 13 + i * 3, true);
	}
	draw_set_alpha(1);
	draw_set_color(c_white);
}

// Streak counter (streaks boost tips, up to 2x)
if (streak >= 2) {
	var _streak_col = (get_streak_multiplier() >= 2) ? #FFE45C : #FFB0E0;
	draw_text_with_shadow(base_x+86, base_y+23+20, "Streak " + string(streak) + "  x" + string_format(get_streak_multiplier(), 1, 1) + " tips", _streak_col, c_black, 0.33);
}

// Floating popups
draw_set_halign(fa_center);
for (var i = 0; i < array_length(popups); i++) {
	var _p = popups[i];
	draw_set_alpha(min(1, _p.life / 20));
	draw_text_with_shadow(_p.px, _p.py, _p.text, _p.col, c_black, 0.5);
}
draw_set_alpha(1);
draw_set_halign(fa_left);


/*/ Show controls
if (keyboard_check(vk_space)) {
	global.space_pressed = true;
} */

var button_height = 64;
var button_width = 172;
if (!global.space_pressed) {
	draw_sprite_stretched(spr_ui_button, 0, room_width/2-(button_width/2), room_height/2-(button_height/2),button_width,button_height);
	draw_set_halign(fa_center);
	draw_text_with_shadow(room_width/2, room_height/2-16-6, "Press LClick or SPACE to fly!", #555555, c_black, 0.10);
	draw_text_with_shadow(room_width/2, room_height/2-6, "RClick or DOWN to drop packages!", #555555, c_black, 0.10);
	//draw_text_with_shadow(room_width/2, room_height/2+12, "(space to start)", #555555, c_black, 0.10);
	
	var clickable_text = "OK";
	var click_width = string_width(clickable_text);
	var click_height = string_height(clickable_text);
	var click_base_x = room_width/2-(click_width/2);
	var click_base_y = room_height/2+12;
	
	if (mouse_x >= click_base_x && mouse_x <= click_base_x+click_width && mouse_y >= click_base_y && mouse_y <= click_base_y+click_height) {
		draw_text_with_shadow(room_width/2, room_height/2+10, clickable_text, #999999, c_black, 0.10);
		if (mouse_check_button_pressed(mb_left)) {
		    global.space_pressed = true;
		}
	} else {
		draw_text_with_shadow(room_width/2, room_height/2+10, clickable_text, #555555, c_black, 0.10);
	}
}

if (game_state = GameState.FINISHED && is_struct(results)) {
	// SHIFT REPORT
	var panel_w = 260;
	var panel_h = 168;
	var px = room_width/2 - panel_w/2;
	var py = end_ease - panel_h/2;
	draw_sprite_stretched(spr_ui_popup, 0, px, py, panel_w, panel_h);
	
	draw_set_halign(fa_center);
	draw_text_with_shadow(room_width/2, py + 3, "Shift Report", c_white, c_black, 0.5);
	
	var row_y  = py + 26;
	var row_h  = 17;
	var lx     = px + 14;
	var rx     = px + panel_w - 14;
	var _best  = #FFE45C;
	var _flash = (current_time div 300) mod 2 == 0;
	
	var rows = [
		["Money earned",  "$" + string(results.money),         results.new_money],
		["Deliveries",    string(results.deliveries),          results.new_delivery],
		["Best streak",   string(results.streak),              results.new_streak],
		["Avg. rating",   results.has_rating ? string_format(results.rating, 1, 1) + " stars" : "-", false],
		["Houses passed", string(results.houses),              false],
	];
	
	for (var i = 0; i < array_length(rows); i++) {
		var _yy = row_y + i * row_h;
		draw_set_halign(fa_left);
		draw_text_with_shadow(lx, _yy, rows[i][0], c_white, c_black, 0.33);
		draw_set_halign(fa_right);
		var _is_best = rows[i][2];
		draw_text_with_shadow(rx, _yy, rows[i][1], _is_best ? _best : c_white, c_black, 0.33);
		if (_is_best && _flash) {
			draw_text_with_shadow(rx - string_width(rows[i][1]) - 8, _yy, "NEW BEST!", _best, c_black, 0.33);
		}
	}
	
	// Wallet total
	var _wy = row_y + array_length(rows) * row_h + 4;
	draw_set_halign(fa_center);
	draw_text_with_shadow(room_width/2, _wy, "Wallet: $" + string(global.money), #9FE7FF, c_black, 0.33);
	
	if (show_results) {
		draw_text_with_shadow(room_width/2, py + panel_h - 20, "SPACE: next shift   ESC: menu", #FFE45C, c_black, 0.33);
	}
	draw_set_halign(fa_left);
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
			"Streak mult: "			 + string(get_streak_multiplier()),
			"Rating mult: "			 + string(get_rating_multiplier())
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