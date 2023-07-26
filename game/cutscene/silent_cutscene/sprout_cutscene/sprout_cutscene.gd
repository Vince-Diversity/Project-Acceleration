extends SilentCutscene


func make():
	actm.add_act(make_animate_player_act(Names.focus_anim))
	actm.add_act(make_animate_act(get_thing_anim_sprite(), Names.sprout_anim))
	actm.add_act(make_animate_act(get_thing_anim_sprite(), Names.sprouting_anim))
	actm.add_act(make_animate_player_act("default"))
