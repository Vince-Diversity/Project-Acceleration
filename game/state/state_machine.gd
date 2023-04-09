class_name StateMachine extends GDScript

var state_list: Dictionary
var current_state: State


func _init(given_current_state: State):
	add_state(given_current_state)
	current_state = given_current_state


func add_state(state: State):
	state_list[state.state_id] = state


func update_state(delta: float):
	current_state.update(delta)


func handle_input_state(event: InputEvent):
	current_state.handle_input(event)


func handle_unhandled_input_state(event: InputEvent):
	current_state.handle_unhandled_input(event)


func change_state(state_id: String):
	current_state.exit()
	current_state = state_list[state_id]
	current_state.enter()


func grab_state_focus():
	current_state.grab_focus()
