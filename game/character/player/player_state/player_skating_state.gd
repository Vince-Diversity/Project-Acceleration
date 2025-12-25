class_name PlayerSkatingState extends PlayerState

var moved_distance: float


## Changes player sprite and speed to skating.
## Set movement counter so that the next movement frame adds skating ice.
func enter():
	var anim_sprite_path = Utils.get_character_sprite_path("green_skating")
	player.anim_sprite.sprite_frames = load(anim_sprite_path)
	player.speed = player.skating_speed
	moved_distance = player.skating_ice_wavelength


## For good measure, resets movement counter.
func exit():
	moved_distance = 0


func move(delta: float):
	player.move_ordinary()
	moved_distance += delta * player.speed
	if moved_distance > player.skating_ice_wavelength:
		# add a new ice instance to the scene tree
		player.add_skating_ice()
		moved_distance = 0
