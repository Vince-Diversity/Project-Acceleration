class_name Interactable extends Area2D
## Base class for making scenes interactable with the player.
##
## Interacting functionality is implemented using ideas similar to class delegation.
## Any [Node2D], such as [NPC] and [Thing], becomes interactable with the player
## when it has an interactable child node. An interactable node is created
## simply by attaching a subclass of this class to an [Area2D] node.
## For convenience, this interactable node should be a direct child of
## the scene root and its node name should be [code]"InteractArea"[/code].
## Then, these nodes can be accessed using [code]get_node("InteractArea")[/code].
## [br]
## [br]
## Also, the following exported variables are assumed to exist in each interactable
## scene and should be copied to the scene root.
## This makes development in the Godot editor more convenient since
## exported variables of instantiated child scenes are only visible in the editor
## if those variables are in the root of the child scene.
## [codeblock]
## ## Node name of the desired [Cutscene]. Optionally, a default cutscene is used if this field remains empty.
## @export var interaction_node: String
## ## Filename of the [DialogueResource] containing the desired dialogue.
## @export var dialogue_id: String
## ## Title of the desired dialogue, see [method DialogueResource.get_next_dialogue_line].
## @export var dialogue_node: String
## [/codeblock]


## Emitted when a player interacts with the given [code]interactable_scene[/code].
signal begin_interaction(interactable_scene: Node2D)


## Checks if this interactable scene is the correct scene to
## respond to a player interaction, and responds to it if so.
func check_interaction(_interactable_scene: Node2D):
	pass


## Called when a player interaction ends.
func _on_end_interaction():
	pass
