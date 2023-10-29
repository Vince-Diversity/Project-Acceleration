class_name SilentCutscene extends Cutscene


func make():
	pass


func begin_cutscene():
	super()


func end_cutscene():
	super()


func update_cutscene(delta: float):
	super(delta)


func grab_cutscene_focus():
	super()


func get_thing() -> Thing:
	return cutscenes.current_source_node


func get_thing_anim_sprite() -> AnimatedSprite2D:
	return cutscenes.current_source_node.anim_sprite
