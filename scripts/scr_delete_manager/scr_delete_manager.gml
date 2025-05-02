// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function delete_manager(){
    if (global.current_obstacle_type == obj_obstacle 
     || global.current_obstacle_type == obj_obstaclediagonal 
     || global.current_obstacle_type == obj_obstaclevert)
    {
        if (instance_exists(obj_obstacle_manager))
            instance_destroy(obj_obstacle_manager);
    }
    else {
        if (instance_exists(global.current_obstacle_type))
            instance_destroy(global.current_obstacle_type);
    }
}

/*/
function clear_instances_on_layer(layer_name){
	var layer_id = layer_get_id(layer_name);   // e.g. "Instances"

	var inst = layer_get_first_instance(layer_id);
	while (inst != noone) {
	    // Cache the next pointer *before* destroying
	    var nxt = layer_get_next_instance(inst);
	    with (inst) instance_destroy();
	    inst = nxt;
	}
}

function clean_managers(){
	var layer_id = layer_get_id(layer_name);   // e.g. "Instances"

	var inst = layer_get_first_instance(layer_id);
	while (inst != noone) {
	    // Cache the next pointer *before* destroying
	    var nxt = layer_get_next_instance(inst);
	    with (inst) instance_destroy();
	    inst = nxt;
	}
}