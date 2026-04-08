class_name ItemsExhibitState extends ItemsState
## Makes the character display items when an item is selected.


var _exhibit_animation = "exhibit"


func _add_exhibit_item(item_id: String):
	var item_path = Utils.get_item_path(item_id)
	if ResourceLoader.exists(item_path):
		character.items.exhibit_item = load(item_path).instantiate()
		character.items.exhibit_item.init_item(item_id)
		character.items._exhibit_mark.add_child(character.items.exhibit_item)
		character.items._exhibit_background.set_visible(true)


func _clear_exhibit():
	if is_instance_valid(character.items.exhibit_item):
		character.items.exhibit_item.queue_free()
		character.items._exhibit_background.set_visible(false)


## Displays the item with the given [code]item_id[/code] when it is selected.
func animate_item_selected(item_id: String = ""):
	character.set_animation(_exhibit_animation)
	## reset any currently displayed item
	_clear_exhibit()
	_add_exhibit_item(item_id)


## Clears any exibits.
func clear_holding():
	_clear_exhibit()


## Clears any exhibits.
func clear_any():
	_clear_exhibit()


## The displayal is being animated.
func is_animating() -> bool:
	return true
