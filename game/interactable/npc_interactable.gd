class_name NPCInteractable extends Interactable
## Makes [NPC] scenes interactable with the player.


## Checks if this [NPC] scene is the desired [code]interactable_scene[/code]
## and begins the interaction if so.
func check_interaction(interactable_scene: Node2D):
	if interactable_scene == owner:
		begin_interaction.emit(owner)


func _on_end_interaction():
	pass
