class_name SilentCutscene extends Cutscene
## Base scene for cutscenes that have no dialogue.


## Gets the thing that the this cutscene is targeting.
## That thing is given by [member RoomCutscenes.current_source_node].
func get_thing() -> Thing:
	return cutscenes.current_source_node


## Gets the sprite of the thing that this cutscene is targeting.
func get_thing_anim_sprite() -> AnimatedSprite2D:
	return cutscenes.current_source_node.anim_sprite
