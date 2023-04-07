class_name CutsceneState extends State

var cutscenes: RoomCutscenes
var room: Room


func update(delta: float) -> void:
	cutscenes.get_children()[0].do_cutscene(delta, room)


func handle_input() -> void:
	pass


func enter() -> void:
	pass


func exit() -> void:
	pass
