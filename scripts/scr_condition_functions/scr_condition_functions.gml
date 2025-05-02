/// roll_section_conditions()
///  • Picks one main pillar type (horizontal/vertical/diagonal).
///  • 50% chance to add either birds or ghosts.
///  • Stores the result in current_conditions for your UI/logic.
function roll_section_conditions()
{
    // 1) Pick the main obstacle subtype
    var main_choices = [ "horizontal", "vertical", "diagonal" ];
    var main_pick    = choose_array(main_choices);

    // Create the array and push the first struct
    current_conditions = [ get_condition_def(main_pick) ];

    // 2) 50% chance to add an extra condition
    if (random(1) < 0.5) {
        var extra = choose_array([ "bird_swarm", "ghost_rise" ]);
        array_push(current_conditions, get_condition_def(extra));
    }

    // current_conditions is now ready for spawning or UI
}


/// spawn_manager(def)
///  • Spawns one manager based on the given definition struct.
function spawn_manager(def)
{
    var mgr = instance_create_layer(0, 0, "Managers", def.prefab);
    mgr.spawn_subtype = def.type;
    mgr.hint_text     = def.blurb;
}


/// spawn_all_managers()
///  • Iterates over current_conditions and uses spawn_manager() for each.
function spawn_all_managers()
{
    var count = array_length(current_conditions);
    for (var i = 0; i < count; ++i)
    {
        spawn_manager(current_conditions[i]);
    }
}


// Helper: pick a random element from any array
function choose_array(arr) {
    return arr[ irandom(array_length(arr) - 1) ];
}

/*------------------------------------------------------------------
    get_condition_def(type_name)
    • Looks through the global.conditions array.
    • If it finds a struct whose .type matches the string you gave
      (e.g., "diagonal"), it returns that struct.
    • If it doesn’t find anything, it returns undefined.
------------------------------------------------------------------*/
function get_condition_def(type_name)
{
    // Loop over every element in global.conditions
    for (var i = 0; i < array_length(global.conditions); i++)
    {
        var d = global.conditions[i];   // d is the struct at index i

        // Does its .type field equal the type we’re looking for?
        if (d.type == type_name)
        {
            return d;                   // ✔ Found it → give the struct back
        }
    }

    return undefined;   // ❌ Didn’t find anything → return undefined
}