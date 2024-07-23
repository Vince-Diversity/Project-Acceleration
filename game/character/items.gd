class_name Items extends Node2D
## Manages items that are obtained or used by a [Character].
##
## Any character can show any [Item], which adds an item node instance to [member exhibit_item].
## The [Player] can also examine or use an obtained item.
## For these player interactions, it is not necessary to add that [Item]
## to the [SceneTree]. Instead, only the [ItemSprite] corresponding to that item is used.
## For that reason, every item has both an [Item] node and separate [ItemSprite] resource.
## By convention, the ID of an item is defined as the filename (without the extension) of the [ItemSprite] resource.
## [br]
## [br]
## The effects of an item are defined in the [ItemSprite] resources
## and are instanced into the game in the [member item_effect_list].
## An item effect allows changing what happens when browsing or selecting the item
## and saving those changes.

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

const browse_dialogue_node_key = "browse_dialogue_node"
const interaction_dialogue_node_key = "interaction_dialogue_node"
const items_state_id_key = "items_state_id"

## List of item IDs of the items currently obtained by the character with this node.
var item_id_list: Array = []

## Dictionary mapping item IDs to the effects of that item.
## All possible types of items are listed here
## because new items may be added to the [member item_id_list].
var item_effect_list: Dictionary

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
	_ready_item_effect_list()
	state_list[_absent_state.state_id] = _absent_state
	state_list[_exhibit_state.state_id] = _exhibit_state
	state_list[_above_state.state_id] = _above_state
	current_state = state_list[_absent_state.state_id]


func _ready_item_effect_list():
	for item_id in Utils.get_files_in_dir(Utils.item_sprite_dir):
		var item_sprite_path = Utils.get_item_sprite_path(item_id)
		var item_sprite_res = load(item_sprite_path)
		var item_dict := {}
		item_effect_list[item_id] = item_dict
		item_dict[browse_dialogue_node_key] = item_sprite_res["browse_dialogue_node"]
		item_dict[interaction_dialogue_node_key] = item_sprite_res["interaction_dialogue_node"]
		item_dict[items_state_id_key] = item_sprite_res["items_state_id"]


func _add_floating_item(item_id: String):
	var item_path = Utils.get_item_path(item_id)
	if ResourceLoader.exists(item_path):
		floating_item = load(item_path).instantiate()
		floating_item.init_item(item_id)
		_floating_mark.add_child(floating_item)


func _clear_floating_item():
	if is_instance_valid(floating_item):
		floating_item.queue_free()


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


## Clears items that the player is actively holding.
func clear_holding_items():
	current_state.clear_holding()


## Clears items regardless of whether the player is actively holding it or not.
func clear_any_items():
	current_state.clear_any()


## Checks if the player is animating an item.
func is_animating_item() -> bool:
	return current_state.is_animating()


func _make_save_helper(sg: SaveGame, items_dict: Dictionary):
	## save changes to what happens when an item is browsed or selected
	sg.data[sg.items_key][sg.item_effect_key] = item_effect_list
	## if there are any floating items, save their appearance
	if is_instance_valid(floating_item):
		items_dict[sg.floating_key] = floating_item.item_id
	else:
		items_dict[sg.floating_item_key] = ""


## Saves the item list to the given [code]sg[/code].
func make_save(sg: SaveGame):
	var items_dict := {}
	sg.data[sg.items_key] = items_dict
	## save what items the player has obtained
	items_dict[sg.item_list_key] = item_id_list
	_make_save_helper(sg, items_dict)


## Saves this item list at a previous point in the game session to the given [code]sg[/code].
## But only the item list being updated should be restored to a previous point.
## This is because when an item is used to change rooms, so far the game session state
## when that happens is a cutscene state, so this function is called before changing rooms
## instead of the ordinary [method make_save].
func make_preserved_save(sg: SaveGame):
	var items_dict := {}
	sg.data[sg.items_key] = items_dict
	## save what items the player had obtained at a previous point in the game session
	items_dict[sg.item_list_key] = preserved_item_id_list
	_make_save_helper(sg, items_dict)


## Loads the item thing from the given [code]sg[/code].
## Since this is a nested node, a parent node needs to call this when that parent is loaded.
func load_save_from_parent(sg: SaveGame):
	if sg.data.has(sg.items_key):
		var items_dict = sg.data[sg.items_key]
		if items_dict.has(sg.item_list_key):
			## load what items the player has obtained
			item_id_list = items_dict[sg.item_list_key]
		preserved_item_id_list = item_id_list.duplicate()
		## load any changes to what happens when an item is browsed or selected
		item_effect_list = items_dict[sg.item_effect_key]
		## load any floating items
		if items_dict.has(sg.floating_key):
			_add_floating_item(items_dict[sg.floating_key])


## Called when a [CutsceneState] ends.
func exit_cutscene():
	## Clear items first before changing to default state.
	clear_holding_items()
	change_states("items_absent_state")
	preserved_item_id_list = item_id_list.duplicate()
