class_name CharacterMark extends Marker2D
## Used in the Godot editor to set a marker that a [Character]
## can move to during a [Cutscene].

## The direction that the character child node takes when arriving at this marker.
@export var target_direction_id: Utils.AnimID


## Gets the direction which corresponds to [member target_direction_id].
func get_target_direction() -> Vector2:
	return Utils.get_anim_direction(target_direction_id)
