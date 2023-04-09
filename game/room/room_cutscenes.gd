class_name RoomCutscenes extends Node2D


func get_current_cutscene() -> Cutscene:
	return get_children()[0]
