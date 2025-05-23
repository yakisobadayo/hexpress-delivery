// Define all your condition types as structs
// For standard conditions managed by obj_obstacle_manager:
global.conditionDef_Horizontal = {
    type: "Horizontal",            // Human-readable name (optional, good for debug)
    manager: obj_obstacle_manager, // The manager responsible for this type
};

global.conditionDef_Vertical = {
    type: "Vertical",
    manager: obj_obstacle_manager,
};

global.conditionDef_Diagonal = {
    type: "Diagonal",
    manager: obj_obstacle_manager,
};

// For conditions with their own dedicated manager:
global.conditionDef_Birds = {
    type: "Birds",
    manager: obj_bird_manager,
};

global.conditionDef_Rising = {
    type: "Ghosts",
    manager: obj_rising_manager,
};

global.conditionDef_Cars = {
	type: "Cars",
    manager: obj_car_manager,
};

// Now, create the list your manager will actually use, containing these structs:
global.routeConditionsPrimary = [
    global.conditionDef_Horizontal,
    global.conditionDef_Vertical,
    global.conditionDef_Diagonal
];

global.routeConditionsSecondary = [
    global.conditionDef_Birds,
    global.conditionDef_Rising,
	global.conditionDef_Cars
];

// You no longer need the old global.obstacle_types array
// global.obstacle_types = [...]; // DELETE THIS OLD LINE