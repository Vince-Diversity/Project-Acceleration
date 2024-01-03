class_name ItemBubble extends Bubble
## A thought bubble of obtained items.
##
## When the [Player] obtains an item, they are able to start browsing through
## obtained items in the [BrowseState]. This item thought bubble displays
## the currently selected item in that state.

@onready var _anim_player: AnimationPlayer = $AnimationPlayer

## Sets the current item ID, see [Items.item_id_list], and adds the corresponding item sprite to the thought bubble.
var current_item_id: String:
	set(item_id):
		current_item_id = item_id
		_make_sprite(item_id)

## The current item sprite.
var current_item_sprite: ItemSprite


func _ready():
	super()
	_anim_player.play("indicator")


func _make_sprite(item_id):
	var item_sprite_path = Utils.get_item_sprite_path(item_id)
	if ResourceLoader.exists(item_sprite_path):
		current_item_sprite = load(item_sprite_path)
		var current_anim_sprite = AnimatedSprite2D.new()
		add_child(current_anim_sprite)
		current_anim_sprite.set_sprite_frames(current_item_sprite)
		current_anim_sprite.play("default")
