if (!instance_exists(obj_coffee)) {
	spawn_coffee();
	
	coffee_spawn_cooldown = coffee_reset_cooldown;
}