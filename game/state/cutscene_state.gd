class_name CutsceneState extends State

var cutscenes: RoomCutscenes
var room: Room

signal prompt_pause_menu


func init_state(
		given_cutscenes: RoomCutscenes,
		given_room: Room,
		prompt_pause_menu_target: Callable):
	cutscenes = given_cutscenes
	room = given_room
	prompt_pause_menu.connect(prompt_pause_menu_target)


func update(delta: float):
	cutscenes.get_children()[0].do_cutscene(delta, room)


func handle_input(event: InputEvent):
	if event.is_action_pressed("ui_exit"):
		prompt_pause_menu.emit()


func handle_unhandled_input(_event: InputEvent):
	pass


func enter():
	pass


func exit():
	pass
