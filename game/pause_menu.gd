class_name PauseMenu extends CanvasLayer
## Menu that is added and enabled when the [SceneTree] is paused.
##
## This menu gives the options to
## save the game with the [signal save_pressed] signal,
## change settings using [Settings]
## and return to the main menu with the [signal main_menu_pressed] signal
## or the current game session using the [signal pause_menu_closed] signal.

@onready var _settings_scn = preload("res://loader/settings/settings.tscn")
@onready var _title = $Margin/MenuContainer/Title
@onready var _resume = $Margin/MenuContainer/Resume
@onready var _save = $Margin/MenuContainer/Save
@onready var _settings = $Margin/MenuContainer/Settings
@onready var _main_menu = $Margin/MenuContainer/MainMenu

## Reference to current background music player.
var bgm_player: BGMPlayer

## Emitted when the save button is pressed.
signal save_pressed

## Emitted when the main menu button is pressed.
signal main_menu_pressed

## Emitted when the resume button is pressed.
signal pause_menu_closed


func _ready():
	set_process_mode(Node.PROCESS_MODE_WHEN_PAUSED)
	get_tree().set_pause(true)
	_ready_menu()


func _ready_menu():
	_resume.pressed.connect(_on_resume_pressed)
	_save.pressed.connect(_on_save_pressed)
	_settings.pressed.connect(_on_settings_pressed)
	_main_menu.pressed.connect(_on_main_menu_pressed)
	_resume.grab_focus()


## Initialises this node before it is added to the [SceneTree].
func init_pause_menu(
		save_pressed_target: Callable,
		main_menu_pressed_target: Callable,
		pause_menu_closed_target: Callable,
		given_bgm: AudioStreamPlayer):
	save_pressed.connect(save_pressed_target)
	main_menu_pressed.connect(main_menu_pressed_target)
	pause_menu_closed.connect(pause_menu_closed_target)
	bgm_player = given_bgm


func _on_resume_pressed():
	_unpause()


## Creates or overwrites the save file at the location given by [Loader.save_dir].
## The save file is a [Game.cache] duplicate
## that is updated to the current point of the game session.
## Prompts the player that the game is saved and unpauses the game session.
func _on_save_pressed():
	save_pressed.emit()
	_title.text = "Saved!"
	for child in $Margin/MenuContainer.get_children():
		if child == _title: continue
		child.disabled = true
	await get_tree().create_timer(1.0).timeout
	_unpause()


## Frees the game session and adds a [MainMenu] instance to the [SceneTree].
func _on_main_menu_pressed():
	_unpause()
	main_menu_pressed.emit()


## Frees this pause menu and adds a [Settings] instance to the [SceneTree].
func _on_settings_pressed():
	var settings_node = _settings_scn.instantiate()
	settings_node.init_settings(self, get_parent(), _resume, bgm_player)
	get_parent().add_child(settings_node)
	get_parent().remove_child(self)


## Frees this pause menu and resumes the game session.
func _unpause():
	get_tree().set_pause(false)
	queue_free()
