//global.Manager = id;     // <-- a global pointer all objects can see
randomise();         // So it's not the same each time.


// Set up variables
// ROUTE
global.gamespeed = 4;// How fast the world moves
spacing_modifier = 3;// Modifies spacing between spawns

section_timer = 4200;// How long a section of the route lasts
section_timer_ticking = section_timer;

// HOUSES
enum HouseState {    // Possible states for each house in the array:
    PENDING,         // Not reached yet
    DELIVERED,       // Package landed, yay
    MISSED           // Missed house (instance deleted without delivering)
}

route_length = irandom_range(5,8);// How many sections in a route
dropoffs     = array_create(route_length);
for (var i = 0; i < route_length; i++)
    dropoffs[i] = HouseState.PENDING;
current_dropoff = 0;              // The current section of a route
delivered_packages = 0;			  // How many packages were dropped

function spawn_house() {
    if (current_dropoff >= route_length) return;   // safety: no extra houses

    var house = instance_create_layer(room_width, 352, "BackgroundObjects", obj_house);

    house.slot   = current_dropoff;// tell the house which array slot it owns
    house.manager = id;            // so it can talk back

    current_dropoff += 1;          // advance to the next slot
}

// MONEY
tip_multiplier = 1;  // Parcel starts at full health (100%)
collected_tips = 0;  // Collects tips earned

// PARCELS
max_hits = 4;        // How many times a parcel can be hit
hits     = 0;        // Current amount of hits




// ROUTE GENERATION
current_conditions = roll_section(); // Roll the conditions for starting section
spawn_managers(current_conditions);  // Spawn the starting condition managers
route_active     = true;					 // Route is active