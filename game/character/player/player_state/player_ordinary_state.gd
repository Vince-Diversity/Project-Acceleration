class_name PlayerOrdinaryState extends PlayerState
## Default player state.


## Initialises this class.
func init_state():
	profile_dir_name = "green"


## Changes player sprite and speed to the ordinary way.
func enter():
	# Update player sprite
	var anim_sprite_path = Utils.get_character_sprite_path("green")
	player.anim_sprite.sprite_frames = load(anim_sprite_path)
	player.speed = player.ordinary_speed


## Moves the player and plays the walking animation.
func move(_delta: float):
	player.move_ordinary()


## Plays the default idle animation.
func animate_idle():
	player.animate_idle()
