extends Node

const first_visit_dlg_node = "first_visit"
const revisit_dlg_node = "visit"

var visited := []

var current_room: String
var in_blue_space := false

func is_in_blue_space():
	return in_blue_space
