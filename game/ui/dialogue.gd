extends Control

signal answered

func _on_Response_selected(resp_index: int):
	emit_signal("answered", resp_index)
