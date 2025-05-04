/// @function trigger_hit()
/// @description Initiates the player's hit state (stun, damage, sound)
function trigger_hit()
{
    if (!stunned) {
        stunned = true;
        booster = false;
        y_velocity = 0;
        alarm_set(0, 0.4 * room_speed);
        global.current_parcel_health = max(0, global.current_parcel_health - 0.1);
        audio_play_sound(snd_impact, 10, false, 1, 0, random_range(0.9, 1.1));
    }
}