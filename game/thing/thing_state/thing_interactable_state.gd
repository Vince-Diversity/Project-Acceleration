class_name ThingInteractableState extends ThingState


func enter():
	thing.interact_area.set_disabled(false)
	thing.collision.set_deferred("disabled", false)


func exit():
	pass


func check_interaction(interactable_scene: Node2D):
	if interactable_scene == thing:
		thing.get_node("InteractArea").begin_interaction.emit(thing)


func make_preserved_save(sg: SaveGame):
	super(sg)
