var _toggle = keyboard_check_pressed(ord("P"));

if (paused) {
	if (_toggle) {
		resume_game();
	} else if (keyboard_check_pressed(vk_escape)) {
		quit_to_menu();
	}
} else if (instance_exists(obj_manager) && obj_manager.game_state != GameState.FINISHED) {
	// Pause on P, or automatically when the window loses focus mid-route
	var _lost_focus = had_focus && !window_has_focus();
	if (_toggle || (_lost_focus && obj_manager.game_state == GameState.ACTIVE)) {
		pause_game();
	}
}

had_focus = window_has_focus();
