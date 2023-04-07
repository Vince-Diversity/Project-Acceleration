class_name CutsceneState extends State

var cutscenes: RoomCutscenes
var room: Room

func init_state(given_cutscenes: RoomCutscenes, given_room:  Room):
	cutscenes = given_cutscenes
	room = given_room


func update(delta: float):
	cutscenes.get_children()[0].do_cutscene(delta, room)


func handle_input():
	pass


func enter():
	pass


func exit():
	pass
