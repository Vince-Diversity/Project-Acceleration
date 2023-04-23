class_name Bubble extends AnimatedSprite2D

enum Content {EXCLAMATION}

var exclamation_res: Resource = preload("res://resources/vfx/exclamation.tres")


func init_bubble(given_content_id: int):
	match given_content_id:
		Content.EXCLAMATION:
			set_sprite_frames(exclamation_res)


func close():
	queue_free()
