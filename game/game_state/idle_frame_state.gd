class_name IdleFrameState extends GameState
## Workaround for various physics to update properly before changing to a new
## [GameState] by waiting one frame.
##
## Solves the problem that disabling [InteractArea] on the same frame
## the game state switches to [RoamState], the area is still enabled for one frame.

## the current [Room]
var _room: Room

## The [member state_id] to enter when this state ends.
var next_state_id: String

## Counts to one before changing [GameState].
var counter := 0

## Initialises this state.
func init_state(given_room: Room):
	_room = given_room


## Assigns properties that are used when this state ends.
func make_state(given_state_id: String):
	next_state_id = given_state_id


## Ends this state on the second frame.
## The state change call is deferred so that this state can end properly too
## if needed.
func update(_delta):
	if counter > 5:
		_room.stm.change_states.call_deferred(next_state_id)
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
	next_state_id = ""
	counter = 0


## No control is relevant for taking focus during this state.
func grab_focus():
	pass


## Doesn't save anything during this state.
func save(_game: Game, _sg: SaveGame):
	pass
