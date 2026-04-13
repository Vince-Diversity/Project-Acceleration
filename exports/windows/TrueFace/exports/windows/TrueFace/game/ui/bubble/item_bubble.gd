class_name ItemBubble extends Bubble
## A thought bubble of obtained items.
##
## When the [Player] obtains an item, they are able to start browsing through
## obtained items in the [BrowseState]. This item thought bubble displays
## the currently selected item in that state.

@onready var _anim_player: AnimationPlayer = $AnimationPlayer
@onready var _scroll_left_indicator: Sprite2D = $ScrollLeftIndicator
@onready var _scroll_right_indicator: Sprite2D = $ScrollRightIndicator

## Sets the current item ID, see [Items.item_id_list], and adds the corresponding item sprite to the thought bubble.
var current_item_id: String:
	set(item_id):
		current_item_id = item_id
		_make_sprite(item_id)

## The [AnimatedSprite2D] containing the current item sprite.
var current_anim_sprite: AnimatedSprite2D


func _ready():
	super()
	_anim_player.play("scroll_indicator")


func _make_sprite(item_id: String):
	var item_sprite_path = Utils.get_item_sprite_path(item_id)
	if ResourceLoader.exists(item_sprite_path):
		var current_item_sprite = load(item_sprite_path)
		current_anim_sprite = AnimatedSprite2D.new()
		add_child(current_anim_sprite)
		current_anim_sprite.set_sprite_frames(current_item_sprite)
		current_anim_sprite.play("default")


## Sets the current [ItemSprite] from the [Items.item_id_list]
## with the given [code]item_id[/code].
## Enables scrolling indicators if there are at least two items in the item list.
func set_current_item(item_id: String, item_list_size: int):
	if is_instance_valid(current_anim_sprite): current_anim_sprite.queue_free()
	current_item_id = item_id
	if item_list_size < 2:
		_scroll_left_indicator.set_visible(false)
		_scroll_right_indicator.set_visible(false)
	else:
		_scroll_left_indicator.set_visible(true)
		_scroll_right_indicator.set_visible(true)
		_anim_player.play("scroll_indicator")
