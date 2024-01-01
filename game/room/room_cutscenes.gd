class_name RoomCutscenes extends Node2D

@export var entrance_cutscene: String
var current_cutscene: Cutscene
var current_dialogue_id: String
var current_dialogue_node: String
var current_source_node: Node2D
var item_interact_cutscenes: Dictionary


func change_cutscenes(
		cutscene_node: String):
	current_cutscene = get_node(cutscene_node)


func change_dialogues(
		dialogue_id: String,
		dialogue_node):
	current_dialogue_id = dialogue_id
	current_dialogue_node = dialogue_node


func change_source_nodes(
		source_node: Node2D):
	current_source_node = source_node


func add_cutscene(cutscene_scn: PackedScene, cutscene_node: String):
	if not owner.cutscenes.has_node(cutscene_node):
		var cutscene = cutscene_scn.instantiate()
		owner.add_cutscene(cutscene, cutscene_node)


func reset():
	current_cutscene = null
	current_dialogue_id = ""
	current_dialogue_node = ""
	current_source_node = null
