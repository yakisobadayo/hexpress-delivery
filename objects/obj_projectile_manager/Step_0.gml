obstacle_timer -= global.gamespeed;

// Spawn projectiles when timer runs out
if (obstacle_timer <= 0)
{
	instance_create_layer(room_width, irandom_range(32, room_height-32), "Instances", obj_projectile);
	if (obstacle_timer <= 0) {
		obstacle_timer = 500 * spacing_modifier;
	}
}