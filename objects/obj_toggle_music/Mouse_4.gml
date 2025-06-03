global.mute_music = !global.mute_music;

if (global.mute_music) {
	audio_group_set_gain(audiogroup_music, 0, 0.5);
} else {
	audio_group_set_gain(audiogroup_music, 1, 0.5);
}