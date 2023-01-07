extends Control

onready var ui = $UI
onready var player = $Player
var dlg_res: Resource

func _physics_process(_delta):
	player.update_input_direction()
	if player.inputted_direction == Vector2.ZERO:
		player.animate_idle()
	else:
		player.move()

func run_room():
	ui.load_ui()
	ui.text_box.run_text()
