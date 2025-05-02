// Initialize everything
global.conditions = [
    {
        type   : "horizontal",
        prefab : obj_obstacle_manager,
        blurb  : "Chunks of ground have started levitating"
    },
    {
        type   : "vertical",
        prefab : obj_obstacle_manager,
        blurb  : "Watch out for vertical bars. (Temp sprite)"
    },
    {
        type   : "diagonal",
        prefab : obj_obstacle_manager,
        blurb  : "Floating crystals ahead"
    },
    {
        type   : "birds",
        prefab : obj_bird_manager,
        blurb  : "Bird migration underway"
    },
    {
        type   : "ghosts",
        prefab : obj_rising_manager,
        blurb  : "Ghosts rising from the dead"
    }
];

global.space_pressed = false;//Tutorial mode (doesn't show once you pressed space)
global.tip_money = 0;        //This is your currency.