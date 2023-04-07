class_name MainMenu extends Control

@onready var controls_scn = preload("res://loader/main_menu/controls.tscn")
@onready var options = $Options
@onready var load_game = $Options/LoadGame
@onready var new_game = $Options/NewGame
var focus
var loader


func _ready():
	_ready_controls()
	_ready_main_menu()


func _ready_controls():
	var controls = controls_scn.instantiate()
	add_child(controls)


func _ready_main_menu():
	adapt_load_button()
	focus.grab_focus()


func init_main_menu(given_loader: Loader):
	loader = given_loader


func adapt_load_button():
	if !FileAccess.file_exists(loader.save_path):
		options.remove_child(load_game)
		focus = new_game
	else:
		focus = load_game


func _on_LoadGame_pressed():
	loader.enter_game()


func _on_NewGame_pressed():
	loader.new_game()


func _on_Quit_pressed():
	get_tree().quit()

