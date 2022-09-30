extends Button

var index: int

signal selected(index)

func prompt(prompt: String) -> void:
	text = prompt

func _on_Response_pressed():
	emit_signal("selected", index)
