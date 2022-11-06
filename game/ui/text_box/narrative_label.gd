extends "res://addons/dialogue_manager/dialogue_label.gd"

var scroll_bar: ScrollBar

func type_out() -> void:
	.type_out()
	yield(get_tree(), "idle_frame")
	scroll_bar.value = scroll_bar.max_value
	if dialogue.character != "":
		bbcode_text = "%s: %s" % [dialogue.character, bbcode_text]
