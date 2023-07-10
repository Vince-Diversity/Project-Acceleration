class_name NPC extends Character

@export var interaction_node: String
@export var dialogue_id: String
@export var dialogue_node: String
@export var bubble_content: Bubble.Content

signal begin_interaction(npc: NPC)


func check_interaction(given_interactable: Node2D):
	if given_interactable == self:
		begin_interaction.emit(self)


func _on_end_interaction():
	pass
