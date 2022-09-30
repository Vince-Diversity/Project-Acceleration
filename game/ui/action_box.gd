extends Control

onready var action_ctr_scn = preload("res://game/ui/action_box/action_container.tscn")

func load_actions():
	var action_ctr = action_ctr_scn.instance()
	add_child(action_ctr)
	
