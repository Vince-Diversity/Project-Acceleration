class_name Player extends Character

@onready var direction_node = $Direction
@onready var interact_area = $Direction/InteractArea
@onready var bubble_place = $BubblePlace
@onready var bubble_scn = preload("res://game/ui/bubble/bubble.tscn")
var bubble: Bubble
var nearest_interactable: Node2D:
	set(interactable):
		nearest_interactable = interactable
		set_nearest_interactable(interactable)

signal player_interacted(interactable: Node2D)


func _ready():
	hide_placeholders()
	update_angle()
	player_interacted.connect(_on_player_interacted)


func init_player(given_party: Party):
	party = given_party


func hide_placeholders():
	bubble_place.set_visible(false)


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
		if not is_instance_valid(bubble):
			bubble = bubble_scn.instantiate()
			bubble.init_bubble(new_interactable.bubble_content)
			add_child(bubble)
			bubble.set_position(bubble_place.position)
	else:
		if is_instance_valid(bubble):
			bubble.close()


func _on_player_interacted(_interactable: Node2D):
	set_deferred("nearest_interactable", null)
