class_name InteractingBubble extends Bubble
## A thought bubble that shows when an interaction is possible.

## Reference to the interaction sprite in the thought bubble.
@onready var interacting_sprite: AnimatedSprite2D = $InteractingSprite

const _exclamation_res: Resource = preload("res://resources/vfx/exclamation.tres")


## Adds an interaction sprite to the thought bubble.
## Currently, the same interaction sprite is used for all possible interaction.
func make_bubble():
	interacting_sprite.set_sprite_frames(_exclamation_res)
