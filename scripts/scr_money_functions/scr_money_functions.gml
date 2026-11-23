// Initialise money
global.money = 0;               // Wallet: banked money from finished shifts (persists between sessions)

#macro SAVE_FILE "hexpress_save.ini"

// ─────────────────────────────────────────────────────────────
// UPGRADES (Willow's Workshop)
// Each upgrade has a list of costs, one per level. Level 0 = not bought.
// ─────────────────────────────────────────────────────────────
global.upgrades = [
	{ key : "thermos", name : "Bigger Thermos", desc : "+15 max energy",           costs : [60, 150, 320],  level : 0 },
	{ key : "brew",    name : "Strong Brew",    desc : "Coffee restores +10 energy", costs : [50, 120, 260],  level : 0 },
	{ key : "wrap",    name : "Bubble Wrap",    desc : "Parcels shrug off 1 hit",  costs : [120, 300],      level : 0 },
	{ key : "charm",   name : "Tip Charm",      desc : "+10% tips",                costs : [80, 200, 400],  level : 0 },
];

// ─────────────────────────────────────────────────────────────
// LIFETIME STATS
// ─────────────────────────────────────────────────────────────
global.stats = {
	best_money      : 0,
	best_streak     : 0,
	best_deliveries : 0,
	total_runs      : 0,
	lifetime_money  : 0,
};


/// @func upgrade_level(_key)
/// @desc Returns the purchased level of the upgrade with the given key (0 if none)
function upgrade_level(_key) {
	for (var i = 0; i < array_length(global.upgrades); i++) {
		if (global.upgrades[i].key == _key) return global.upgrades[i].level;
	}
	return 0;
}

/// @func upgrade_is_maxed(_index)
function upgrade_is_maxed(_index) {
	var _u = global.upgrades[_index];
	return _u.level >= array_length(_u.costs);
}

/// @func upgrade_next_cost(_index)
/// @desc Cost of the next level, or -1 if maxed out
function upgrade_next_cost(_index) {
	var _u = global.upgrades[_index];
	if (upgrade_is_maxed(_index)) return -1;
	return _u.costs[_u.level];
}

/// @func upgrade_buy(_index)
/// @desc Attempts to buy the next level. Returns true on success.
function upgrade_buy(_index) {
	var _cost = upgrade_next_cost(_index);
	if (_cost < 0 || global.money < _cost) return false;

	global.money -= _cost;
	global.upgrades[_index].level += 1;
	save_game();
	return true;
}


/// @func save_game()
/// @desc Writes wallet, upgrades and stats to disk
function save_game() {
	ini_open(SAVE_FILE);

	ini_write_real("wallet", "money", global.money);

	for (var i = 0; i < array_length(global.upgrades); i++) {
		ini_write_real("upgrades", global.upgrades[i].key, global.upgrades[i].level);
	}

	var _names = variable_struct_get_names(global.stats);
	for (var i = 0; i < array_length(_names); i++) {
		ini_write_real("stats", _names[i], variable_struct_get(global.stats, _names[i]));
	}

	ini_close();
}

/// @func load_game()
/// @desc Reads wallet, upgrades and stats from disk (missing values fall back to defaults)
function load_game() {
	ini_open(SAVE_FILE);

	global.money = ini_read_real("wallet", "money", 0);

	for (var i = 0; i < array_length(global.upgrades); i++) {
		var _u   = global.upgrades[i];
		var _lvl = ini_read_real("upgrades", _u.key, 0);
		_u.level = clamp(floor(_lvl), 0, array_length(_u.costs));
	}

	var _names = variable_struct_get_names(global.stats);
	for (var i = 0; i < array_length(_names); i++) {
		var _def = variable_struct_get(global.stats, _names[i]);
		variable_struct_set(global.stats, _names[i], ini_read_real("stats", _names[i], _def));
	}

	ini_close();
}

/// @func reset_save()
/// @desc Wipes all progress (debug helper)
function reset_save() {
	global.money = 0;
	for (var i = 0; i < array_length(global.upgrades); i++) {
		global.upgrades[i].level = 0;
	}
	var _names = variable_struct_get_names(global.stats);
	for (var i = 0; i < array_length(_names); i++) {
		variable_struct_set(global.stats, _names[i], 0);
	}
	save_game();
}
