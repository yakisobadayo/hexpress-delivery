randomise(); // So it's not the same each time.
//global.Manager = id;     // <-- a global pointer all objects can see

// Set up variables
global.gamespeed = 4;
tip_multiplier = 1;  // Parcel starts at full health (100%)
collected_tips = 0;
hits = 0;
max_hits = 4;
spacing_modifier = 3; // Modifies spacing between spawns

// Define a timer for how long a section lasts.
section_timer = 4200;
section_timer_ticking = section_timer;

// Roll the conditions for starting section
current_section_conditions = roll_section();

// Spawn condition managers for starting section
spawn_managers(current_section_conditions);

// How many sections in a route
route_active     = true;
routelength = irandom_range(5,8);
currentsection = 0;
deliveredpackages = 0;