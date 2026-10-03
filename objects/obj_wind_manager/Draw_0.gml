// Wind streaks
var _old_alpha = draw_get_alpha();
var _old_col   = draw_get_color();
draw_set_color(c_white);

for (var i = 0; i < array_length(streaks); i++) {
	var s = streaks[i];
	draw_set_alpha(s.alpha);
	draw_line(s.x, s.y, s.x + s.len, s.y - gust_dir * s.len * 0.3);
}

// Blinking warning arrow at the right edge, pointing the way the wind will push
if (gust_state == "warning" && (state_timer div 8) mod 2 == 0) {
	var _ax = room_width - 24;
	var _ay = room_height / 2;
	draw_set_alpha(0.8);
	draw_arrow(_ax, _ay - gust_dir * 24, _ax, _ay + gust_dir * 24, 12);
}

draw_set_alpha(_old_alpha);
draw_set_color(_old_col);
