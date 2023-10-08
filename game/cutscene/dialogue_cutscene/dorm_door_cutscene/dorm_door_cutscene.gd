extends DialogueCutscene

var door_number: String:
	get:
		var floor_number = owner.name.to_int()
		var number = cutscenes.current_source_node.name.to_int()
		if number > 0: door_number = "%d%02.0d" % [floor_number, number]
		return door_number
