class_name TogglingCheckButton extends CheckButton
## Custom [CheckButton] that calls a given [Callable] when toggled.


## Toggles the [CheckButton] and calls the given toggle_target accordingly.
## The toggle_target is assumed to take one boolean-typed argument.
func toggle(toggle_target: Callable):
	var mode = !is_pressed()
	set_pressed(mode)
	toggle_target.call(mode)
