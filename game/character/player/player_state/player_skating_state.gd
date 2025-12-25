class_name PlayerSkatingState extends PlayerState

var moved_distance: float


## Changes player sprite and speed to skating.
## Resets movement counter.
func enter():
	var anim_sprite_path = Utils.get_character_sprite_path("green_skating")
	player.anim_sprite.sprite_frames = load(anim_sprite_path)
	player.speed = player.skating_speed
	moved_distance = 0


## For good measure, resets movement counter.
func exit():
	moved_distance = 0


func move(delta: float):
	player.move_ordinary()
	moved_distance += delta * player.speed
