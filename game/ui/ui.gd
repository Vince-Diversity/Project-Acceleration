extends Control

onready var text_box = $TextBox
onready var action_box = $ActionBox

signal accept_pressed
signal action_input(is_pressing, id)

signal input_on_responding(input_type, index)
signal change_room

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("accept_pressed")
	if event.is_action_pressed("ui_action_0"):
		emit_signal("action_input", true, Names.REVEALER)
	if event.is_action_released("ui_action_0"):
		emit_signal("action_input", false, Names.REVEALER)

func load_ui():
	text_box.input_node = self
	text_box.connect("responses_displayed", action_box, "_on_TextBox_responses_displayed")
	text_box.connect("input_given", action_box, "_on_TextBox_input_given")
	text_box.connect("finished_next_set", self, "_on_TextBox_finished_next_set")
	text_box.load_text(States.current_room)

func _on_Response_selected(resp_index: int):
	emit_signal("input_on_responding", Utils.InputType.RESPONSE, resp_index)

func _on_Action_selected(action_id: String):
	emit_signal("input_on_responding", Utils.InputType.ACTION, action_id)

func _on_Action_reactivated(action_id: String):
	emit_signal("input_on_responding", Utils.InputType.REACTIVATION, action_id)

func _on_Action_focus_entered():
	# Workaround, pressing down somehow focuses on the action node. This reverts the focus.
	text_box.resp_arr[-1].grab_focus()

func _on_TextBox_finished_next_set():
	emit_signal("change_room")
