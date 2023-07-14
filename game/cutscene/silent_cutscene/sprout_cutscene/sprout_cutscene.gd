extends SilentCutscene


func make():
	make_animate_act(get_player_anim_sprite(), Names.focus_anim)
	make_animate_act(get_thing_anim_sprite(), Names.sprout_anim)
	make_animate_act(get_thing_anim_sprite(), Names.sprouting_anim)
	make_animate_act(get_player_anim_sprite(), "default")

