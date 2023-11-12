extends Node2D

@onready var exhibit_mark = $ExhibitMark
@onready var exhibit_background = $ExhibitMark/ExhibitBackground
var exhibit_item: Node2D


func set_exhibit_item(item_id: String):
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
