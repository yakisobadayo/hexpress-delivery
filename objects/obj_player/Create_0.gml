// obj_player: Create Event
grav = 0.15;
y_velocity = 0;
booster = false;
//init_y = room_height - 130;
//y = init_y;  // set player's starting verti cal position

in_house_bounds = false;
stunned = false;
colliding = false;

global.current_parcel_health = 1;  // Parcel starts at full health (100%)
global.parcel_scores = [];           // An array to hold each delivered parcel's health value