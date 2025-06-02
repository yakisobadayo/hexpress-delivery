/// @description Insert description here
// You can write your code in this editor

selected = 1;
animation_time = 0;

play_text = "Play";
exit_text = "Exit";


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