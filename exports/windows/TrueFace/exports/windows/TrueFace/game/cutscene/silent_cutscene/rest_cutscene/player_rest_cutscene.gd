extends RestCutscene
## A cutscene where the player rests on something like a chair or bed.

## Creates this cutscene for the current target thing.
func start_cutscene():
	var player_mark = get_thing_player_rest_mark()
	if is_instance_valid(player_mark):
		super()
		actm.add_act(
			make_move(
				[owner.party.player],
				[player_mark]))
		actm.add_act(make_animate_player(get_thing_rest_animation()))
