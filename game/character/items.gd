class_name Items extends Node2D
## Manages items that are obtained or used by a [Character].
##
## Any character can show any [Item], which adds an item node instance to [member exhibit_item].
## The [Player] can also examine or use an obtained item.
## For these player interactions, it is not necessary to add that [Item]
## to the [SceneTree]. Instead, only the [ItemSprite] corresponding to that item is used.
## For that reason, every item has both an [Item] node and separate [ItemSprite] resource.
## By convention, the ID of an item is defined as the filename (without the extension) of the [ItemSprite] resource.


@onready var _exhibit_mark = $ExhibitMark
@onready var _exhibit_background = $ExhibitMark/ExhibitBackground
@onready var _floating_mark = $FloatingMark

## List of item IDs of the items currently obtained by the character with this node.
var item_id_list: Array = []

## Item IDs list after the last [CutsceneState] ended.
var preserved_item_id_list: Array = []

## The item currently shown by the character with this node.
## Does not necessarily have to be an item obtained by that character.
var exhibit_item: Item

var floating_item: Item


## Adds the given [code]item_id[/code] to the [member item_id_list].
func add_item(item_id: String):
	item_id_list.append(item_id)


## Has the character with this node display the [Item] with the given [code]item_id[/code]
func start_exhibit_item(item_id: String):
	clear_exhibit()
	var item_path = Utils.get_item_path(item_id)
	if ResourceLoader.exists(item_path):
		exhibit_item = load(item_path).instantiate()
		_exhibit_mark.add_child(exhibit_item)
		_exhibit_background.set_visible(true)


## Has the [Item] with the given [code]item_id[/code] float above the character with this node.
func start_floating_item(item_id: String):
	if is_instance_valid(floating_item): floating_item.queue_free()
	var item_path = Utils.get_item_path(item_id)
	if ResourceLoader.exists(item_path):
		floating_item = load(item_path).instantiate()
		_floating_mark.add_child(floating_item)


## Frees the currently displayed [member exhibit_item].
func clear_exhibit():
	if is_instance_valid(exhibit_item):
		exhibit_item.queue_free()
	_exhibit_background.set_visible(false)


## Saves the item list to the given [code]sg[/code].
func make_save(sg: SaveGame):
	sg.data[sg.items_key] = item_id_list


## Saves this item list at a previous point in the game session to the given [code]sg[/code].
func make_preserved_save(sg: SaveGame):
	sg.data[sg.items_key] = preserved_item_id_list


## Loads the item thing from the given [code]sg[/code].
## Since this is a nested node, a parent node needs to call this when that parent is loaded.
func load_save_from_parent(sg: SaveGame):
	if sg.data.has(sg.items_key):
		item_id_list = sg.data[sg.items_key]
		preserved_item_id_list = item_id_list.duplicate()


## Called when a [CutsceneState] ends.
func exit_cutscene():
	clear_exhibit()
	preserved_item_id_list = item_id_list.duplicate()
