/// @function roll_section()
/// @returns {Array<Struct>} 1-or-2 unique obstacle-definition structs
function roll_section()
{
    var _current = [];

    // --- 1. TERRAIN -------------------------------------------------------
    var _terrain = global.routeConditionsPrimary;

    array_push(_current, _terrain[ irandom(array_length(_terrain) - 1) ]);

    // --- 2. OPTIONAL HAZARD (50 % chance) ---------------------------------
    if (irandom(1))          // returns 0 or 1 → 1 means “add a hazard”
    {
        var _hazards = global.routeConditionsSecondary;
        array_push(_current, _hazards[ irandom(array_length(_hazards) - 1) ]);
    }

    // --- Debug print ------------------------------------------------------
    var _msg = "Generated route conditions: ";
    for (var i = 0; i < array_length(_current); i++)
    {
        _msg += _current[i].type;
        if (i < array_length(_current) - 1) _msg += ", ";
    }
    show_debug_message(_msg);

    return _current;
}


/// @function roll_random_section()
/// @description Generates an array containing 1 or 2 unique obstacle definition structs
///              randomly selected from global.obstacle_definitions.
/// @returns {Array<Struct>} An array of obstacle definition structs.
function roll_random_section()
{
    var _current_conditions = [];
    var _max_index          = array_length(global.route_conditions) - 1;
    
    // Decide how many we want (1 or 2, but never more than we have)
    var _num_to_pick = irandom_range(1, 2);
    _num_to_pick     = min(_num_to_pick, _max_index + 1);

    // --- first pick ---
    var _idx1 = irandom(_max_index);
    array_push(_current_conditions, global.route_conditions[_idx1]);

    // --- second pick (if needed) ---
    if (_num_to_pick == 2)
    {
        var _idx2 = irandom(_max_index);
		while (_idx2 == _idx1)
		{
		    _idx2 = irandom(_max_index);
		}
		array_push(_current_conditions, global.route_conditions[_idx2]);
    }

    // Debug helper (optional)
    var _log = "Generated route conditions: ";
    for (var i = 0; i < array_length(_current_conditions); i++)
    {
        _log += _current_conditions[i].type;
        if (i < array_length(_current_conditions) - 1) _log += ", ";
    }
    show_debug_message(_log);

    return _current_conditions;
}


/// @function spawn_managers_from_definitions(_definitions_array)
/// @description Spawns manager instances based on the provided definition structs
///              onto the "Managers" layer.
/// @param {Array<Struct>} _definitions_array The array of definition structs to spawn managers for.
function spawn_managers(_conditions_array) {
    // Check if the target layer exists (optional but good practice)
    if (!layer_exists("Managers")) {
        show_error("Attempted to spawn managers but layer 'Managers' does not exist!", true);
        return;
    }

    var _num_definitions = array_length(_conditions_array);
    for (var i = 0; i < _num_definitions; i++) {
        var _def = _conditions_array[i]; // Get the current definition struct

        var _manager_to_spawn = _def.manager;
        var _type_to_pass = _def.type;

        // Spawn the manager on the correct layer, passing the subtype
        instance_create_layer(0, 0, "Managers", _manager_to_spawn, {
            type: _type_to_pass
        });

        show_debug_message("Spawned manager: " + object_get_name(_manager_to_spawn) + " for type: " + _def.type);
    }
}


/// @func conditions_to_string(arr)
/// @desc  Turns an array of condition structs into "TypeA, TypeB, …"
function conditions_to_string(_arr)
{
    var _s = "";
    for (var i = 0; i < array_length(_arr); i++)
    {
        _s += _arr[i].type;
        if (i < array_length(_arr) - 1) _s += ", ";
    }
    return _s;
}