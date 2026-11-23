/// @description Draw the shop on the GUI layer so it sits above every room layer (logo, buttons, etc.)

if (!shop_open) exit;

// Match GUI coordinates to the room so the mouse hit-tests in Step line up
display_set_gui_size(room_width, room_height);
draw_set_font(fnt_at01);

// ─────────────────────────────────────────────────────────────
// WILLOW'S WORKSHOP
// ─────────────────────────────────────────────────────────────
{
	// Dim the menu behind
	draw_set_alpha(0.55);
	draw_set_color(c_black);
	draw_rectangle(0, 0, room_width, room_height, false);
	draw_set_alpha(1);
	draw_set_color(c_white);
	
	// Panel
	draw_sprite_stretched(spr_ui_popup, 0, shop_x, shop_y, shop_w, shop_h);
	draw_set_halign(fa_left);
	draw_text_with_shadow(shop_x + 10, shop_y + 3, "Willow's Workshop", c_white, c_black, 0.5);
	draw_set_halign(fa_right);
	draw_sprite(spr_coin, 0, shop_x + shop_w - 14 - string_width(string(global.money)) - 12, shop_y + 6);
	draw_text_with_shadow(shop_x + shop_w - 12, shop_y + 3, string(global.money), #FFE45C, c_black, 0.5);
	
	for (var i = 0; i < array_length(global.upgrades); i++) {
		var _u      = global.upgrades[i];
		var _ry     = shop_y + shop_rows_y + i * shop_row_h;
		var _maxed  = upgrade_is_maxed(i);
		var _cost   = upgrade_next_cost(i);
		var _afford = !_maxed && global.money >= _cost;
		var _hover  = (shop_hover == i);
		
		// Row background
		draw_set_color(c_white);
		draw_set_alpha(_hover ? 0.22 : 0.10);
		draw_rectangle(shop_x + 10, _ry, shop_x + shop_w - 10, _ry + shop_row_h - 6, false);
		draw_set_alpha(1);
		
		// Name + description
		draw_set_halign(fa_left);
		draw_text_with_shadow(shop_x + 18, _ry + 3, _u.name, c_white, c_black, 0.5);
		draw_text_with_shadow(shop_x + 18, _ry + 20, _u.desc, #CFEFFF, c_black, 0.33);
		
		// Level pips
		var _levels = array_length(_u.costs);
		var _pip_x  = shop_x + 18 + string_width(_u.name) + 10;
		for (var l = 0; l < _levels; l++) {
			var _px = _pip_x + l * 10;
			draw_set_color(c_black);
			draw_set_alpha(0.4);
			draw_rectangle(_px + 1, _ry + 8, _px + 7, _ry + 14, false);
			draw_set_alpha(1);
			draw_set_color(l < _u.level ? #FFE45C : #3B6FC0);
			draw_rectangle(_px, _ry + 7, _px + 6, _ry + 13, false);
		}
		draw_set_color(c_white);
		
		// Price button
		var _bw = 80;
		var _bh = 26;
		var _bx = shop_x + shop_w - 18 - _bw;
		var _by = _ry + (shop_row_h - 6) / 2 - _bh / 2;
		var _shake = (shop_flash > 0 && shop_flash_row == i) ? irandom_range(-2, 2) : 0;
		draw_sprite_stretched(spr_ui_button, (_hover && _afford) ? 1 : 0, _bx + _shake, _by, _bw, _bh);
		
		var _label, _label_col;
		if (_maxed)       { _label = "MAXED";              _label_col = #3AA03A; }
		else if (_afford) { _label = "$" + string(_cost);  _label_col = #555555; }
		else              { _label = "$" + string(_cost);  _label_col = (shop_flash > 0 && shop_flash_row == i) ? #D04040 : #AAAAAA; }
		draw_set_halign(fa_center);
		draw_text_with_shadow(_bx + _bw / 2 + _shake, _by + 6, _label, _label_col, c_black, 0.10);
	}
	
	// Back button
	var _back_y = shop_y + shop_h - 26;
	draw_set_halign(fa_center);
	draw_text_with_shadow(room_width / 2, _back_y, "Back", shop_back_hover ? #FFE45C : c_white, c_black, 0.5);
	if (shop_back_hover) {
		var _sx = room_width / 2 - string_width("Back") / 2 - 26 - 2.5 * sin(animation_time);
		draw_sprite(spr_selector, -1, _sx, _back_y + 7);
	}
	
	if (global.debug_mode) {
		draw_set_halign(fa_left);
		draw_text_with_shadow(shop_x, shop_y + shop_h + 4, "[M] +$500", #FF9090, c_black, 0.33);
	}
	draw_set_halign(fa_left);
}
