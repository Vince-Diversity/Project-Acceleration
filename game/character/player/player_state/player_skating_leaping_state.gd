class_name PlayerSkatingLeapingState extends PlayerSkatingState
## Player state when leaping while using ice skates.

## Moves the player and calls a leaping animation
## (using skating sprites).
func move(_delta: float):
	player.leap()

## Same as [method PlayerSkatingState.enter] except
## using a different movement speed.
func enter():
	super()
	player.speed = player.skating_leaping_speed
