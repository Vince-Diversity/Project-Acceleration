extends SilentCutscene


func make():
	actm.add_act(
		make_move(
			[owner.party.player],
			[get_thing_stand_up_mark()]))
	actm.add_act(make_animate_player("default"))


func end_cutscene():
	super()
	set_thing_state(
		get_thing().name,
		"thing_interactable_state")
	cutscene_ended.emit("roam_state")


func get_thing_stand_up_mark() -> CharacterMark:
	return cutscenes.current_source_node.stand_up_mark
