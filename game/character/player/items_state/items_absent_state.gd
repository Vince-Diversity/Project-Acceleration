class_name ItemsAbsentState extends ItemsState
## This state occurs when the player is not actively holding any items.


## Items should not be selectable during this state.
func animate_item_selected(_item_id: String):
	pass


## The player should not be holding any items in this state.
func clear():
	pass


## There is no item being animated.
func is_animating() -> bool:
	return false
