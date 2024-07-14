class_name ItemsExhibitState extends ItemsState
## Makes the character display items when an item is selected.


var _exhibit_animation = "exhibit"


## Displays the item with the given [code]item_id[/code] when it is selected.
func animate_item_selected(item_id: String):
	player.set_animation(_exhibit_animation)
	## reset any currently displayed item
	if is_instance_valid(player.items.exhibit_item): _clear_exhibit()
	player.items._add_exhibit_item(item_id)


## Clears any exibits.
func clear():
	_clear_exhibit()


## The displayal is being animated.
func is_animating() -> bool:
	return true
