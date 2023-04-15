class_name Thing extends Marker2D

@export var interaction_node: String
@export var dialogue_id: String
@export var dialogue_node: String

signal begin_interaction(thing: Thing)


func check_interaction(given_interactable: Node2D):
	if given_interactable == self:
		begin_interaction.emit(self)
