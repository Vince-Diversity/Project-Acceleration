extends Control

onready var button = $ActionButton
onready var key = $ActionKey
var id: String

signal selected(id)

func load_action(input_node, action_id: String):
	connect("selected", input_node, "_on_Action_selected")
	button.connect("focus_entered", input_node, '_on_Action_focus_entered')
	id = action_id
	button.text = Names.action_names[action_id]
	key.text = Names.action_keys[action_id]

func press_action():
	button.pressed = true

func release_action():
	button.pressed = false

func send_selected(action_id: String):
	emit_signal("selected", action_id)

