extends Interactable


func check_interaction(given_interactable: Node2D):
	if given_interactable == owner:
		begin_interaction.emit(owner)


func _on_end_interaction():
	pass
