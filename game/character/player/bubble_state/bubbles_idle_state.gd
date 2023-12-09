class_name BubblesIdleState extends BubblesState


func enter():
	if is_instance_valid(player.bubbles.interacting_bubble):
		player.bubbles.interacting_bubble.close()


func exit():
	pass


func create():
	super()


func select():
	super()
	player.exhibit(player.bubbles.item_bubble.current_item_id)
	player.bubbles.idle_bubbles_selected.emit()


func reset():
	pass
