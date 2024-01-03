class_name Item extends StaticBody2D
## Base scene for items.
##
## Since there are also [ItemSprite] resources for every item,
## when making new item nodes its [member Node.name] is used to load
## the corresponding item sprite when it is added to the [SceneTree].
## (The node name can be in PascalCase, since it will be converted to snake_case).
## [br]
## [br]
## Also, while this scene has an [Interactable] node,
## since items are currently not part of the environment, player interaction
## with a item node isn't actually implemented.


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
	_ready_item_sprite()


func _ready_item_sprite():
	var item_sprite_path = Utils.get_item_sprite_path(Utils.get_item_id(name))
	item_sprite = load(item_sprite_path)
	_ready_item_anim_sprite()


func _ready_item_anim_sprite():
	anim_sprite.set_sprite_frames(item_sprite)
	anim_sprite.play("default")
