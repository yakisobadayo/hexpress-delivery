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
global.obstacle_types = [
	obj_obst_hori_manager,
    obj_projectile_manager
];

// Randomly pick an initial obstacle type
var index = irandom(array_length(global.obstacle_types) - 1);
global.current_obstacle_type = instance_create_layer(0, 0, "Instances", global.obstacle_types[index]);