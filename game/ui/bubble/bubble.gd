class_name Bubble extends AnimatedSprite2D

var exclamation_res: Resource = preload("res://resources/vfx/exclamation.tres")


func _ready():
	set_z_index(Utils.Elevation.UI)


func close():
	queue_free()
