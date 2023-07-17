class_name NPC extends Character

@export var interaction_node: String
@export var dialogue_id: String
@export var dialogue_node: String
@export var bubble_content: Bubble.Content
@export var spawn_direction: Utils.AnimID


func _ready():
	set_direction(
		Utils.get_anim_direction(spawn_direction))
	update_direction()
