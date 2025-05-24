obj_manager.stamina = min(obj_manager.max_stamina, obj_manager.stamina + 20);
audio_play_sound(snd_restore, 10, false);
instance_destroy(self);