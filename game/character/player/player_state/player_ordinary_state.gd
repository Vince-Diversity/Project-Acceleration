class_name PlayerOrdinaryState extends PlayerState


## Updates the player sprite.
func enter():
	var anim_sprite_path = Utils.get_character_sprite_path("green")
	player.anim_sprite.sprite_frames = load(anim_sprite_path)
