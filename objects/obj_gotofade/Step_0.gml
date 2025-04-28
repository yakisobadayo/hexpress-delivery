/// @description Increment fade and goto room

if (fade_timer_ticking > 0) {
    fade_timer_ticking--;
} else if (roomchange_timer > 0) {
    roomchange_timer--;
} else {
    room_goto(target_room);
}