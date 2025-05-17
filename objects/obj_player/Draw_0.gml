if (stunned) {
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha/2);
} else {
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}

if (house != noone && house.delivered == false) {
	draw_sprite(spr_player_drop_indicator, image_index, x, y);
}

if (in_house_bounds) {
	draw_text_with_shadow(x, y, "In bounds!", c_white, c_black, 0.33);
}

//draw_text(x+15,y,y_velocity)