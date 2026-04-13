class_name Bubble extends Node2D
## Base scene for a thought bubble, which is made from multiple overlapping sprites.

## Reference to the sprite of just the thought bubble, without any contents.
@onready var bubble_sprite: AnimatedSprite2D = $BubbleSprite


func _ready():
	set_z_index(Utils.Elevation.UI)


## Resets any visual modifiers on the thought bubble.
func reset_bubble():
	bubble_sprite.set_modulate(Color(1,1,1,1))


## Called when this bubble is freed.
func close():
	queue_free()
