extends HBoxContainer

onready var action_scn = preload("res://game/ui/action_box/action.tscn")

signal action_reactivated(action_id)

func load_actions(input_node):
	if States.yellow_joined:
		add_action(input_node, Names.REVEALER)
	if States.blue_joined and States.has_ouroboros:
		add_action(input_node, Names.TRAVELLER)
	input_node.connect("action_input", self, "_on_action_input")
	connect("action_reactivated", input_node, "_on_Action_reactivated")

func add_action(input_node, action_id: String):
	var action = action_scn.instance()
	add_child(action)
	action.load_action(input_node, action_id)

func is_action_activated(action_id: String) -> bool:
	var b = States.get(Utils.get_action_state_name(States.current_room, action_id))
	if b == null: return false
	return b

func _on_action_input(is_pressing: bool, action_id: String):
	for action in get_children():
		if action.id == action_id:
			if is_pressing:
				action.press_action()
			else:
				action.release_action()
				if is_action_activated(action_id):
					emit_signal("action_reactivated", action_id)
				else:
					action.send_selected(action.id)
			break
