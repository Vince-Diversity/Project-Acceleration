extends Act

var screen: Screen
var color: Color
var duration: float


func init_act(
		given_screen: Screen,
		given_color: Color,
		given_duration: int):
	screen = given_screen
	color = given_color
	duration = given_duration


func update(_delta: float):
	pass


func enter():
	screen.fade_finished.connect(_on_fade_finished, CONNECT_ONE_SHOT)
	screen.fade(color, duration)


func exit():
	pass


func grab_focus():
	pass


func _on_fade_finished():
	act_finished.emit()
