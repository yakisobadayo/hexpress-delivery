// obj_pause: freezes the whole game by deactivating every other instance.
// Deactivated instances skip their Step, Draw, alarms, collisions and input events,
// so only the things that aren't instances (screen, layers, particles, audio) need handling here.
paused = false;
pause_sprite = -1;           // Snapshot of the last frame, drawn while everything else is deactivated
paused_particle_systems = []; // Particle systems frozen on pause, to unfreeze on resume
had_focus = window_has_focus();


// FUNCTIONS
function pause_game() {
	if (paused) return;
	paused = true;

	// Snapshot the last frame (the HUD included) to draw in place of the deactivated instances
	if (surface_exists(application_surface)) {
		pause_sprite = sprite_create_from_surface(application_surface, 0, 0,
			surface_get_width(application_surface), surface_get_height(application_surface),
			false, false, 0, 0);
	}

	// Stop the background layers (obj_manager restores their speeds on resume)
	with (obj_manager) {
		for (var i = 0; i < array_length(parallax_layers); i++) {
			layer_hspeed(parallax_layers[i].id, 0);
		}
	}

	// Freeze particles (they're already in the snapshot, so stop drawing them too)
	paused_particle_systems = [];
	with (obj_player) array_push(other.paused_particle_systems, broom_ps);
	with (obj_parcel) array_push(other.paused_particle_systems, ps_id);
	for (var i = 0; i < array_length(paused_particle_systems); i++) {
		part_system_automatic_update(paused_particle_systems[i], false);
		part_system_automatic_draw(paused_particle_systems[i], false);
	}

	audio_pause_all();
	instance_deactivate_all(true); // true = keep this instance active
}

function resume_game() {
	if (!paused) return;
	paused = false;

	instance_activate_all();
	audio_resume_all();

	for (var i = 0; i < array_length(paused_particle_systems); i++) {
		if (part_system_exists(paused_particle_systems[i])) {
			part_system_automatic_update(paused_particle_systems[i], true);
			part_system_automatic_draw(paused_particle_systems[i], true);
		}
	}
	paused_particle_systems = [];

	free_pause_sprite();
}

function quit_to_menu() {
	// Reactivate first so every instance's CleanUp runs (frees particle systems)
	instance_activate_all();
	audio_stop_all();
	free_pause_sprite();
	room_goto(room_menu);
}

function free_pause_sprite() {
	if (sprite_exists(pause_sprite)) sprite_delete(pause_sprite);
	pause_sprite = -1;
}
