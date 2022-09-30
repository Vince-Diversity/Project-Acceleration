extends Control

signal save_pressed

func _ready():
	_ready_menu()

func _ready_menu():
	$MenuContainer/Resume.grab_focus()

func _on_Resume_pressed():
	queue_free()

func _on_Save_pressed():
	emit_signal("save_pressed")
	$MenuContainer/Title.text = "Game saved!"
	$MenuContainer/Resume.disabled = true
	$MenuContainer/Save.disabled = true
	$MenuContainer/MainMenu.disabled = true
	yield(get_tree().create_timer(1), "timeout")
	queue_free()

func _on_Main_Menu_pressed():
	Loader.enter_main_menu()
