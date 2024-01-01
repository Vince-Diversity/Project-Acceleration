class_name ThingInteractableState extends ThingState
## Enables player interaction with [member ThingState.thing].

## Enables the interaction area of [member ThingState.thing],
## and ensures that its collision area is enabled.
func enter():
	thing.interact_area.set_disabled(false)
	thing.collision.set_deferred("disabled", false)


## Checks if the [member ThingState.thing] is the desired [code]interactable_scene[/code]
## and begins the interaction if so.
func check_interaction(interactable_scene: Node2D):
	if interactable_scene == thing:
		thing.get_node("InteractArea").begin_interaction.emit(thing)
