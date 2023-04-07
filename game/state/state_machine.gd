class_name StateMachine extends GDScript

var state_list: Dictionary
var current_state: State


func add_state(state: State) -> void:
	state_list[state.state_id] = state


func update_state(delta: float) -> void:
	current_state.update(delta)


func handle_input() -> void:
	pass


func change_state(state_id: String) -> void:
	current_state = state_list[state_id]
