extends Node

var is_mentoring = true


func make_save(sg: SaveGame):
	sg.data[sg.condition_key][sg.mentoring_condition_key] = is_mentoring


func make_preserved_save(sg: SaveGame):
	make_save(sg)


func load_save(sg: SaveGame):
	is_mentoring = sg.data[sg.condition_key][sg.mentoring_condition_key]
