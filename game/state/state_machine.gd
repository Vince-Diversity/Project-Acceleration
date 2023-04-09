class_name StateMachine extends GDScript

var state_list: Dictionary
var current_state: State
var previous_state: State


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
	previous_state = current_state
	current_state = state_list[state_id]
	current_state.enter()


func change_to_previous_state() -> void:
	if is_instance_valid(previous_state):
		current_state = previous_state
		previous_state = null
