extends SilentCutscene
## A cutscene of the player breaking free from ice shards.

func start_cutscene():
	next_state = "roam_state"
	var break_free_mark = cutscenes.current_source_node.get_node("MentorBreakFreeMark")
	if is_instance_valid(break_free_mark):
		actm.add_act(
			make_move(
				[owner.party.player],
				[break_free_mark]))
		actm.add_act(make_animate_player("default"))
