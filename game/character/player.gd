extends "res://game/character/character.gd"

onready var direction_node = $Direction
onready var interact_area = $Direction/InteractArea

func _ready():
	update_angle()

func move():
	.move()
	update_angle()

func update_direction():
	.update_direction()
	update_angle()

func update_angle():
	direction_node.rotation = Utils.snap_to_compass(inputted_direction).angle()

func update_input_direction():
	inputted_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
