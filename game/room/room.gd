extends Node2D

onready var player = $YSort/Player
onready var thing = $YSort/Cat
var dlg_res: Resource

func _physics_process(_delta):
	player.update_input_direction()
	if player.inputted_direction == Vector2.ZERO:
		player.animate_idle()
	else:
		player.move()

func _input(_event):
	if Input.is_action_just_pressed("ui_select"):
		check_interaction()

func check_interaction():
	for body in thing.interact_area.get_overlapping_bodies():
		print("%s pats %s" % [player.name, thing.name])
