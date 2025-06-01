if (global.debug_mode) {
	with (obj_player) {
		if (y < room_height / 2) {
			// Player is in the upper half -> spawn witch at ceiling
			instance_create_layer(room_width, 32, "Instances", obj_witch);
		} else {
			// Player is in the lower half -> spawn car on the floor
			instance_create_layer(room_width, room_height - 32, "Instances", obj_car);
		}
	}
}