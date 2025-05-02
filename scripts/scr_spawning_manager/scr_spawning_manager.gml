// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function spawn_manager(){
    if (global.current_obstacle_type == obj_obstacle 
        || global.current_obstacle_type == obj_obstaclediagonal 
        || global.current_obstacle_type == obj_obstaclevert)
    {
        instance_create_layer(0, 0, "Managers", obj_obstacle_manager);
    }
    else {
        instance_create_layer(0, 0, "Managers", global.current_obstacle_type);
    }
}