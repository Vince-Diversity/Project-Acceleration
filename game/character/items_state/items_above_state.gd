class_name ItemsAboveState extends ItemsState
## Makes items and the player such that
## an animation where the item floats above the player
## is played when the item is selected.


var _item_above_animation = "admire_above"


## Has the item with the given [code]item_id[\code] float above the player.
func animate_item_selected(item_id: String):
	character.set_animation(_item_above_animation)
	## reset any currently floating items
	character.items._clear_floating_item()
	character.items._add_floating_item(item_id)


## Keep any floating items.
func clear_holding():
	pass


## Clears any floating items.
func clear_any():
	character.items._clear_floating_item()


## The floating item and player reaction are being animated
func is_animating() -> bool:
	return true
