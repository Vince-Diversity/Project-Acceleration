extends SilentCutscene


func make():
	make_animate_act(get_player_anim_sprite(), Names.focus_anim)
	make_animate_act(get_thing_anim_sprite(), Names.sprout_anim)
	make_animate_act(get_thing_anim_sprite(), Names.sprouting_anim)
	make_animate_act(get_player_anim_sprite(), "default")


func get_player_anim_sprite() -> AnimatedSprite2D:
	return owner.party.player.anim


func get_thing_anim_sprite() -> AnimatedSprite2D:
	return owner.things.get_node(owner.cutscenes.current_source_node).anim_sprite
