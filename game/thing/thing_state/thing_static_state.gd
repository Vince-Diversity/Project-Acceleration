class_name ThingStaticState extends ThingState


func enter():
	thing.interact_area.set_disabled(true)
	thing.collision.set_deferred("disabled", false)


func exit():
	pass


func check_interaction(_given_interactable: Node2D):
	pass
