/// UI helpers for the YUI screens in datafiles/hexpress/

/// @function ui_open(yui_file, data)
/// @param yui_file  Path of the screen inside datafiles, e.g. "hexpress/menu_screen.yui"
/// @param data      Struct the screen reads from (@field) and calls methods on (@method())
/// @return The yui_document instance (destroy it to close the screen)
function ui_open(_yui_file, _data)
{
    // Draw the GUI at the view's resolution so the pixel art stays crisp
    display_set_gui_size(camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]));

    return instance_create_depth(0, 0, -1000, yui_document, {
        yui_file     : _yui_file,
        data_context : _data,
    });
}

/// @function ui_button(label, action)
/// @desc Data for a text_button widget (see datafiles/hexpress/widgets.yui)
/// @param label   Text to show
/// @param action  Method to call when clicked (YUI can't call plain script functions)
function ui_button(_label, _action)
{
    return {
        label   : _label,
        action  : _action,
        hover   : false, // set by the widget
        focused : false, // set by the widget
    };
}

/// @function ui_toggle_music()
function ui_toggle_music()
{
    global.mute_music = !global.mute_music;

    if (global.mute_music) {
        audio_group_unload(audiogroup_music);
    } else {
        audio_group_load(audiogroup_music);
    }
}

/// @function ui_toggle_sfx()
function ui_toggle_sfx()
{
    global.mute_sfx = !global.mute_sfx;

    if (global.mute_sfx) {
        audio_group_set_gain(audiogroup_default, 0, 0.5);
    } else {
        audio_group_set_gain(audiogroup_default, 1, 0.5);
    }
}
