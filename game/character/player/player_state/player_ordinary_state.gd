class_name PlayerOrdinaryState extends PlayerState


## Changes player sprite and speed to the ordinary way.
## Disables movement on water.
func enter():
	# Update player sprite
	var anim_sprite_path = Utils.get_character_sprite_path("green")
	player.anim_sprite.sprite_frames = load(anim_sprite_path)
	player.speed = player.ordinary_speed
	# Disable movement on water
	player.set_collision_mask_value(6, true)


## Moves the player and plays the walking animation.
func move(_delta: float):
	player.move_ordinary()


## Plays the default idle animation.
func animate_idle():
	player.animate_idle()
