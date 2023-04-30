extends Marker2D

@export var target_direction_id: Utils.AnimID

func get_target_direction() -> Vector2:
	return Utils.get_anim_direction(target_direction_id)
