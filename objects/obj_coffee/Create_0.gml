// Sine wave
wave_angle = random(360);               // Random starting phase, like the old current_time wave
wave_speed = 0.2 * 1000 / game_get_speed(gamespeed_fps); // Degrees per frame at BASE_GAMESPEED (0.2°/ms)
