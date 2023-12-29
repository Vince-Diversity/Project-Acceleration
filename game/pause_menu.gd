class_name PauseMenu extends CanvasLayer
## a

@onready var _settings_scn = preload("res://loader/settings/settings.tscn")
@onready var _title = $Margin/MenuContainer/Title
@onready var _resume = $Margin/MenuContainer/Resume
@onready var _save = $Margin/MenuContainer/Save
@onready var _settings = $Margin/MenuContainer/Settings
@onready var _main_menu = $Margin/MenuContainer/MainMenu
var bgm_player: BGMPlayer

signal save_pressed
signal main_menu_pressed
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


func _on_save_pressed():
	save_pressed.emit()
	_title.text = "Saved!"
	for child in $Margin/MenuContainer.get_children():
		if child == _title: continue
		child.disabled = true
	await get_tree().create_timer(1.0).timeout
	_unpause()


func _on_main_menu_pressed():
	_unpause()
	main_menu_pressed.emit()


func _on_settings_pressed():
	var settings_node = _settings_scn.instantiate()
	settings_node.init_settings(self, get_parent(), _resume, bgm_player)
	get_parent().add_child(settings_node)
	get_parent().remove_child(self)


func _unpause():
	get_tree().set_pause(false)
	queue_free()
