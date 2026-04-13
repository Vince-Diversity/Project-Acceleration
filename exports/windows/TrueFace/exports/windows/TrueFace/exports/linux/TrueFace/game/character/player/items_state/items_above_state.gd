class_name ItemsAboveState extends ItemsState
## Makes items and the player such that
## an animation where the item floats above the player
## is played when the item is selected.


## Has the item with the given [code]item_id[\code] float above the player.
func animate_item_selected(item_id: String = ""):
	character.set_animation("admire_above")
	## reset any currently floating items
	character.items._clear_floating_item()
	character.items._add_floating_item(item_id)


## The player should not be holding any items in this state.
func clear_holding():
	pass


## Clears any floating items.
func clear_any():
	character.items._clear_floating_item()


## The floating item and player reaction are being animated.
func is_animating() -> bool:
	return true
