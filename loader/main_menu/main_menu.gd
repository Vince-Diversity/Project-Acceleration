class_name MainMenu extends Control

@export_file var bgm_file: String

@onready var controls_scn = preload("res://loader/main_menu/controls.tscn")
@onready var settings_scn = preload("res://loader/settings/settings.tscn")
@onready var options = $Options
@onready var load_game = $Options/LoadGame
@onready var new_game = $Options/NewGame
@onready var settings = $Options/Settings
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


func init_main_menu(given_loader: Loader, bgm_player: BGMPlayer):
	loader = given_loader
	bgm_player.update_stream(bgm_file)


func adapt_load_button():
	if !FileAccess.file_exists(loader.save_path):
		options.remove_child(load_game)
	_update_focus()


func _update_focus():
	if !FileAccess.file_exists(loader.save_path):
		focus = new_game
	else:
		focus = load_game


func _on_LoadGame_pressed():
	loader.enter_game()


func _on_NewGame_pressed():
	loader.new_game()


func _on_Settings_pressed():
	_update_focus()
	var settings_node = settings_scn.instantiate()
	settings_node.init_settings(self, get_parent(), focus, loader.bgm_player)
	get_parent().add_child(settings_node)
	get_parent().remove_child(self)


func _on_Quit_pressed():
	get_tree().quit()
