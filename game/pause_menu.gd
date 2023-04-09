class_name PauseMenu extends Control

var stm: StateMachine

signal save_pressed
signal main_menu_pressed
signal focus_reset


func _ready():
	_ready_menu()


func _ready_menu():
	$MenuContainer/Resume.grab_focus()


func init_pause_menu(
		given_stm: StateMachine,
		save_pressed_target: Callable,
		main_menu_pressed_target: Callable,
		focus_reset_target: Callable):
	stm = given_stm
	save_pressed.connect(save_pressed_target)
	main_menu_pressed.connect(main_menu_pressed_target)
	focus_reset.connect(focus_reset_target)


func _on_Resume_pressed():
	focus_reset.emit()
	_close_menu()


# Disabled until saving is implemented
func _on_Save_pressed():
#	save_pressed.emit()
	$MenuContainer/Title.text = "Game saved!"
	$MenuContainer/Resume.disabled = true
	$MenuContainer/Save.disabled = true
	$MenuContainer/MainMenu.disabled = true
	await get_tree().create_timer(1.0).timeout
#	focus_reset.emit()
	_close_menu()


func _on_Main_Menu_pressed():
	main_menu_pressed.emit()


func _close_menu():
	stm.change_to_previous_state()
	queue_free()
