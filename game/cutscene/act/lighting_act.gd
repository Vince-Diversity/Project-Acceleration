class_name LightingAct extends Act
## Plays out flashing, blinking, fading or other lighting effects.

## Reference to the current transition screen instance.
var screen: Screen

## The color of this act.
var color: Color

## The duration of this act.
var duration: float


## Initialises this act.
func init_act(
		given_screen: Screen,
		given_color: Color,
		given_duration: float):
	screen = given_screen
	color = given_color
	duration = given_duration


## Starts the effect of this act.
func enter():
	screen.fade_finished.connect(_on_fade_finished, CONNECT_ONE_SHOT)
	screen.fade(color, duration)


## Called when the effect of this act finishes.
func _on_fade_finished():
	act_finished.emit()
