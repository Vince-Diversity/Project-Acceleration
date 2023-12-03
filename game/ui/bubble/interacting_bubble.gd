class_name InteractingBubble extends Bubble

@onready var interacting_sprite = $InteractingSprite
const exclamation_res: Resource = preload("res://resources/vfx/exclamation.tres")


func make_bubble():
	interacting_sprite.set_sprite_frames(exclamation_res)


func reset_bubble():
	bubble_sprite.set_modulate(Color(1,1,1,1))


func close():
	super()
