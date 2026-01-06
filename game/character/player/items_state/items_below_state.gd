class_name ItemsBelowState extends ItemsState
## Animates the player to look below when an item is selected.


## Has the player look below when an item is selected.
func animate_item_selected(_item_id: String = ""):
	character.set_animation("admire_below")

## Called when exiting a [CutsceneState] or when
## certain items need to be cleared.
func clear_holding():
	pass


## Allow items to be present.
func clear_any():
	pass


## The player is being animated.
func is_animating() -> bool:
	return true
