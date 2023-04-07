class_name StateMachine extends GDScript

var state_list: Dictionary
var current_state: State
var previous_state: State


func add_state(state: State):
	state_list[state.state_id] = state


func update_state(delta: float):
	current_state.update(delta)


func handle_input():
	pass


func change_state(state_id: String):
	previous_state = current_state
	current_state = state_list[state_id]


func change_to_previous_state() -> void:
	if is_instance_valid(previous_state):
		current_state = previous_state
		previous_state = null
