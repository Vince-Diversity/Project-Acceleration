class_name ItemBubble extends Bubble

@onready var anim_player: AnimationPlayer = $AnimationPlayer
var current_item_id: String
var current_item_sprite: ItemSprite
var current_anim_sprite: AnimatedSprite2D


func _ready():
	super()
	anim_player.play("indicator")


func set_current_item_id(item_id):
	current_item_id = item_id
	_make_sprite(item_id)


func _make_sprite(item_id):
	var item_sprite_path = Utils.get_item_sprite_path(item_id)
	if ResourceLoader.exists(item_sprite_path):
		current_item_sprite = load(item_sprite_path)
		current_anim_sprite = AnimatedSprite2D.new()
		add_child(current_anim_sprite)
		current_anim_sprite.set_sprite_frames(current_item_sprite)
		current_anim_sprite.play("default")


func close():
	super()
