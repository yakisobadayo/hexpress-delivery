/// @description Draw debug label (menu itself is drawn by YUI)

draw_set_font(fnt_at01);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

if (global.debug_mode) {
	draw_text_with_shadow(16, 24, "Debug mode!", c_white, c_black, 0.33);
}