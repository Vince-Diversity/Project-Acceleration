class_name MainMenu extends Control
## User interface for loading the game using [Loader], changing settings or closing the program.
##
## Controls for the game are managed by the [RichTextLabel] node Info.
## Background music is set using [member bgm_file].

## Path to the playing background music.
@export_file var bgm_file: String

@onready var _controls_scn = preload("res://loader/main_menu/controls.tscn")
@onready var _settings_scn = preload("res://loader/settings/settings.tscn")
@onready var _options = $Options
@onready var _load_game = $Options/LoadGame
@onready var _new_game = $Options/NewGame
@onready var _settings = $Options/Settings

## The focused button.
var focus

## Reference to [Loader].
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


## Initialises the node before it is added to the scene tree.
func init_main_menu(given_loader: Loader, bgm_player: BGMPlayer):
	loader = given_loader
	bgm_player.update_stream(bgm_file)


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


func _on_Settings_pressed():
	_update_focus()
	var settings_node = _settings_scn.instantiate()
	settings_node.init_settings(self, get_parent(), focus, loader.bgm_player)
	get_parent().add_child(settings_node)
	get_parent().remove_child(self)


func _on_Quit_pressed():
	get_tree().quit()
