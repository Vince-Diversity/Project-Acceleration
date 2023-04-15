extends Marker2D

@export var target_direction_id: Utils.AnimID

func get_target_direction() -> Vector2:
	return Utils.anim_direction.find_key(target_direction_id)
