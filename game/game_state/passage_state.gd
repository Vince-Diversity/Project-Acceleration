class_name PassageState extends GameState
## Enables a previous state to finish completely before changing [Room] nodes
## by allowing it to switch this teporary state and, for good measure, waiting one frame.
##
## Solves the problem that when
## changing rooms during a cutscene, the game is still in a [CutsceneState].
## Because the [member Game.cache] does not get updated with the changes
## done during a cutscene, the game needs to exit the [CutsceneState]
## into a new state before changing rooms. This state implements such
## a temporary state.

## The [member Room.room_id] to enter when this state ends.
var next_room_id: String

## The [member Room.entrance_node] to enter when this state ends.
var next_entrance_node: String

## the current [Room]
var _room: Room

## Counts to one before changing rooms.
var counter := 0

## Initialises this state.
func init_state(given_room: Room):
	_room = given_room


## Assigns properties of the next room that is entered when this state ends.
func make_state(given_room_id, given_entrance_node):
	next_room_id = given_room_id
	next_entrance_node = given_entrance_node


## Changes rooms on the second frame.
## The [GameState] will then be changed by entering a new [Room] instance.
func update(_delta):
	if counter > 0:
		_room.change_rooms(next_room_id, next_entrance_node)
	else:
		counter += 1


## No input is received.
func handle_input(_event: InputEvent):
	pass


## Nothing is called when entering this state.
func enter():
	pass


## Resets properties exiting this state.
func exit():
	next_room_id = ""
	next_entrance_node = ""
	counter = 0


## No control is relevant for taking focus during this state.
func grab_focus():
	pass


## Doesn't save anything during this state.
func save(_game: Game, _sg: SaveGame):
	pass
