class_name Item extends StaticBody2D
## Base scene for items.
##
## While this scene has an [Interactable] node,
## because items are currently not part of the environment,
## player interaction with a item node isn't actually implemented.


## Node name of the desired [Cutscene]. Optionally, a default cutscene is used if this field remains empty.
@export var interaction_node: String

## Filename of the [DialogueResource] containing the desired dialogue.
@export var dialogue_id: String

## Title of the desired dialogue, see [method DialogueResource.get_next_dialogue_line].
@export var dialogue_node: String

## The sprite of this item.
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

## The sprite resource of this item.
var item_sprite: ItemSprite


func _ready():
	anim_sprite.sprite_frames.set_animation_loop(anim_sprite.animation, true)
	anim_sprite.play()
