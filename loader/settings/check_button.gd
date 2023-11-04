extends CheckButton


func toggle(toggle_target: Callable):
	var mode = !is_pressed()
	set_pressed(mode)
	toggle_target.call(mode)
