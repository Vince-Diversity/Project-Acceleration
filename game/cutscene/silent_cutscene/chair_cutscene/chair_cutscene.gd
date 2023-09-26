extends SilentCutscene

func make():
	set_thing_state(
		get_thing().name,
		"thing_permeable_state")
	actm.add_act(
		make_move(
			[owner.party.player],
			[get_thing_character_mark()]))
	actm.add_act(make_animate_player("sit_down"))


func get_thing_character_mark() -> CharacterMark:
	return cutscenes.current_source_node.character_mark
