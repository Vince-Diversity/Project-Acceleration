class_name Player extends Character

@onready var direction_node = $Direction
@onready var interact_area = $Direction/InteractArea
var nearest_interactable: Node2D

signal player_nearest_interactable_changed
signal player_interacted(interactable: Node2D)


func _ready():
	update_angle()


func roam():
	update_input_direction()
	if inputted_direction == Vector2.ZERO:
		animate_idle()
	else:
		move()


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
	var shortest_distance: float = INF
	var next_nearest_interactable: Node2D
	for area in areas:
		var distance = area.global_position.distance_to(global_position)
		if distance < shortest_distance:
			shortest_distance = distance
			next_nearest_interactable = area.get_thing()
	if next_nearest_interactable != nearest_interactable or not is_instance_valid(next_nearest_interactable):
		nearest_interactable = next_nearest_interactable
		player_nearest_interactable_changed.emit(nearest_interactable)


func check_interaction():
	if is_instance_valid(nearest_interactable):
		player_interacted.emit(nearest_interactable)
