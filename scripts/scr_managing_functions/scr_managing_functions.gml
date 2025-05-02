/// @function roll_section()
/// @description Generates an array containing 1 or 2 unique obstacle definition structs
///              randomly selected from global.obstacle_definitions.
/// @returns {Array<Struct>} An array of obstacle definition structs.
function roll_section() {
    var _current_conditions = []; // Array to hold the chosen definitions
    var _num_to_pick = irandom_range(1, 2); // Decide how many types for this section

    // Make sure we don't try to pick more than available
    _num_to_pick = min(_num_to_pick, array_length(global.route_conditions));

    // Create a temporary copy of the available definitions to pick from
    var _available_conditions = array_clone(global.route_conditions);

    // Shuffle the temporary array to easily pick unique random elements
    array_shuffle(_available_conditions);

    // Pick the required number of unique definitions
    for (var i = 0; i < _num_to_pick; i++) {
        // Add the definition from the shuffled array to our result
        array_push(_current_conditions, _available_conditions[i]);
    }

    // --- Logging for Debug ---
    var _log_string = "Generated route conditions: ";
    for (var i = 0; i < array_length(_current_conditions); i++) {
        _log_string += _current_conditions[i].type;
        if (i < array_length(_current_conditions) - 1) {
            _log_string += ", ";
        }
    }
    show_debug_message(_log_string);
    // --- End Logging ---

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

        var _manager_to_spawn = _def.manager_object;
        var _type_to_pass = _def.type;

        // Spawn the manager on the correct layer, passing the subtype
        instance_create_layer(0, 0, "Managers", _manager_to_spawn, {
            obstacle_type: _type_to_pass
        });

        show_debug_message("Spawned manager: " + object_get_name(_manager_to_spawn) + " for type: " + _def.type);
    }
}