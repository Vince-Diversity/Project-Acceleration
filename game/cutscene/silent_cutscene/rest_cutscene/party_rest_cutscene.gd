extends RestCutscene
## A cutscene where the player and other party members
## rest on something like a set of chairs.

## Creates this cutscene for the current target thing.
func make():
	var player_mark = get_thing_player_rest_mark()
	var member_mark = get_thing_member_rest_mark()
	var rest_anim = get_thing_rest_animation()
	super()
	if owner.party.has_node(member_name):
		if is_instance_valid(player_mark) and is_instance_valid(member_mark):
			add_async([
				[make_move, [
					[owner.party.player],
					[player_mark]]],
				[make_animate_player, [rest_anim]]])
			add_async([
				[make_move, [
					[owner.party.get_node(member_name)],
					[member_mark]]],
				[make_animate, [
					owner.party.get_node(member_name).anim_sprite,
					rest_anim]]])
			actm.add_act(make_async())
	else:
		if is_instance_valid(player_mark):
			actm.add_act(
				make_move(
					[owner.party.player],
					[player_mark]))
			actm.add_act(make_animate_player(rest_anim))
