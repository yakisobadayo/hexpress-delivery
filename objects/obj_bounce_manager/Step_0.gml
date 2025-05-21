if (obj_player.grounded && obj_manager.current_section == obj_manager.houses_passed) {
	instance_create_layer(obj_player.x, 352, "Instances", obj_mushroom);
}