class_name Screen extends CanvasLayer

@onready var overcast = $Overcast
const default_duration := 0.5
const instant := 0.1
var default_ease_type := Tween.EASE_IN_OUT
var default_trans_type := Tween.TRANS_LINEAR

signal fade_finished


func fade(
		color: Color,
		duration: float,
		ease_type: int = default_ease_type,
		trans_type: int = default_trans_type):
	var tween = create_tween()
	tween.set_ease(ease_type)
	tween.set_trans(trans_type)
	tween.tween_property(overcast, "color", color, duration)
	tween.finished.connect(_on_tween_finished)


func fade_in(duration = default_duration):
	fade(Color.BLACK, duration)


func fade_out(duration = default_duration):
	fade(Color.TRANSPARENT, duration)


func reset_fade():
	fade(Color.TRANSPARENT, instant)


func _on_tween_finished():
	fade_finished.emit()
