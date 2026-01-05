class_name PlayerState extends GDScript
## Base class for [Player] states
##
## Some player states can change how the player appears.
## The character sprite is updated when creating child classes.
## The character profile images are stored in directories
## with directory names given by [member profile_dir_name].


## The filename (without the extension) is used as ID for this class.
var state_id: String

## Reference to the player.
var player: Player

## Profile images directory name assigned by certain player states.
var profile_dir_name: String


## Initialises this class, assigning the ID [member state_id]
## and player.
func _init(given_state_id: String, given_player: Player):
	state_id = given_state_id
	player = given_player


## Initialises this class.
## Assigns profile directories for player states that change appearance.
func init_state():
	pass


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
