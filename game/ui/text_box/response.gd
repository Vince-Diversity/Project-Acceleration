extends Button

onready var key = $ResponseText
var index: int

signal selected(index)

func prompt(prompt: String) -> void:
	key.bbcode_text = prompt
	yield(get_tree(), "idle_frame")
	rect_min_size = key.rect_size

func disable() -> void:
	set_disabled(true)

func _on_Response_pressed():
	emit_signal("selected", index)
