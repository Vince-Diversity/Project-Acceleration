extends Node

const first_visit_dlg_node = "first_visit"
const visit_dlg_node = "visit"
const action_dlg_node = "execute_action"
const reactivation_dlg_node = "action_reactivated"

# Workaround on trying to iterate over all properties in a script
var property_list = [
	"visited",
	"current_room",
	"in_blue_space",
	"yellow_joined",
	"cat_lab_revealed",
]

# Storing states as properties like this is required by the Dialogue addon
var visited := []
var current_room := ""
var in_blue_space := false
var yellow_joined := false
var cat_lab_revealed := false

func reset_states() -> void:
	for property in States.property_list:
		# For resetting all properties
		set(property, convert("", typeof(property)))
	# But it does not seem to work on arrays
	visited = []
