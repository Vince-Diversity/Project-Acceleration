class_name PlayerSkatingState extends PlayerState


## Updates the player sprite.
func enter():
	var anim_sprite_path = Utils.get_character_sprite_path("green_skating")
	player.anim_sprite.sprite_frames = load(anim_sprite_path)
