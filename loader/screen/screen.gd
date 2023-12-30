class_name Screen extends CanvasLayer
## Displays screen transitions.


const default_duration := 0.5
const instant_duration := 0.1
const default_ease_type := Tween.EASE_IN_OUT
const default_trans_type := Tween.TRANS_LINEAR
@onready var _overcast = $Overcast

## Current tween instance.
var tween: Tween

## Emits when a screen transition has finished
signal fade_finished


## Turns the screen into an arbitrary [Color].
func fade(
		color: Color,
		duration: float,
		ease_type: int = default_ease_type,
		trans_type: int = default_trans_type):
	tween = create_tween()
	tween.set_ease(ease_type)
	tween.set_trans(trans_type)
	tween.tween_property(_overcast, "color", color, duration)
	tween.finished.connect(_on_tween_finished)


## Turns the screen dark.
func fade_in(duration = default_duration):
	fade(Color.BLACK, duration)


## Gradually displays the game.
func fade_out(duration = default_duration):
	fade(Color.TRANSPARENT, duration)


## Removes all screen transition effects instantly.
func reset_fade():
	if is_instance_valid(tween):
		tween.kill()
	fade(Color.TRANSPARENT, instant_duration)


func _on_tween_finished():
	fade_finished.emit()
