global.mute_sfx = !global.mute_sfx;

if (global.mute_sfx) {
	audio_group_set_gain(audiogroup_default, 0, 0.5);
} else {
	audio_group_set_gain(audiogroup_default, 1, 0.5);
}