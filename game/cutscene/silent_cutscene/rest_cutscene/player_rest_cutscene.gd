extends RestCutscene


func make():
	var player_mark = get_thing_player_rest_mark()
	var rest_anim = get_thing_rest_animation()
	if is_instance_valid(player_mark):
		super()
		actm.add_act(
			make_move(
				[owner.party.player],
				[player_mark]))
		actm.add_act(make_animate_player(rest_anim))


func end_cutscene():
	super()
