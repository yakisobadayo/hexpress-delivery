// This is so birds don't try and come at you when you're trying to drop a package
if (instance_exists(obj_house))
{
	missile_timer = global.gamespeed;
	image_speed = 0;
} else {
	missile_timer -= global.gamespeed;
	image_speed = 1;
}

// AIMING
var aim_max_dist = 75;
var diff  = obj_player.y - aim
var dist  = abs(diff);
var t = smoothstep(0, aim_max_dist, dist);
var step = 0.5 + 1.5 * t;

// Spawn projectiles when timer runs out or on key press
if (missile_timer > 0)
{
    aim += sign(diff) * step;
	//aim = lerp(aim, obj_player.y, 0.025);
	if (image_index >= 4) image_index = 4;
}

if (missile_timer <= 0)
{
	// Reset animation on notify bubble:
    image_index = 0;                         // start from the first subimage
	
	//var random_height = irandom_range(32+32, room_height-32);
	instance_create_layer(room_width, aim, "Instances", obj_bird);
	instance_create_layer(room_width+16, aim-16, "Instances", obj_bird);
	instance_create_layer(room_width+16+16, aim-16-16, "Instances", obj_bird);
	missile_timer = 150 * spacing_modifier;
	aim = obj_player.y;
	//audio_play_sound(snd_caw, 10, false);
}


if (instance_exists(obj_house))
{
	image_index = 5;
}

// Rare poop drop
poop_timer -= global.gamespeed;
if (poop_timer <= 0) {
    var _px = clamp(obj_player.x + irandom_range(-32, 32), 32, room_width - 32);
    instance_create_layer(_px, -16, "Instances", obj_bird_poop);
    poop_timer = irandom_range(800, 1400);
}