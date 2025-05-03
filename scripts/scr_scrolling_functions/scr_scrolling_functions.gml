/// @func auto_scroll(_speed_mod = 0)
/// @desc  Moves this instance left by global.gamespeed + _speed_mod
function auto_scroll(_speed_mod = 0) {
    x -= global.gamespeed + _speed_mod;
}

/// @func destroy_offscreen()
/// @desc  Destroys this instance once its right‐hand collision bound moves past x = 0
function destroy_offscreen() {
    if (bbox_right < 0) {
        instance_destroy();
    }
}