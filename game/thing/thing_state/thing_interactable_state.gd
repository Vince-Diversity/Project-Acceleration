class_name ThingInteractableState extends ThingState


func enter():
	thing.interact_area.set_disabled(false)


func exit():
	pass


func check_interaction(given_interactable: Node2D):
	if given_interactable == thing:
		thing.begin_interaction.emit(thing)