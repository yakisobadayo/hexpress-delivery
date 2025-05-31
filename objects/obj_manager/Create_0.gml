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

section_timer = 3200;// How long a section of the route lasts
section_timer_ticking = section_timer;

//route_length = irandom_range(5,8);// How many sections in a route
current_section = 0;              // The current section of a route

// MONEY
base_pay = 10;          // How much for each delivery
base_tip = 10;			// Base for calculating tip money
collected_base_pay = 0; // Collects base pay from successful delivery
collected_tips     = 0; // Collects tips earned
// collected_money = collected_base_pay + collected_tips; Tips and base pay combined

streak = 0;

// PARCELS
function make_parcel() {
    return {
        max_hits : 4,
        hits     : 4,
    };
}
current_parcel = make_parcel();   // The parcel you're delivering
delivered_parcels = 0;

// HOUSES
function make_house() {
    return {
        delivered : false,
    };
}
houses_passed = 0;                // Identical to current_section but only increments when a house is destroyed

// STAMINA
max_stamina = 100;
stamina = max_stamina;

// SPRITE SHAKE
shake = 0;
shake_amount = 1;


// FUNCTION INIT
// Return tip multiplier based on current streak
// Formula: 1 + (streak × 0.1) … capped at 2.0 ×
function get_streak_multiplier() {
    var mult = 1 + streak * 0.10;   // +10 % per successful delivery
    return clamp(mult, 1, 2);       // never lower than 1×, never higher than 2×
}

// Play hit sound
function play_hit_sound(hit_count) {
    if (hit_count == 1) {
        audio_play_sound(snd_impact_fragile, 10, false, 1, 0, random_range(0.9, 1.1));
    }
    else /*if (hit_count > 0)*/ {
        audio_play_sound(snd_impact, 10, false, 1, 0, random_range(0.9, 1.1));
    } /*
	else {
		audio_play_sound(snd_impact, 10, false, 0.75, 0, random_range(0.9, 1.1));
	} */
}

// Registers a hit to the parcel
function register_hit(_hits) {
	play_hit_sound(current_parcel.hits)
    current_parcel.hits = max(0, current_parcel.hits - _hits);
	stamina = max(0, stamina - 5); // Hit = -5 stamina
	shake = shake_amount;
	alarm_set(0, 0.3 * room_speed);
}

// Spawns a house
function house_spawn() {
    //if (current_section >= route_length) return;   // safety: no extra houses
    current_house = instance_create_layer(room_width, 352, "BackgroundObjects", obj_house);
	current_house.delivered = false;
	current_house.success   = false;
    current_section += 1;         // advance to the next slot
}

// Trigger for dropping parcel (passes data to parcel)
function drop_parcel(_x, _y) {
	instance_create_layer(_x, _y, "Instances", obj_parcel, current_parcel);
	//stamina = max(0, stamina - 2); // Delivery = -2 stamina
}

// Registers a parcel as delivered + adds money to collected
function register_delivery(_multiplier) {
	var streak_mult   = get_streak_multiplier();
	var current_money = collected_base_pay + collected_tips;
	var tip_money     = round(base_tip * _multiplier * streak_mult);
	
	delivered_parcels  += 1;
	collected_base_pay += base_pay;
	collected_tips     += tip_money;
	
	// Streak
	if (_multiplier >= 1) {
		streak += 1;
	} else {
		streak = 0;
	}
	
	show_debug_message(string(
        "Earned ${0} with base ${1} + tips ${2} (streak_mult {4}×)",
        base_pay + tip_money,
        base_pay,
        tip_money,
        _multiplier,
        streak_mult,
        streak
    ));
}

// Advances to next house and package
function next_delivery() {
	houses_passed += 1;
	current_parcel = make_parcel();
}

// Get tip payout


// ROUTE GENERATION
current_conditions = roll_section(); // Roll the conditions for starting section
//spawn_managers(current_conditions);  // Spawn the starting condition managers