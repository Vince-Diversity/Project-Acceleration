class_name ThingInteractableState extends ThingState
## Enables player interaction with a [Thing].


## Enables the interaction area of the thing with this state,
## and ensures that its collision area is enabled.
func enter():
	thing.interact_area.set_monitoring(true)
	thing.interact_area.set_monitorable(true)
	thing.collision.set_deferred("disabled", false)


## Checks if the thing with this state is the desired [code]interactable_scene[/code]
## and begins the interaction if so.
func check_interaction(interactable_scene: Node2D):
	if interactable_scene == thing:
		thing.get_node("InteractArea").begin_interaction.emit(thing)
