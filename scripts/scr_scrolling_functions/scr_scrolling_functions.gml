// SPEED SCALING
// Every hardcoded speed in the game is tuned for BASE_GAMESPEED. As global.gamespeed
// rises, everything is "fast-forwarded": velocities scale by speed_scale(),
// accelerations by speed_scale()², and durations by 1/speed_scale().
#macro BASE_GAMESPEED 4

// How much the player's (and other vertical) physics fast-forward with the world
// 0 = vertical physics never change, 1 = full fast-forward, 0.5 = somewhere in between
#macro VERTICAL_SPEED_EXPONENT 0.5

/// @func speed_scale()
/// @desc  How many times faster the world is moving than at BASE_GAMESPEED
function speed_scale() {
    return global.gamespeed / BASE_GAMESPEED;
}

/// @func vertical_scale()
/// @desc  speed_scale() adjusted by VERTICAL_SPEED_EXPONENT, for vertical physics
function vertical_scale() {
    return power(speed_scale(), VERTICAL_SPEED_EXPONENT);
}

/// @func auto_scroll(_speed_mod = 0)
/// @desc  Moves this instance left by global.gamespeed + _speed_mod
///        (_speed_mod is given at BASE_GAMESPEED and scales with the world)
function auto_scroll(_speed_mod = 0) {
    x -= global.gamespeed + _speed_mod * speed_scale();
}

/// @func destroy_offscreen()
/// @desc  Destroys this instance once its right‐hand collision bound moves past x = 0
function destroy_offscreen() {
    if (bbox_right < 0) {
        instance_destroy();
    }
}
