class_name Thing extends StaticBody2D

@export var interaction_node: String
@export var dialogue_id: String
@export var dialogue_node: String
@export var is_oneshot: bool = false
@export var bubble_content: Bubble.Content
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact_area: CollisionShape2D = $InteractArea/CollisionShape2D

signal begin_interaction(thing: Thing)


func set_rng(_thing_rng: RandomNumberGenerator):
	pass


func check_interaction(given_interactable: Node2D):
	if given_interactable == self:
		begin_interaction.emit(self)


func _on_thing_end_interaction():
	if is_oneshot:
		interact_area.set_deferred("disabled", true)
