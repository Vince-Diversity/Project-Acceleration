class_name ItemsState extends GDScript
## Base class for the Items node states

## The filename (without the extension) is used as ID for this class.
var state_id: String

## Reference to the character with the [Items] node with this state.
var character: Character


## Initialises this class, assigning the ID [member state_id].
func _init(given_state_id: String):
	state_id = given_state_id


## Further initialises this class after the [code]given_player[/code]
## has been added to the [SceneTree].
func make_state(given_character: Character):
	character = given_character


## Called when the character of this state
## starts running an animation when selecting an item
## optionally with the given [code]item_id[/code].
func animate_item_selected(_item_id: String = ""):
	pass


## Called when exiting a [CutsceneState] or when
## certain items need to be cleared.
func clear_holding():
	pass


## Called whenever any item needs to be cleared.
func clear_any():
	pass


## Called when exiting a [BrowseState].
func is_animating() -> bool:
	return false
