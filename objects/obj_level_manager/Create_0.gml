randomise();		  // So it's not the same each time.
// Set up variables
global.gamespeed = 4; // How fast the game moves
global.coins = 0;     // Coin amount
spacing_modifier = 3; // Modifies spacing between spawns

// How often things spawn
obstacle_timer = 100 * spacing_modifier;    // Time between obstacles
collectable_timer = 100 * spacing_modifier; // Time between collectables (unused)
missile_timer = 500 * spacing_modifier;     // Time between missiles
section_timer = 1000 * spacing_modifier;    // Length of each section


// A list of obstacles to spawn
global.conditions = [
	obj_obstacle,
	obj_obstaclediagonal,
	obj_obstaclevert,
    obj_projectile_manager
];

// Randomly pick an initial obstacle type
var index = irandom(array_length(global.conditions) - 1);
global.current_condition = global.conditions[index];
var condition_instance = instance_create_layer(0, 0, "Instances", global.current_condition);