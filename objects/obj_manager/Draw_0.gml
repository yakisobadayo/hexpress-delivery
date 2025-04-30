//draw_set_font(fnt_monogram);
draw_set_color(c_black);
draw_set_halign(fa_left);
draw_text(16, 32, "Current: " + object_get_name(global.current_obstacle_type));
//draw_text(16, 48, "Time until next section: " + string(section_timer));
draw_text(16, 48, "Packages delivered: " + string(global.deliveredpackages) + "/" + string(global.routelength));
draw_text(16, 64, "Parcel health: " + string(global.current_parcel_health*100) + "%");

// Show controls
if (keyboard_check(vk_space))
{
	global.space_pressed = true;
}

if (!global.space_pressed)
{
	draw_set_halign(fa_center);
	draw_text(room_width/2, room_height/2, "Press SPACE to fly!");
}

if (over)
{
	draw_set_halign(fa_center);
	draw_text(room_width/2, room_height/2, "Tips collected: " + string(global.tip_money) + "g");
	draw_text(room_width/2, room_height/2+16, "Press ESC to exit to menu");
}