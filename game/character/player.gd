class_name Player extends Character

@onready var direction_node = $Direction
@onready var interact_area = $Direction/InteractArea
@onready var interacting_bubble_mark = $Bubbles/InteractingBubbleMark
@onready var item_bubble_mark = $Bubbles/ItemBubbleMark
@onready var interacting_bubble_scn = preload("res://game/ui/bubble/interacting_bubble.tscn")
@onready var item_bubble_scn = preload("res://game/ui/bubble/item_bubble.tscn")
var interacting_bubble: InteractingBubble
var item_bubble: ItemBubble
var nearest_interactable: Node2D:
	set(interactable):
		nearest_interactable = interactable
		set_nearest_interactable(interactable)

signal player_interacted(interactable: Node2D)
signal browsing_started()
signal browsing_ended()


func _ready():
	update_angle()
	player_interacted.connect(_on_player_interacted)


func init_player(
		given_party: Party,
		player_interacted_target: Callable,
		browsing_started_target: Callable,
		browsing_ended_target: Callable):
	party = given_party
	player_interacted.connect(player_interacted_target)
	browsing_started.connect(browsing_started_target)
	browsing_ended.connect(browsing_ended_target)


func roam():
	update_input_direction()
	if inputted_direction == Vector2.ZERO:
		animate_idle()
	else:
		move()
	check_nearest_interactable()


func move():
	super()
	update_angle()


func update_direction():
	super()
	update_angle()


func update_angle():
	direction_node.rotation = Utils.snap_to_compass(inputted_direction).angle()


func update_input_direction():
	inputted_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")


func check_nearest_interactable():
	var areas: Array[Area2D] = interact_area.get_overlapping_areas()
	if areas.is_empty():
		nearest_interactable = null
	else:
		var shortest_distance: float = INF
		var next_nearest_interactable: Node2D
		for area in areas:
			var distance = area.global_position.distance_to(global_position)
			if distance < shortest_distance:
				shortest_distance = distance
				next_nearest_interactable = area.owner
		if next_nearest_interactable != nearest_interactable:
			nearest_interactable = next_nearest_interactable


func check_interaction():
	if is_instance_valid(nearest_interactable):
		player_interacted.emit(nearest_interactable)


func set_nearest_interactable(new_interactable: Node2D):
	if is_instance_valid(new_interactable):
		if not is_instance_valid(interacting_bubble):
			interacting_bubble = interacting_bubble_scn.instantiate()
			interacting_bubble.init_bubble()
			add_child(interacting_bubble)
			interacting_bubble.set_position(interacting_bubble_mark.position)
	else:
		if is_instance_valid(interacting_bubble):
			interacting_bubble.close()


func check_stored_items():
	if not items.item_id_list.is_empty():
		browsing_started.emit()
		item_bubble = item_bubble_scn.instantiate()
		item_bubble_mark.add_child(item_bubble)
		item_bubble.add_item(items.item_id_list[0])


func _on_player_interacted(_interactable: Node2D):
	set_deferred("nearest_interactable", null)
