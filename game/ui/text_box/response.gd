extends Button

var index: int
var scroll_bar: ScrollBar

signal selected(index)

func prompt(prompt: String) -> void:
	text = prompt
	yield(get_tree(), "idle_frame")
	scroll_bar.value = scroll_bar.max_value

func _on_Response_pressed():
	emit_signal("selected", index)
