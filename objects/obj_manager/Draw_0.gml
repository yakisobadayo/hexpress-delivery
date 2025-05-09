/// Draw debug UI
draw_set_halign(fa_left);

var base_y = 32;      // where the first line starts
var line_h = 16;      // vertical spacing between lines

// Stuff to print, in order
var lines = [
    "Time until next section: " + string(section_timer_ticking),
    "Current conditions: "   + conditions_to_string(current_section_conditions),
    "Packages delivered: "   + string(deliveredpackages) + "/" + string(routelength),
    "Tip multiplier: "       + string(tip_multiplier * 100) + "%",
    "Collected tips: $"      + string(collected_tips),
	"Times hit: "            + string(hits) + "/" + string(max_hits)
];

// One loop to rule them all
for (var i = 0; i < array_length(lines); ++i) {
    draw_text_with_shadow(16, base_y + i * line_h, lines[i], c_white, c_black, 0.33);
}

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

if (!route_active)
{
	draw_set_halign(fa_center);
	draw_text_with_shadow(room_width/2, room_height/2, "Money earned: $" + string(collected_tips), c_white, c_black, 0.33);
	draw_text_with_shadow(room_width/2, room_height/2 + 16, "Press ESC to go to menu!", c_white, c_black, 0.33);
}