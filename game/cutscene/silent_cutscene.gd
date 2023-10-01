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


func set_thing_state(thing_node: String, thing_state_id: String):
	if owner.things.has_node(thing_node):
		owner.things.get_node(thing_node).change_state(thing_state_id)


func get_thing() -> Thing:
	return cutscenes.current_source_node


func get_thing_anim_sprite() -> AnimatedSprite2D:
	return cutscenes.current_source_node.anim_sprite
