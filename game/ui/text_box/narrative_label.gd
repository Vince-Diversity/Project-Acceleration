extends "res://addons/dialogue_manager/dialogue_label.gd"

func type_out() -> void:
	.type_out()
	if dialogue.character != "":
		bbcode_text = "%s: %s" % [dialogue.character, bbcode_text]
