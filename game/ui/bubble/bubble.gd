class_name Bubble extends Node2D

@onready var bubble_sprite = $BubbleSprite


func _ready():
	set_z_index(Utils.Elevation.UI)


func close():
	queue_free()
