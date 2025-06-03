global.mute_music = !global.mute_music;

if (global.mute_music) {
	audio_group_unload(audiogroup_music);
} else {
	audio_group_load(audiogroup_music);
}