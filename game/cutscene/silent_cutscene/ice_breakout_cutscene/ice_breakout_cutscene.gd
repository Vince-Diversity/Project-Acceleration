extends SilentCutscene
## A cutscene of the player breaking free from ice shards.
##
## Assumes that the player is in the [PlayerSkatingState].

## Ice shards [Thing] node that the player is stuck in.
@export var ice_shards_node: Thing

func start_cutscene():
	next_state = "roam_state"
	var break_free_mark = cutscenes.current_source_node.get_node("MentorBreakFreeMark")
	if is_instance_valid(break_free_mark):
		owner.party.player.change_states("player_skating_leaping_state")
		actm.add_act(
			make_animate(
				owner.party.player.anim_sprite,
				"leap")
		)
		actm.add_act(
			make_move(
				[owner.party.player],
				[break_free_mark]))
		actm.add_act(make_animate_player("default"))

func end_cutscene():
	super()
	set_thing_state(
		ice_shards_node.name,
		"thing_interactable_state")
	owner.party.player.change_states("player_skating_state")
