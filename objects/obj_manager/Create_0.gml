randomise();         // So it's not the same each time.


// VARIABLE INIT
// ROUTE
global.gamespeed = 4;// How fast the world moves
spacing_modifier = 3;// Modifies spacing between spawns

section_timer = 4200;// How long a section of the route lasts
section_timer_ticking = section_timer;

route_length = irandom_range(5,8);// How many sections in a route
current_section = 0;              // The current section of a route
delivered_packages = 0;			  // How many packages were dropped

function spawn_house() {
    if (current_section >= route_length) return;   // safety: no extra houses
    var house = instance_create_layer(room_width, 352, "BackgroundObjects", obj_house);
	house.delivered = false;
	current_house = house;
    current_section += 1;         // advance to the next slot
}

// MONEY
tip_multiplier = 1;  // Parcel starts at full health (100%)
collected_tips = 0;  // Collects tips earned

// PARCELS
max_hits = 4;        // How many times a parcel can be hit
hits     = 0;        // Current amount of hits


// FUNCTION INIT
// Modifies hit count
function register_hit(_hit, _mult_modifier){
    hits += _hit;
	if (hits > max_hits){ // Clamp hit
		hits = max_hits;
	}
	
	tip_multiplier += _mult_modifier;
	if (tip_multiplier < 0){ // Clamp multiplier
		tip_multiplier = 0;
	}
}

// Resets the stats for the next package
function reset_package_stats(){
    tip_multiplier = 1;
	hits = 0;
}

// Trigger for dropping parcel (passes multiplier to package)
function drop_parcel(_x, _y){
	// Drop parcel
	var parcel = instance_create_layer(_x, _y, "Instances", obj_parcel);
	parcel.tip_multiplier = tip_multiplier;
	
	// Reset for the next delivery: Restore parcel health to 100%.
    reset_package_stats();
}

// Calculate money from package
function confirm_delivery(_tip_multiplier, _success){
	// True = successful delivery, False = failed delivery
	// Collected tips (base tip of 50 multiplied by health multiplier)
	if _success {
		collected_tips += global.base_tip*_tip_multiplier;
	}
            
    // Increment delivered package count.
    delivered_packages += 1;
}


// ROUTE GENERATION
current_conditions = roll_section(); // Roll the conditions for starting section
spawn_managers(current_conditions);  // Spawn the starting condition managers
route_active     = true;					 // Route is active