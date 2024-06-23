class_name BubblesInteractState extends BubblesState
## Determines the behaviour of the [Bubbles] node when the [Player] is able to interact with something.
##
## When the player browses through items in this state, the bubbles node is given
## a visual modifier. This is to show that something new happens when selecting an item in this state.


## Creates a new [InteractingBubble] instance.
func enter():
	player.bubbles.add_interacting_bubble()


## Creates a new [ItemBubble] instance and gives the bubbles node a visual modifier.
func create():
	super()
	player.bubbles.modulate_bubbles()


## Has the player use the selected item on the current [Player.nearest_interactable]
## Also clears the reference to that interactable afterwards.
func select():
	super()
	player.bubbles.interact_bubbles_selected.emit(
		player.bubbles.item_bubble.current_item_id,
		player.nearest_interactable.name)


## Resets any visual modifications done to the bubbles node.
func reset():
	player.bubbles.reset_modulation()


func change_bubble(_direction: Utils.Direction):
	pass
