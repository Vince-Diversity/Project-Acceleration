class_name Item extends StaticBody2D

@export var interaction_node: String
@export var dialogue_id: String
@export var dialogue_node: String
@onready var anim_sprite = $AnimatedSprite2D
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
