class_name BubblesIdleState extends BubblesState
## Determines the behaviour of the [Bubbles] node when the [Player] is unable to interact with anything.

## Frees any existing [member Bubble.interacting_bubble] nodes.
func enter():
	if is_instance_valid(player.bubbles.interacting_bubble):
		player.bubbles.interacting_bubble.close()


## Has the player show the currently selected item and starts examining it.
## Also clears the current [Player.nearest_interactable] reference.
func select():
	super()
	player.exhibit(player.bubbles.item_bubble.current_item_id)
	player.bubbles.idle_bubbles_selected.emit()
