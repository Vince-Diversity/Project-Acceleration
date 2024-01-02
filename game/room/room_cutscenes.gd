class_name RoomCutscenes extends Node2D

## Current active cutscene.
var current_cutscene: Cutscene

## Filename of the current [DialogueResource] if the current cutscene is a [DialogueCutscene].
var current_dialogue_id: String

## Title of the current dialogue if the current cutscene is a [DialogueCutscene],
## see [method DialogueResource.get_next_dialogue_line].
var current_dialogue_node: String

## Used to assign a scene instance in the current [Room]
## to be considered as the target of the current cutscene.
var current_source_node: Node2D


## Lists cutscene node names related to item usage, labeled by the item ID
## defined in [member Bubbles.item_bubble.current_item_sprite].
## The list is gradually updated in the current [Room] instance when items are used.
var item_interact_cutscenes: Dictionary


## Updates the [member current_cutscene].
func change_cutscenes(
		cutscene_node: String):
	current_cutscene = get_node(cutscene_node)


## Updates the [member current_dialogue_id] and [member current_dialogue_node].
func change_dialogues(
		dialogue_id: String,
		dialogue_node):
	current_dialogue_id = dialogue_id
	current_dialogue_node = dialogue_node


## Updates the [member current_source_node].
func change_source_nodes(
		source_node: Node2D):
	current_source_node = source_node


## Clears properties related to the current cutscene.
func reset():
	current_cutscene = null
	current_dialogue_id = ""
	current_dialogue_node = ""
	current_source_node = null
