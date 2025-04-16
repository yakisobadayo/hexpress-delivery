randomise(); // So it's not the same each time.

// Set up variables
global.gamespeed = 4;
global.coins = 0;
spacing_modifier = 3; // Modifies spacing between spawns

// How often things spawn
obstacle_timer = 100 * spacing_modifier;
collectable_timer = 100 * spacing_modifier;
missile_timer = 500 * spacing_modifier;

// Define a timer for how long a section lasts.
section_timer = 5000;

// Initialize obstacle types
global.obstacle_types = [
	obj_obstacle,
    obj_obstaclevert,
    obj_obstaclediagonal,
	obj_bird_manager,
	obj_rising_manager
];

#region Obstacle code stuff
// Randomly pick an initial obstacle type.
global.current_obstacle_type = global.obstacle_types[irandom(array_length(global.obstacle_types) - 1)];


// Check if condition is under the great obstacle tree
if global.current_obstacle_type == obj_obstacle || global.current_obstacle_type == obj_obstaclediagonal || global.current_obstacle_type == obj_obstaclevert
{
	instance_create_layer(0, 0, "Instances", obj_obstacle_manager);
}
else
{
	var condition_instance = instance_create_layer(0, 0, "Instances", global.current_obstacle_type);
}

/*/
function destroy_current_manager() {
	if global.current_obstacle_type == obj_obstacle || global.current_obstacle_type == obj_obstaclediagonal || global.current_obstacle_type == obj_obstaclevert
	{
		// Destroy the obstacle manager
	    if (instance_exists(obj_obstacle_manager)) {
	         instance_destroy(obj_obstacle_manager);
	    }
	}
	else
	{
	    // Destroy the current condition manager
	    if (instance_exists(global.current_obstacle_type)) {
	         instance_destroy(global.current_obstacle_type);
	    }
	}
}

function spawn_current_manager() {
    // Check if condition is under the great obstacle tree
	if global.current_obstacle_type == obj_obstacle || global.current_obstacle_type == obj_obstaclediagonal || global.current_obstacle_type == obj_obstaclevert
	{
		instance_create_layer(0, 0, "Instances", obj_obstacle_manager);
	}
	else
	{
		var condition_instance = instance_create_layer(0, 0, "Instances", global.current_obstacle_type);
	}
}
/*/
#endregion

// How many sections in a route
global.routelength = 5;
currentdelivery = 0;
global.deliveredpackages = 0;