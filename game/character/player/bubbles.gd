class_name Bubbles extends Node2D
## Manages the current thought [Bubble] nodes which the [Player] has.
##
## When the player's interaction area overlaps the area of an interactable scene,
## a corresponding [member interacting_bubble] node is added o show that some interaction
## is possible. Also, during the [BrowseState], an [member item_bubble] node is added to allow the player
## to select an obtained item for using it or, if there is nothing to interact on,
## just examine it. To take into account that item selection is context dependent,
## the [BubblesState] of this node depends on whether the player is able to interact with something.


@onready var _interacting_bubble_mark = $InteractingBubbleMark
@onready var _item_bubble_mark = $ItemBubbleMark
@onready var _interacting_bubble_scn = preload("res://game/ui/bubble/interacting_bubble.tscn")
@onready var _item_bubble_scn = preload("res://game/ui/bubble/item_bubble.tscn")
@onready var _idle_state: BubblesIdleState =\
	preload("res://game/character/player/bubble_state/bubbles_idle_state.gd").new("bubbles_idle_state")
@onready var _interact_state: BubblesInteractState =\
	preload("res://game/character/player/bubble_state/bubbles_interact_state.gd").new("bubbles_interact_state")


## The current thought bubble used for interactions.
var interacting_bubble: InteractingBubble

## The current thought bubble used for items.
var item_bubble: ItemBubble

## Current activated bubble state instance.
var current_state: BubblesState

## List of [BubbleState] instances labeled by each respective [member BubbleState.state_id].
var state_list: Dictionary

## Emitted when the player selects an item during [BubblesIdleState].
signal idle_bubbles_selected

## Emitted when the player selects an item during [BubblesInteractState].
signal interact_bubbles_selected(item_id: String, interactable_name: String)


func _ready():
	state_list[_idle_state.state_id] = _idle_state
	state_list[_interact_state.state_id] = _interact_state
	current_state = state_list[_idle_state.state_id]


## Initialises this node after it is added to the [SceneTree].
func make_bubbles(player: Player):
	_idle_state.make_state(player)
	_interact_state.make_state(player)
	current_state.enter()


## Changes the [member current_state] to the given [code]bubble_state_id[/code],
## if that state is not already the current state.
func try_change_states(bubble_state_id: String):
	if bubble_state_id != current_state.state_id:
		current_state.exit()
		current_state = state_list[bubble_state_id]
		current_state.enter()


## Selects an item.
func select_option():
	current_state.select()


## Checks if an item thought bubble node can be created and, if so, adds it.
func create_item_bubble():
	current_state.create()


## Resets any visual modifiers to the currently displayed thought bubbles.
func reset_bubbles():
	current_state.reset()


func change_bubble(direction: Utils.Direction):
	current_state.change_bubble(direction)


## Adds an [member interacting_bubble] node.
func add_interacting_bubble():
	interacting_bubble = _interacting_bubble_scn.instantiate()
	_interacting_bubble_mark.add_child(interacting_bubble)
	interacting_bubble.make_bubble()


## Adds an [member item_bubble] node.
func add_item_bubble(item_id: String, item_list_size: int):
	item_bubble = _item_bubble_scn.instantiate()
	_item_bubble_mark.add_child(item_bubble)
	item_bubble.set_current_item(item_id, item_list_size)


## Modulates the thought bubbles, which indicates that an item interaction is possible.
func modulate_bubbles():
	interacting_bubble.bubble_sprite.set_modulate(Color.VIOLET)
	item_bubble.bubble_sprite.set_modulate(Color.VIOLET)


## Resets any visual modifiers on any existing thought bubble.
func reset_modulation():
	for bubble in get_bubbles():
		if is_instance_valid(bubble):
			bubble.reset_bubble()


## Gets a list of current [Bubble] instances, or null if not instantiated.
func get_bubbles() -> Array:
	var arr := []
	for marker in get_children():
		if marker.get_child_count() != 0:
			arr.append(marker.get_child(0))
	return arr
