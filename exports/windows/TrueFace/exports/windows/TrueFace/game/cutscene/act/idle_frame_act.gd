class_name IdleFrameAct extends Act
## An empty act that starts and ends in a single frame. Used for workarounds.

var counter := 0

## Finish this act on the second frame.
func update(_delta):
	if counter > 0:
		act_finished.emit()
	else:
		counter += 1
