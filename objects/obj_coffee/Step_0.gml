auto_scroll(-2.5);

// Sine wave funkiness (advances with the world so the wave keeps its shape on screen)
wave_angle += wave_speed * speed_scale();
y = ystart + dsin(wave_angle) * 32;

destroy_offscreen();