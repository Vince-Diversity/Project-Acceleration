class_name Interactable extends Node2D

## Instance this to scenes that can be interacted with
# Uses get_node("InteractArea") to refer to instances of this scene


# Just copying pasting these exports so the UI becomes convenient
#@export var interaction_node: String
#@export var dialogue_id: String
#@export var dialogue_node: String
#@export var bubble_content: Bubble.Content


signal begin_interaction(interactable_scene: Node2D)


func check_interaction(_given_interactable: Node2D):
	pass


func _on_end_interaction():
	pass
