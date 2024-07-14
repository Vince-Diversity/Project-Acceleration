class_name Items extends Node2D
## Manages items that are obtained or used by a [Character].
##
## Any character can show any [Item], which adds an item node instance to [member exhibit_item].
## The [Player] can also examine or use an obtained item.
## For these player interactions, it is not necessary to add that [Item]
## to the [SceneTree]. Instead, only the [ItemSprite] corresponding to that item is used.
## For that reason, every item has both an [Item] node and separate [ItemSprite] resource.
## By convention, the ID of an item is defined as the filename (without the extension) of the [ItemSprite] resource.

@onready var _absent_state =\
	preload("res://game/character/player/items_state/items_absent_state.gd").new("items_absent_state")
@onready var _exhibit_state =\
	preload("res://game/character/player/items_state/items_exhibit_state.gd").new("items_exhibit_state")
@onready var _above_state =\
	preload("res://game/character/player/items_state/items_above_state.gd").new("items_above_state")
@warning_ignore("unused_private_class_variable")
@onready var _exhibit_mark = $ExhibitMark
@warning_ignore("unused_private_class_variable")
@onready var _exhibit_background = $ExhibitMark/ExhibitBackground
@warning_ignore("unused_private_class_variable")
@onready var _floating_mark = $FloatingMark

## List of item IDs of the items currently obtained by the character with this node.
var item_id_list: Array = []

## Item IDs list after the last [CutsceneState] ended.
var preserved_item_id_list: Array = []

## An item currently shown by the character with this node.
## Does not necessarily have to be an item obtained by that character.
var exhibit_item: Item

## An item that floats above the character.
var floating_item: Item

## List of [ItemsState] instances labeled by each respective [member ItemsState.state_id].
var state_list: Dictionary

## Current activated item animation state.
var current_state: ItemsState


func _ready():
	state_list[_absent_state.state_id] = _absent_state
	state_list[_exhibit_state.state_id] = _exhibit_state
	state_list[_above_state.state_id] = _above_state
	current_state = state_list[_absent_state.state_id]


## Initialises this node after it is added to the [SceneTree].
func make_items(player: Player):
	_absent_state.make_state(player)
	_exhibit_state.make_state(player)
	_above_state.make_state(player)


## Changes the [member current_state] to the given [code]items_state_id[/code].
func change_states(items_state_id: String):
	current_state = state_list[items_state_id]


## Adds the given [code]item_id[/code] to the [member item_id_list].
func add_item(item_id: String):
	item_id_list.append(item_id)


## Shows animations when the item with the given [code]item_id[/code] is selected.
func animate_item_selected(item_id: String):
	current_state.animate_item_selected(item_id)


## Clears temporary items.
func clear_items():
	current_state.clear()


## Checks if the player is animating an item.
func is_animating_item() -> bool:
	return current_state.is_animating()


func _add_exhibit_item(item_id: String):
	var item_path = Utils.get_item_path(item_id)
	if ResourceLoader.exists(item_path):
		exhibit_item = load(item_path).instantiate()
		exhibit_item.init_item(item_id)
		_exhibit_mark.add_child(exhibit_item)
		_exhibit_background.set_visible(true)


func _add_floating_item(item_id: String):
	var item_path = Utils.get_item_path(item_id)
	if ResourceLoader.exists(item_path):
		floating_item = load(item_path).instantiate()
		floating_item.init_item(item_id)
		_floating_mark.add_child(floating_item)


## Saves the item list to the given [code]sg[/code].
func make_save(sg: SaveGame):
	var items_dict := {}
	sg.data[sg.items_key] = items_dict
	items_dict[sg.item_list_key] = item_id_list
	if is_instance_valid(floating_item):
		items_dict[sg.floating_key] = floating_item.item_id
	else:
		items_dict[sg.floating_item_key] = ""


## Saves this item list at a previous point in the game session to the given [code]sg[/code].
func make_preserved_save(sg: SaveGame):
	sg.data[sg.items_key] = preserved_item_id_list


## Loads the item thing from the given [code]sg[/code].
## Since this is a nested node, a parent node needs to call this when that parent is loaded.
func load_save_from_parent(sg: SaveGame):
	if sg.data.has(sg.items_key):
		var items_dict = sg.data[sg.items_key]
		item_id_list = items_dict[sg.item_list_key]
		preserved_item_id_list = item_id_list.duplicate()
		_add_floating_item(items_dict[sg.floating_key])


## Called when a [CutsceneState] ends.
func exit_cutscene():
	## Clear items first before changing to default state.
	clear_items()
	change_states("items_absent_state")
	preserved_item_id_list = item_id_list.duplicate()
