extends Control

onready var controls_scn = preload("res://loader/controls.tscn")
onready var options = $Options
onready var load_game = $Options/LoadGame
onready var new_game = $Options/NewGame
var focus

func _ready():
	_ready_controls()
	_ready_main_menu()

func _ready_controls():
	var controls = controls_scn.instance()
	add_child(controls)

func _ready_main_menu():
	adapt_load_button()
	focus.grab_focus()

func adapt_load_button():
	var file = File.new()
	if !file.file_exists(Loader.save_path):
		options.remove_child(load_game)
		focus = new_game
	else:
		focus = load_game


func _on_LoadGame_pressed():
	Loader.enter_game()


func _on_NewGame_pressed():
	Loader.new_game()


func _on_Quit_pressed():
	get_tree().quit()
