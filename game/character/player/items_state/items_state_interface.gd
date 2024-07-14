class_name ItemsState extends GDScript
## Base class for the Items node states

## The filename (without the extension) is used as ID for this class.
var state_id: String

## Reference to the player with the [Items] node with this state.
var player: Player


## Initialises this class, assigning the ID [member state_id].
func _init(given_state_id: String):
	state_id = given_state_id


## Further initialises this class after the [code]given_player[/code]
## has been added to the [SceneTree].
func make_state(given_player: Player):
	player = given_player


func _clear_exhibit():
	if is_instance_valid(player.items.exhibit_item):
		player.items.exhibit_item.queue_free()
		player.items._exhibit_background.set_visible(false)


## Called when the character of this state
## starts running an animation when selecting an item
## with the given [code]item_id[/code].
func animate_item_selected(_item_id: String):
	pass


## Called when exiting a [CutsceneState] or when
## certain items need to be cleared.
func clear():
	pass


## Called when exiting a [BrowseState].
func is_animating() -> bool:
	return false
