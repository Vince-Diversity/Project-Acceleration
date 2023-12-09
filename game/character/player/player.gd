class_name Player extends Character

@onready var direction_node = $Direction
@onready var interact_area = $Direction/InteractArea
@onready var bubbles = $Bubbles
var nearest_interactable: Node2D:
	set(interactable):
		nearest_interactable = interactable
		set_nearest_interactable(interactable)

signal player_interacted(interactable: Node2D)
signal browsing_started
signal browsing_ended


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
	browsing_ended.connect(_on_browsing_ended)


func make_player(
		idle_bubbles_selected_target: Callable,
		interact_bubbles_selected_target: Callable):
	bubbles.idle_bubbles_selected.connect(idle_bubbles_selected_target)
	bubbles.interact_bubbles_selected.connect(interact_bubbles_selected_target)
	bubbles.init_bubbles(self)


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
		bubbles.try_change_state("bubbles_interact_state")
	else:
		bubbles.try_change_state("bubbles_idle_state")


func check_stored_items():
	if not items.item_id_list.is_empty():
		browsing_started.emit()


func make_item_bubble():
	bubbles.add_item_bubble(items.item_id_list[0])


func close_item_bubble():
	bubbles.item_bubble.close()


func get_thought_item_sprite() -> ItemSprite:
	return bubbles.item_bubble.current_item_sprite


func _on_player_interacted(_interactable: Node2D):
	set_deferred("nearest_interactable", null)


func _on_browsing_ended():
	bubbles.reset_bubbles()
