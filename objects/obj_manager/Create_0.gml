randomise(); // So it's not the same each time.

// Set up variables
global.gamespeed = 4;
spacing_modifier = 3; // Modifies spacing between spawns

// Define a timer for how long a section lasts.
section_timer = 4200;
section_timer_ticking = section_timer;

// Initialize obstacle types
global.obstacle_types = [
	obj_obstacle,
    obj_obstaclevert,
    obj_obstaclediagonal,
	obj_bird_manager,
	obj_rising_manager
];

#region Obstacle code stuff
// Generate the condition definition(s) for the NEXT section
global.current_section_conditions = roll_section();

// Spawn the corresponding manager(s) for the new section on the "Managers" layer
spawn_managers(global.current_section_conditions);

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

/*/
switch (global.deliveredpackages) {
    case 1:
        // code here
        break;
	case 2:
        // code here
        break;
	case 3:
        // code here
        break;
    default:
        // code here
        break;
}
/*/
#endregion

// How many sections in a route
route_active     = true;
global.routelength = irandom_range(5,8);
currentdelivery = 0;
global.deliveredpackages = 0;