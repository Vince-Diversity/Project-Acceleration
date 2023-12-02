class_name Bubble extends AnimatedSprite2D

var exclamation_res: Resource = preload("res://resources/vfx/exclamation.tres")


func _ready():
	set_z_index(2)


func init_bubble():
	set_sprite_frames(exclamation_res)


func close():
	queue_free()
