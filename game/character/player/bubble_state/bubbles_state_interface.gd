class_name BubblesState extends GDScript
## Base class for the [Bubbles] node states.


## The filename (without the extension) is used as ID for this class.
var state_id: String

## Reference to the player with the [Bubbles] node with this state.
var player: Player

## The current item index in the [Items.item_id_list].
var current_item_index: int = 0:
	set(value):
		current_item_index = value % player.items.item_id_list.size()


## Initialises this class, assigning the ID [member state_id].
func _init(given_state_id: String):
	state_id = given_state_id


## Further initialises this class after the [code]given_player[/code]
## has been added to the [SceneTree].
func make_state(given_player: Player):
	player = given_player


## Called when this state becomes the current state.
func enter():
	pass


## Called when this state is removed as the current state.
func exit():
	pass


## Called when creating a new [ItemBubble] instance.
func create():
	current_item_index = 0
	player.make_item_bubble()


## Called when selecting the current [ItemBubble].
## Clears the current [Player.nearest_interactable] reference.
func select():
	player.set_deferred("nearest_interactable", null)


## Called when resetting visual modifiers on the current bubbles.
func reset():
	pass


func change_bubble(_direction: Utils.Direction):
	pass
