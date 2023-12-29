class_name Items extends Node2D

@onready var exhibit_mark = $ExhibitMark
@onready var exhibit_background = $ExhibitMark/ExhibitBackground
var item_id_list: Array = []
var preserved_item_id_list: Array = []
var exhibit_item: Item


func add_item(item_id: String):
	item_id_list.append(item_id)


func start_exhibit_item(item_id: String):
	clear_exhibit()
	var item_path = Utils.get_item_path(item_id)
	if ResourceLoader.exists(item_path):
		exhibit_item = load(item_path).instantiate()
		exhibit_mark.add_child(exhibit_item)
		exhibit_background.set_visible(true)


func clear_exhibit():
	if is_instance_valid(exhibit_item):
		exhibit_item.queue_free()
	exhibit_background.set_visible(false)


func make_save(sg: SaveGame):
	sg.data[sg.items_key] = item_id_list


func make_preserved_save(sg: SaveGame):
	sg.data[sg.items_key] = preserved_item_id_list


func load_save(_sg: SaveGame):
	pass # This node is nested so no call to this happens when loading


func exit_cutscene():
	clear_exhibit()
	preserved_item_id_list = item_id_list.duplicate()


func load_save_from_parent(sg: SaveGame):
	if sg.data.has(sg.items_key):
		item_id_list = sg.data[sg.items_key]
		preserved_item_id_list = item_id_list.duplicate()
