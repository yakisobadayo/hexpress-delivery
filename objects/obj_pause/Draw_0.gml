if (!paused) exit;

// Frozen frame, stretched over the view
var _cam = view_camera[0];
var _cx = camera_get_view_x(_cam);
var _cy = camera_get_view_y(_cam);
var _cw = camera_get_view_width(_cam);
var _ch = camera_get_view_height(_cam);
if (sprite_exists(pause_sprite)) {
	draw_sprite_stretched(pause_sprite, 0, _cx, _cy, _cw, _ch);
}

// Dim it
draw_set_alpha(0.4);
draw_rectangle_colour(_cx, _cy, _cx + _cw, _cy + _ch, c_black, c_black, c_black, c_black, false);
draw_set_alpha(1);

// Pause box (same style as the tutorial and results boxes)
var button_height = 64;
var button_width = 172;
draw_set_font(fnt_at01);
draw_set_halign(fa_center);
draw_sprite_stretched(spr_ui_button, 0, room_width/2-(button_width/2), room_height/2-(button_height/2), button_width, button_height);
draw_text_with_shadow(room_width/2, room_height/2-16-6, "Paused", #555555, c_black, 0.10);
draw_text_with_shadow(room_width/2, room_height/2-6, "Press P to resume", #555555, c_black, 0.10);
draw_text_with_shadow(room_width/2, room_height/2+16-6, "Press ESC to go to menu", #555555, c_black, 0.10);
draw_set_halign(fa_left);
