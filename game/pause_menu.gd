class_name PauseMenu extends CanvasLayer

var stm: StateMachine

@onready var title = $Margin/MenuContainer/Title
@onready var resume = $Margin/MenuContainer/Resume
@onready var save = $Margin/MenuContainer/Save
@onready var main_menu = $Margin/MenuContainer/MainMenu

signal save_pressed
signal main_menu_pressed
signal pause_menu_closed


func _ready():
	set_process_mode(Node.PROCESS_MODE_WHEN_PAUSED)
	get_tree().set_pause(true)
	_ready_menu()


func _ready_menu():
	resume.pressed.connect(_on_resume_pressed)
	save.pressed.connect(_on_save_pressed)
	main_menu.pressed.connect(_on_main_menu_pressed)
	resume.grab_focus()


func init_pause_menu(
		save_pressed_target: Callable,
		main_menu_pressed_target: Callable,
		pause_menu_closed_target: Callable):
	save_pressed.connect(save_pressed_target)
	main_menu_pressed.connect(main_menu_pressed_target)
	pause_menu_closed.connect(pause_menu_closed_target)


func _on_resume_pressed():
	_unpause()


func _on_save_pressed():
	save_pressed.emit()
	title.text = "Saved!"
	resume.disabled = true
	save.disabled = true
	main_menu.disabled = true
	await get_tree().create_timer(1.0).timeout
	_unpause()


func _on_main_menu_pressed():
	_unpause()
	main_menu_pressed.emit()


func _unpause():
	get_tree().set_pause(false)
	queue_free()
