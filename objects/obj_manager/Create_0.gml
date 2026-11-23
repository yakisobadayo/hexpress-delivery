randomise();         // So it's not the same each time.
global.space_pressed = false;

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
base_gamespeed  = 4;    // Starting speed of the shift
max_gamespeed   = 6.5;  // Speed cap
speed_ramp      = 0.12; // Speed added for every house section survived
spacing_modifier = 3;// Modifies spacing between spawns

section_timer = 3200;// How long a section of the route lasts
section_timer_ticking = section_timer;

//route_length = irandom_range(5,8);// How many sections in a route
current_section = 0;              // The current section of a route

// MONEY
// Base
base_pay = 5;          // How much for each delivery
base_tip = 20;			// Base for calculating tip money
// Current collected
collected_base_pay = 0; // Collects base pay from successful delivery
collected_tips     = 0; // Collects tips earned
// collected_money = collected_base_pay + collected_tips; Tips and base pay combined
// Displayed money - money that’s visually counted-up
displayed_money    = 0;
// Tween settings
money_step         = 1;          // px per frame
target_money       = 0;

// STREAK
streak = 0;
highest_streak = 0;

// RATING
rating_history = [];
current_rating = 4.0;	  // The rating starts at a neutral 3 stars
reactivity_factor = 0.4;		  // How much a new score affects the average. 0.1=slow, 0.9=very fast. 0.3-0.5 is a good start.

// UPGRADES (bought in Willow's Workshop on the menu)
upg_thermos = upgrade_level("thermos"); // +15 max stamina per level
upg_brew    = upgrade_level("brew");    // +10 coffee restore per level
upg_wrap    = upgrade_level("wrap");    // +1 absorbed hit per parcel per level
upg_charm   = upgrade_level("charm");   // +10% tips per level

coffee_restore = 15 + upg_brew * 10;

