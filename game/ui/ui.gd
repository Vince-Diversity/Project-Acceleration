extends Control

onready var text_box = $TextBox
onready var action_box = $ActionBox

signal change_room

func load_ui():
	text_box.connect("finished_next_set", self, "_on_TextBox_finished_next_set")
	text_box.load_text(States.current_room)
	action_box.load_actions()

func _on_TextBox_finished_next_set():
	emit_signal("change_room")
