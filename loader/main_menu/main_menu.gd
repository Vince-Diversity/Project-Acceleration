class_name MainMenu extends Control
## Menu for loading the game using [Loader],
## changing settings using [Settings] or closing the program.
##
## Controls for the game are managed by the [code]Info[/code] child node.
## Background music is set to the path given by [member bgm_file].

## Path to the playing background music.
@export_file var bgm_file: String

@onready var _controls_scn = preload("res://loader/main_menu/controls.tscn")
@onready var _settings_scn = preload("res://loader/settings/settings.tscn")
@onready var _options = $Options
@onready var _load_game = $Options/LoadGame
@onready var _new_game = $Options/NewGame

## The focussed button.
var focus

## Reference to the loader.
var loader


func _ready():
	_ready_controls()
	_ready_main_menu()


func _ready_controls():
	var controls = _controls_scn.instantiate()
	add_child(controls)


func _ready_main_menu():
	adapt_load_button()
	focus.grab_focus()


## Initialises this node before it is added to the [SceneTree].
func init_main_menu(given_loader: Loader):
	loader = given_loader
	loader.bgm_player.update_stream(bgm_file)


## Adds an option to load an existing game, if that exists.
func adapt_load_button():
	if !FileAccess.file_exists(loader.save_path):
		_options.remove_child(_load_game)
	_update_focus()


func _update_focus():
	if !FileAccess.file_exists(loader.save_path):
		focus = _new_game
	else:
		focus = _load_game


func _on_LoadGame_pressed():
	loader.enter_game()


func _on_NewGame_pressed():
	loader.new_game()


## Frees this main menu and adds a [Settings] instance to the [SceneTree].
func _on_Settings_pressed():
	_update_focus()
	var settings_node = _settings_scn.instantiate()
	settings_node.init_settings(self, get_parent(), focus, loader.bgm_player)
	get_parent().add_child(settings_node)
	get_parent().remove_child(self)


func _on_Quit_pressed():
	get_tree().quit()
