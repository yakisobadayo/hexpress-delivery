randomise();         // So it's not the same each time.


// VARIABLE INIT
// GAMESTATES
enum GameState {
    PENDING,
    ACTIVE,
    FINISHED
}

// ROUTE
game_state = GameState.PENDING;
global.gamespeed = 4;// How fast the world moves
spacing_modifier = 3;// Modifies spacing between spawns

section_timer = 4200;// How long a section of the route lasts
section_timer_ticking = section_timer;

route_length = irandom_range(5,8);// How many sections in a route
current_section = 0;              // The current section of a route

// MONEY
collected_tips = 0;  // Collects tips earned
combo_multiplier  = 1;  // Increases each successful delivery

// PARCELS
function make_parcel() {
    return {
        max_hits : 4,
        hits     : 4,
        combo    : 1
    };
}
current_parcel = make_parcel();   // The parcel you're delivering
delivered_parcels = 0;

// HOUSES
function make_house() {
    return {
        delivered : false
    };
}
houses_passed = 0;                // Identical to current_section but only increments when a house is destroyed

// FUNCTION INIT
// Registers a hit to the parcel
function register_hit(_hits) {
    current_parcel.hits = max(0, current_parcel.hits - _hits);
}

// Spawns a house
function house_spawn() {
    if (current_section >= route_length) return;   // safety: no extra houses
    var h = instance_create_layer(room_width, 352, "BackgroundObjects", obj_house);
	h.delivered = false;
    current_section += 1;         // advance to the next slot
}

// Trigger for dropping parcel (passes data to parcel)
function drop_parcel(_x, _y) {
	if (delivered_parcels >= route_length) return; // Cancel when reached max
	instance_create_layer(_x, _y, "Instances", obj_parcel, current_parcel);
	current_parcel = make_parcel();
}

// Registers a parcel as delivered + adds money to collected
function register_delivery(_payout) {
	delivered_parcels = min(delivered_parcels + 1, route_length);
	collected_tips += _payout;
}

// Get tip payout


// ROUTE GENERATION
current_conditions = roll_section(); // Roll the conditions for starting section
//spawn_managers(current_conditions);  // Spawn the starting condition managers