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
	"library_locked",
	"court_started",
	"in_blue_space",
	"yellow_joined",
	"blue_joined",
	"cat_lab_revealed",
	"court_ended",
	"has_ouroboros"
]

# Storing states as properties like this is required by the Dialogue addon
var visited := []
var current_room: String
var library_locked: bool
var court_started: bool
var in_blue_space: bool
var yellow_joined: bool
var blue_joined: bool
var court_ended: bool
var has_ouroboros: bool

# Format is ROOM_NAME_revealed
var cat_lab_revealed: bool
var principal_office_revealed: bool

func is_in_blue_space() -> bool:
	return in_blue_space

func is_library_locked() -> bool:
	return library_locked

func is_blue_joined() -> bool:
	return blue_joined

func reset_states() -> void:
	for property in States.property_list:
		# For resetting all properties to the equivalent of null
		set(property, convert("", typeof(property)))
	# But it does not seem to work on arrays
	visited = []
