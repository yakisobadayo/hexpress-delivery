randomise(); // So it's not the same each time.

// Set up variables
global.gamespeed = 4;
spacing_modifier = 3; // Modifies spacing between spawns

// How often things spawn
obstacle_timer = 100 * spacing_modifier;
collectable_timer = 100 * spacing_modifier;
missile_timer = 500 * spacing_modifier;

// Define a timer for how long a section lasts.
section_timer = 5000;

#region Obstacle code stuff
// Randomly pick an initial obstacle type.
roll_section_conditions();
spawn_all_managers();
#endregion

// How many sections in a route
route_active     = true;
over             = false;
//global.routelength = irandom_range(5,8);
global.routelength = 5;
currentdelivery = 0;
global.deliveredpackages = 0;

// Reset parcel scoring
global.parcel_scores      = [];             // clear out last run’s scores
global.current_parcel_health = 1;           // start next parcel at 100%