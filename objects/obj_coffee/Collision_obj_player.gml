obj_manager.stamina = min(obj_manager.max_stamina, obj_manager.stamina + obj_manager.coffee_restore);
obj_manager.add_popup(x, y - 16, "+" + string(obj_manager.coffee_restore) + " energy", #8CFF8C);
audio_play_sound(snd_restore, 10, false);
instance_destroy(self);