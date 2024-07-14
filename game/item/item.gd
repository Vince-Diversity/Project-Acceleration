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

## The ID of the item is the same as the filename of its corresponding [ItemSprite] resource.
var item_id: String


func _ready():
	anim_sprite.sprite_frames.set_animation_loop(anim_sprite.animation, true)
	anim_sprite.play()


## Initialise this item before it is added to the scene tree.
func init_item(given_item_id: String):
	item_id = given_item_id
