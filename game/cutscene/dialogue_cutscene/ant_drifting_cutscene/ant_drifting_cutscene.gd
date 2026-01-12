class_name AntDriftingCutscene extends DialogueCutscene
## Custom dialogue cutscene when interacting with imaginary space characters in Sea Space.


## Sets the dialogue title of the ant the player is interacting with.
func set_dialogue_node(dialogue_node: String):
	cutscenes.current_source_node.dialogue_node = dialogue_node


## Sets the dialogue title of all ants that are drifting in Sea Space.
## Assumes they are [Thing] nodes starting with "Anchor".
func set_anchors_dialogue_node(dialogue_node: String):
	for thing in owner.things.get_children():
		if thing.name.begins_with("Anchor"):
			thing.dialogue_node = dialogue_node
