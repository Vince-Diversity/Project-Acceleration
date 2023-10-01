extends SilentCutscene


func make():
	actm.add_act(
		make_move(
			[owner.party.player],
			[cutscenes.current_source_node.mentor_stand_up_mark]))
	actm.add_act(make_animate_player("default"))


func end_cutscene():
	super()
	set_thing_state(
		get_thing().name,
		"thing_interactable_state")
	cutscene_ended.emit("roam_state")
