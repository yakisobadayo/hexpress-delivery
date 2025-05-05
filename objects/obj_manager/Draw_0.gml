//draw_set_font(fnt_monogram);
//draw_set_color(c_black);

// Draw debug UI
draw_set_halign(fa_left);
draw_text_with_shadow(16, 32, "Time until next section: " + string(section_timer_ticking), c_white, c_black, 0.33);
draw_text_with_shadow(16, 48, "Current conditions: " + conditions_to_string(global.current_section_conditions), c_white, c_black, 0.33);
draw_text_with_shadow(16, 64, "Packages delivered: " + string(global.deliveredpackages) + "/" + string(global.routelength), c_white, c_black, 0.33);
draw_text_with_shadow(16, 80, "Parcel health: " + string(global.current_parcel_health*100) + "%", c_white, c_black, 0.33);
draw_text_with_shadow(16, 96, "Collected tips: $" + string(global.collected_tips), c_white, c_black, 0.33);

// Show controls
if (keyboard_check(vk_space))
{
	global.space_pressed = true;
}

if (!global.space_pressed)
{
	draw_set_halign(fa_center);
	draw_text_with_shadow(room_width/2, room_height/2, "Press SPACE to fly!", c_white, c_black, 0.33);
}