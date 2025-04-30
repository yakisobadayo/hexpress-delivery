obstacle_timer -= global.gamespeed;
// Spawn obstacles when timer runs out
if (obstacle_timer <= 0)
{
    switch (global.current_obstacle_type)
    {
        case obj_obstacle:
            instance_create_layer(room_width, irandom_range(32, room_height-32), "Obstacles", obj_obstacle);
            break;

        case obj_obstaclediagonal:
            instance_create_layer(room_width, irandom_range(32, room_height-32), "Obstacles", obj_obstaclediagonal);
            break;

        case obj_obstaclevert:
            instance_create_layer(room_width, irandom_range(32, room_height-32), "Obstacles", obj_obstaclevert);
            break;

        // You can add more cases here (e.g. bird_manager, rising_manager) 
        default:
            // No obstacle to spawn
            break;
    }

    // Reset the timer (this value represents a "distance" rather than fixed time)
    obstacle_timer = 100 * spacing_modifier;
}