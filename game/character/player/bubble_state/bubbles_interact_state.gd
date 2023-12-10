class_name BubblesInteractState extends BubblesState


func enter():
	player.bubbles.add_interacting_bubble()


func exit():
	pass


func create():
	super()
	player.bubbles.modulate_bubbles()


func select():
	super()
	player.bubbles.interact_bubbles_selected.emit(
		player.bubbles.item_bubble.current_item_id,
		player.nearest_interactable.name)


func reset():
	player.bubbles.reset_modulation()
