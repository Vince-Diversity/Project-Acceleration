class_name SilentCutscene extends Cutscene


func make():
	pass


func begin_cutscene():
	super()


func end_cutscene():
	super()
	cutscene_ended.emit("party_roam_state")


func update_cutscene(delta: float):
	super(delta)


func grab_cutscene_focus():
	super()


func get_thing_anim_sprite() -> AnimatedSprite2D:
	return cutscenes.current_source_node.anim_sprite
