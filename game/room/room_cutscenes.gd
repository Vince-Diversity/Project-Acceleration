class_name RoomCutscenes extends Node2D

var current_cutscene: Cutscene
var current_dialogue_id: String
var current_dialogue_node: String
var current_source_node: String


func change_cutscene(
		cutscene_node: String):
	current_cutscene = get_node(cutscene_node)


func change_dialogue(
		dialogue_id: String,
		dialogue_node):
	current_dialogue_id = dialogue_id
	current_dialogue_node = dialogue_node


func change_source_node(
		source_node: String):
	current_source_node = source_node
