class_name ThingPermeableState extends ThingState


func enter():
	thing.interact_area.set_disabled(false)
	thing.collision.set_deferred("disabled", true)


func exit():
	pass


func check_interaction(_given_interactable: Node2D):
	pass
