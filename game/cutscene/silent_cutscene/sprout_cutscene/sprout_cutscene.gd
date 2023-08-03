extends SilentCutscene


func make():
	actm.add_act(make_animate_player(Names.focus_anim))
	actm.add_act(make_animate(get_thing_anim_sprite(), Names.sprout_anim))
	actm.add_act(make_animate(get_thing_anim_sprite(), Names.sprouting_anim))
	actm.add_act(make_animate_player("default"))
