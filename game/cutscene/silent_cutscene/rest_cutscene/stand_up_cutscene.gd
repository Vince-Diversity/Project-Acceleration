extends SilentCutscene


func make():
	var stand_up_mark = get_thing_stand_up_mark()
	if is_instance_valid(stand_up_mark):
		actm.add_act(
			make_move(
				[owner.party.player],
				[stand_up_mark]))
		actm.add_act(make_animate_player("default"))


func end_cutscene():
	super()
	owner.party.set_z_index(0)
	set_thing_state(
		get_thing().name,
		"thing_interactable_state")
	cutscene_ended.emit("roam_state")


func get_thing_stand_up_mark() -> CharacterMark:
	return cutscenes.current_source_node.get_node("MentorStandUpMark")
