extends Node2D

@onready var interacting_bubble_mark = $InteractingBubbleMark
@onready var item_bubble_mark = $ItemBubbleMark
@onready var interacting_bubble_scn = preload("res://game/ui/bubble/interacting_bubble.tscn")
@onready var item_bubble_scn = preload("res://game/ui/bubble/item_bubble.tscn")
var interacting_bubble: InteractingBubble
var item_bubble: ItemBubble
var item_interactable := false


func add_interacting_bubble():
	interacting_bubble = interacting_bubble_scn.instantiate()
	interacting_bubble_mark.add_child(interacting_bubble)
	interacting_bubble.make_bubble()


func add_item_bubble(item_id: String):
	item_bubble = item_bubble_scn.instantiate()
	item_bubble_mark.add_child(item_bubble)
	item_bubble.set_current_item_id(item_id)
	if item_interactable:
		modulate_bubbles()


func modulate_bubbles():
	interacting_bubble.bubble_sprite.set_modulate(Color.VIOLET)
	item_bubble.bubble_sprite.set_modulate(Color.VIOLET)


func reset_modulation():
	for bubble in get_bubbles():
		if is_instance_valid(bubble):
			bubble.set_modulate(Color(1,1,1,1))


func get_bubbles() -> Array:
	var arr := []
	for marker in get_children():
		if marker.get_child_count() != 0:
			arr.append(marker.get_child(0))
	return arr
