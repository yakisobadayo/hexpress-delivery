spacing_modifier = 3; // Modifies spacing between gusts
gust_timer = 100 * spacing_modifier; // Distance until the next gust starts its warning

// Gust state: "calm" -> "warning" -> "gusting" -> "calm"
gust_state = "calm";
gust_dir = 0;            // -1 = updraft, 1 = downdraft
state_timer = 0;         // Frames left in the current warning/gust

warning_length = 1 * room_speed;   // How long the player gets to react
gust_length = 2 * room_speed;      // How long the gust pushes
gust_strength = 0.1;               // Push per frame (gravity is 0.15, so it can be fought)

// Wind streaks (purely visual)
streaks = [];

function add_streak(_alpha) {
	array_push(streaks, {
		x     : room_width + irandom(32),
		y     : irandom_range(32, room_height - 32),
		len   : irandom_range(12, 32),
		spd   : random_range(6, 10),
		alpha : _alpha,
	});
}
