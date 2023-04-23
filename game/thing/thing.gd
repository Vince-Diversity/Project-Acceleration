class_name Thing extends StaticBody2D

@export var interaction_node: String
@export var dialogue_id: String
@export var dialogue_node: String
@export var bubble_content: Bubble.Content

signal begin_interaction(thing: Thing)


func set_rng(_thing_rng: RandomNumberGenerator):
	pass


func check_interaction(given_interactable: Node2D):
	if given_interactable == self:
		begin_interaction.emit(self)
