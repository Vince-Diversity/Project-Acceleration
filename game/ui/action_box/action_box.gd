extends Control

onready var action_ctr_scn = preload("res://game/ui/action_box/action_container.tscn")
var action_ctr

func load_action_ctr(input_node):
	action_ctr = action_ctr_scn.instance()
	add_child(action_ctr)
	action_ctr.load_actions(input_node)

func remove_action_ctr():
	action_ctr.queue_free()

func _on_TextBox_responses_displayed(input_node):
	load_action_ctr(input_node)

func _on_TextBox_input_given():
	remove_action_ctr()
