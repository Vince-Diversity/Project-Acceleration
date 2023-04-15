extends Node

# Necessary dialogue nodes
const first_visit_dlg_node = "first_visit"
const visit_dlg_node = "visit"
const action_dlg_node = "execute_action"

# Optional dialogue nodes
const reactivation_dlg_node = "action_reactivated"

# Workaround on trying to iterate over all properties in a script
var property_list = [
	"visited",
	"current_room",
	"court_started",
	"in_blue_space",
	"yellow_joined",
	"blue_joined",
	"cat_lab_revealed",
	"court_ended",
	"has_ouroboros",
	"principal_office_revealed",
	"principal_office_remembered",
	"principal_office_burned",
	"library_revealed",
	"library_remembered",
	"library_burned",
	"talked_to_red",
	"red_joined",
]

# Storing states as properties like this is required by the Dialogue addon
var visited := []
var visited_with_blue = []
var current_room: String
var in_blue_space: bool
var court_started: bool
var court_ended: bool
var yellow_joined: bool
var has_ouroboros: bool
var blue_joined: bool
var talked_to_red: bool
var red_joined: bool

# Format is ROOM_NAME_SUFFIX
var cat_lab_revealed: bool
var principal_office_revealed: bool
var principal_office_remembered: bool
var principal_office_burned: bool
var library_revealed: bool
var library_remembered: bool
var library_burned: bool

func is_in_blue_space() -> bool:
	return in_blue_space

func is_blue_joined() -> bool:
	return blue_joined


func reset_states() -> void:
	for property in States.property_list:
		# For resetting all properties to the equivalent of null
		set(property, convert("", typeof(property)))
	# But it does not seem to work on arrays
	visited = []
