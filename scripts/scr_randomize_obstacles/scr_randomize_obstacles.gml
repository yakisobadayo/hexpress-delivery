// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function randomize_obstacles(){
    global.current_obstacle_type = global.obstacle_types[irandom(array_length(global.obstacle_types) - 1)];
}