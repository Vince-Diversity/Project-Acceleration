class_name PlayerSkatingLeapingState extends PlayerSkatingState
## Player state when leaping while using ice skates.

## Moves the player and calls a leaping animation
## (using skating sprites).
func move(_delta: float):
	player.leap()
