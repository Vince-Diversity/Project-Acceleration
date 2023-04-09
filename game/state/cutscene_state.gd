class_name CutsceneState extends State

var cutscenes: RoomCutscenes
var room: Room

signal pause_menu_prompted


func init_state(
		given_cutscenes: RoomCutscenes,
		given_room: Room,
		pause_menu_prompted_target: Callable):
	cutscenes = given_cutscenes
	room = given_room
	pause_menu_prompted.connect(pause_menu_prompted_target)


func update(delta: float):
	cutscenes.get_current_cutscene().update_cutscene(delta)


func handle_input(event: InputEvent):
	if event.is_action_pressed("ui_exit"):
		pause_menu_prompted.emit()


func handle_unhandled_input(_event: InputEvent):
	pass


func enter():
	cutscenes.get_current_cutscene().begin_cutscene()


func exit():
	pass
