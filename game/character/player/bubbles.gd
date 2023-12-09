class_name Bubbles extends Node2D

@onready var interacting_bubble_mark = $InteractingBubbleMark
@onready var item_bubble_mark = $ItemBubbleMark
@onready var interacting_bubble_scn = preload("res://game/ui/bubble/interacting_bubble.tscn")
@onready var item_bubble_scn = preload("res://game/ui/bubble/item_bubble.tscn")
@onready var idle_state: BubblesIdleState =\
	preload("res://game/character/player/bubble_state/bubbles_idle_state.gd").new("bubbles_idle_state")
@onready var interact_state: BubblesInteractState =\
	preload("res://game/character/player/bubble_state/bubbles_interact_state.gd").new("bubbles_interact_state")
var interacting_bubble: InteractingBubble
var item_bubble: ItemBubble
var current_state: BubblesState
var state_list: Dictionary

signal idle_bubbles_selected
signal interact_bubbles_selected


func _ready():
	state_list[idle_state.state_id] = idle_state
	state_list[interact_state.state_id] = interact_state
	current_state = state_list[idle_state.state_id]


func init_bubbles(player: Player):
	idle_state.init_state(player)
	interact_state.init_state(player)
	current_state.enter()


func try_change_state(state_id: String):
	if state_id != current_state.state_id:
		current_state.exit()
		current_state = state_list[state_id]
		current_state.enter()


func select_option():
	current_state.select()


func create_item_bubble():
	current_state.create()


func reset_bubbles():
	current_state.reset()


func add_interacting_bubble():
	interacting_bubble = interacting_bubble_scn.instantiate()
	interacting_bubble_mark.add_child(interacting_bubble)
	interacting_bubble.make_bubble()


func add_item_bubble(item_id: String):
	item_bubble = item_bubble_scn.instantiate()
	item_bubble_mark.add_child(item_bubble)
	item_bubble.set_current_item_id(item_id)


func modulate_bubbles():
	interacting_bubble.bubble_sprite.set_modulate(Color.VIOLET)
	item_bubble.bubble_sprite.set_modulate(Color.VIOLET)


func reset_modulation():
	for bubble in get_bubbles():
		if is_instance_valid(bubble):
			bubble.bubble_sprite.set_modulate(Color(1,1,1,1))


func get_bubbles() -> Array:
	var arr := []
	for marker in get_children():
		if marker.get_child_count() != 0:
			arr.append(marker.get_child(0))
	return arr
