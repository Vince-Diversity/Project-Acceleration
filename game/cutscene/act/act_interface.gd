class_name Act extends GDScript
## Base class for acts, which are building blocks of a cutscene.

## Emitted when this act finishes.
signal act_finished


## Called at every frame update.
func update(_delta: float):
	pass


## Called when this act becomes the current act.
func enter():
	pass

## Called when this act is removed as the current act.
func exit():
	pass


## Called when managing focus of [Control] nodes.
func grab_focus():
	pass
