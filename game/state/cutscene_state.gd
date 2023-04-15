class_name CutsceneState extends State

var cutscenes: RoomCutscenes


func init_state(
		given_cutscenes: RoomCutscenes):
	cutscenes = given_cutscenes


func update(delta: float):
	cutscenes.current_cutscene.update_cutscene(delta)


func handle_input(_event: InputEvent):
	pass


func enter():
	cutscenes.current_cutscene.begin_cutscene()


func exit():
	pass


func grab_focus():
	cutscenes.current_cutscene.grab_cutscene_focus()