// PARCELS
function make_parcel() {
    return {
        max_hits : 4,
        hits     : 4,
        shield   : upg_wrap, // Bubble Wrap absorbs this many hits
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
max_stamina = 100 + upg_thermos * 15;
stamina = max_stamina;
display_stamina = stamina;

// RANDOM SPAWN COOLDOWN 
obstacle_spawn_cooldown = 0;
coffee_spawn_cooldown = 0;
obstacle_reset_cooldown = 900;
coffee_reset_cooldown = 300;

first_coffee = false;

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

// Return tip multiplier based on current rating
// if rating ≥ 4 ★ :   1 + (rating - 4)
// else             :   rating / 4
function get_rating_multiplier() {
	var mult = round(current_rating * 10) / 10; // Round to 1dp
	
    return (mult >= 4)
           ? (1 + (mult - 4))
           : (mult / 4);
}


// Lerp (linear interpolate) the current rating towards the new one
function register_rating(_rating) {
	array_push(rating_history, _rating);
    if (_rating > current_rating) {
        current_rating = lerp(current_rating, _rating, reactivity_factor);
    }
    else if (_rating < 4.0) {
        current_rating = lerp(current_rating, _rating, reactivity_factor);
    }
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
	if (current_parcel.shield > 0) {
		// Bubble Wrap soaks up the hit instead of the parcel
		current_parcel.shield -= 1;
		audio_play_sound(snd_boing, 10, false, 0.6, 0, 1.4);
		add_popup(obj_player.x, obj_player.y - 24, "*pop!* Wrap saved it", #9FE7FF);
	} else {
		play_hit_sound(current_parcel.hits)
	    current_parcel.hits = max(0, current_parcel.hits - _hits);
	}
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

function spawn_coffee() {
	var y_spawn = irandom_range(64, room_height - 64);
	instance_create_layer(room_width, y_spawn, "Instances", obj_coffee);
	show_debug_message("Spawned a Potion of Caffeine");
	
	if (!first_coffee) first_coffee = true;
}

// Trigger for dropping parcel (passes data to parcel)
function drop_parcel(_x, _y) {
	instance_create_layer(_x, _y, "Instances", obj_parcel, current_parcel);
	//stamina = max(0, stamina - 2); // Delivery = -2 stamina
}

// Registers a parcel as delivered + adds money to collected
function register_delivery(_multiplier) {
	var rating_mult   = get_rating_multiplier();
	var current_money = collected_base_pay + collected_tips;
	var streak_mult   = get_streak_multiplier();
	var charm_mult    = 1 + upg_charm * 0.10;
	var tip_money     = round(base_tip * _multiplier * rating_mult * streak_mult * charm_mult);
	
	delivered_parcels  += 1;
	collected_base_pay += base_pay;
	collected_tips     += tip_money;
	
	show_debug_message(string(
        "Earned ${0} with base ${1} + tips ${2} (rating {5}, rating_mult {4}×)",
        base_pay + tip_money,
        base_pay,
        tip_money,
        _multiplier,
        rating_mult,
        current_rating
    ));
	
	// Streak
	if (_multiplier >= 1) {
		streak += 1;
	} else {
		streak = 0;
	}
	
	if (streak > highest_streak) {
		highest_streak = streak;
	}
	
	// Money increment
	// 1. stash the new real-world total
	var new_total = collected_base_pay + collected_tips;

	// 2. set a target for the tween
	target_money = new_total;

	// 3. kick off the “ka-ching” loop-sound once
	if (!audio_is_playing(snd_increment)) {
	    audio_play_sound(snd_increment, 5, true, 0.5);
	}
	
	return base_pay + tip_money;
}

// Advances to next house and package
function next_delivery() {
	houses_passed += 1;
	current_parcel = make_parcel();
}

// FLOATING POPUPS
// Little bits of text that drift upward and fade (e.g. "+$32", "PERFECT!")
popups = [];
function add_popup(_x, _y, _text, _col = c_white, _life = 70) {
	array_push(popups, {
		px : _x,
		py : _y,
		text : _text,
		col : _col,
		life : _life,
		max_life : _life,
	});
}

// Returns a short word + colour describing a 0-5 star delivery
function stars_to_praise(_stars) {
	switch (_stars) {
		case 5:  return { text : "PERFECT!",  col : #FFE45C };
		case 4:  return { text : "Great!",    col : #8CFF8C };
		case 3:  return { text : "Nice",      col : c_white };
		case 2:  return { text : "Meh...",    col : #C8C8C8 };
		case 1:  return { text : "Barely...", col : #FFA060 };
		default: return { text : "Missed!",   col : #FF6060 };
	}
}

// SCROLLING BACKGROUND LAYERS
// Remember each background layer's base speed so parallax can scale with game speed
bg_layers = [];
var _all_layers = layer_get_all();
for (var i = 0; i < array_length(_all_layers); i++) {
	var _l = _all_layers[i];
	if (layer_background_get_id(_l) != -1) {
		array_push(bg_layers, { lyr : _l, base : layer_get_hspeed(_l) });
	}
}

// Ends the shift: bank money, update lifetime stats and save
results = undefined;
function finish_shift() {
	var total_payout = collected_base_pay + collected_tips;
	
	// Average of every rating given out this shift
	var _avg = 0;
	var _n = array_length(rating_history);
	for (var i = 0; i < _n; i++) _avg += rating_history[i];
	_avg = (_n > 0) ? (_avg / _n) : 0;
	
	results = {
		money        : total_payout,
		deliveries   : delivered_parcels,
		streak       : highest_streak,
		rating       : _avg,
		has_rating   : _n > 0,
		houses       : current_section,
		new_money    : total_payout > global.stats.best_money,
		new_streak   : highest_streak > global.stats.best_streak,
		new_delivery : delivered_parcels > global.stats.best_deliveries,
	};
	
	global.money += total_payout;
	global.stats.total_runs     += 1;
	global.stats.lifetime_money += total_payout;
	global.stats.best_money      = max(global.stats.best_money, total_payout);
	global.stats.best_streak     = max(global.stats.best_streak, highest_streak);
	global.stats.best_deliveries = max(global.stats.best_deliveries, delivered_parcels);
	save_game();
	
	show_debug_message(string("Route ended! Earned: ${0}, total money: ${1}", total_payout, global.money));
}


// ROUTE GENERATION
current_conditions = roll_section(); // Roll the conditions for starting section
//spawn_managers(current_conditions);  // Spawn the starting condition managers


// ANIM CURVE
badge_ease = 11-185;
end_ease = room_height+128;

// Timer before end
end_timer = room_speed * 1;
show_results = false;

// Music
music_volume = 0.9;
audio_sound_gain(mus_route_3_loop_real, music_volume, 0);