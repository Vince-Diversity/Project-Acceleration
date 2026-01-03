class_name PlayerState extends GDScript
## Base class for [Player] states

## The filename (without the extension) is used as ID for this class.
var state_id: String

## Reference to the player.
var player: Player

## Initialises this class, assigning the ID [member state_id]
## and player
func _init(given_state_id: String, given_player: Player):
	state_id = given_state_id
	player = given_player


## Called when this state becomes the current state.
func enter():
	pass


## Called when this state is removed as the current state.
func exit():
	pass


## Called when the player inputs movement.
func move(_delta: float):
	pass

## Called when there is no player input.
func animate_idle():
	pass
