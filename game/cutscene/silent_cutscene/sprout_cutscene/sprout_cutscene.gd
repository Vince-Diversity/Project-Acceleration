class_name SproutCutscene extends SilentCutscene
## A cutscene of the player interacting with a flower, making it bloom.

## Creates all acts for this cutscene.
func start_cutscene():
	next_state = "roam_state"
	actm.add_act(make_animate_player(Names.focus_anim))
	actm.add_act(make_animate(get_thing_anim_sprite(), Names.sprout_anim))
	actm.add_act(make_animate(get_thing_anim_sprite(), Names.sprouting_anim))
	actm.add_act(make_animate_player("default"))
	get_thing().change_states("thing_static_state")
