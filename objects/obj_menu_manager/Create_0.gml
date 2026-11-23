/// @description Insert description here
// You can write your code in this editor

selected = 1;
animation_time = 0;

play_text = "Play";
shop_text = "Shop";
exit_text = "Exit";

// SHOP (Willow's Workshop)
shop_open     = false;
shop_hover    = -1;     // Which upgrade row the mouse is over (-1 = none)
shop_back_hover = false;
shop_flash    = 0;      // Frames left on the "can't afford" flash
shop_flash_row = -1;
shop_w = 400;
shop_h = 252;
shop_x = 0;             // Set in Step (centred in room)
shop_y = 0;
shop_row_h = 46;
shop_rows_y = 30;       // Offset of the first row from the panel top


// DEBUG MODE
konami_pattern = [
    vk_up, vk_up,
    vk_down, vk_down,
    vk_left, vk_right,
    vk_left, vk_right,
    ord("B"), ord("A")
];
konami_index = 0;
konami_length = array_length(konami_pattern);