class_name CutsceneState extends State

var cutscenes: RoomCutscenes
var room: Room


func init_state(
		given_cutscenes: RoomCutscenes,
		given_room: Room):
	cutscenes = given_cutscenes
	room = given_room


func update(delta: float):
	cutscenes.get_current_cutscene().update_cutscene(delta)


func handle_input(_event: InputEvent):
	pass


func enter():
	cutscenes.get_current_cutscene().begin_cutscene()


func exit():
	pass


func grab_focus():
	cutscenes.get_current_cutscene().grab_cutscene_focus()
