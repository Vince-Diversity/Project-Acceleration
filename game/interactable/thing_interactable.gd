extends Interactable


func check_interaction(given_interactable: Node2D):
	owner.current_state.check_interaction(given_interactable)


func _on_end_interaction():
	if owner.is_oneshot:
		owner.change_state("thing_static_state")
