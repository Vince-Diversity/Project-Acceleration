class_name ThingInteractable extends Interactable
## Makes [Thing] scenes interactable with the player.


## Checks if this [Thing] is in an interactable state
## and performs further checks if so.
func check_interaction(interactable_scene: Node2D):
	owner.current_state.check_interaction(interactable_scene)


func _on_end_interaction():
	if owner.is_oneshot:
		owner.change_state("thing_static_state")
