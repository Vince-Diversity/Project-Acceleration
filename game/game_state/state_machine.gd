class_name StateMachine extends GDScript
## Manages different [GameState] instances in a game session.

## List of [GameState] instances labeled by each respective [member GameState.state_id].
var state_list: Dictionary

## Current active game session state instance.
var current_state: GameState


func _init(given_current_state: GameState):
	add_state(given_current_state)
	current_state = given_current_state
	current_state.enter()


## Appends the given state to the [member state_list].
func add_state(state: GameState):
	state_list[state.state_id] = state


## Called at every [method Node._physics_process] frame update.
func update_state(delta: float):
	current_state.update(delta)


## Called at every [method Node._input] event.
func handle_input_state(event: InputEvent):
	current_state.handle_input(event)


## Changes the [member current_state] with the state corresponding to the given [code]state_id[/code].
func change_states(state_id: String):
	current_state.exit()
	current_state = state_list[state_id]
	current_state.enter()


## When multiple control nodes are instanced,
## this is called to manage the current focus.
func grab_state_focus():
	current_state.grab_focus()


## Called when saving the given save_game.
func save_state(game: Game, save_game: SaveGame):
	current_state.save(game, save_game)
