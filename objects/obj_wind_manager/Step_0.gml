switch (gust_state)
{
	case "calm":
		// Don't start gusts while a house is on screen so drops stay fair
		if (!instance_exists(obj_house)) {
			gust_timer -= global.gamespeed;
		}
		
		if (gust_timer <= 0) {
			// Push towards the edge the player is furthest from, so it's always a threat
			gust_dir = (obj_player.y < room_height / 2) ? 1 : -1;
			gust_state = "warning";
			state_timer = warning_length;
		}
		break;
	
	case "warning":
		state_timer -= 1;
		if (irandom(3) == 0) add_streak(0.25);
		
		if (state_timer <= 0) {
			gust_state = "gusting";
			state_timer = gust_length;
		}
		break;
	
	case "gusting":
		state_timer -= 1;
		add_streak(0.6);
		
		// Push the player
		with (obj_player) {
			y_velocity += other.gust_dir * other.gust_strength;
		}
		
		if (state_timer <= 0) {
			gust_state = "calm";
			gust_timer = irandom_range(100, 200) * spacing_modifier;
		}
		break;
}

// Move streaks, slanted in the gust direction
for (var i = array_length(streaks) - 1; i >= 0; i--) {
	var s = streaks[i];
	s.x -= global.gamespeed + s.spd;
	s.y += gust_dir * s.spd * 0.3;
	
	if (s.x + s.len < 0) {
		array_delete(streaks, i, 1);
	}
}
