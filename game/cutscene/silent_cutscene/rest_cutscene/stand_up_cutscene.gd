class_name StandUpCutscene extends SilentCutscene
## A cutscene where the player gets out of a [RestState].
##
## This cutscene does not need to be added to the [Room] since
## it created automatically by the [RestState].

## Creates an act list where the player moves away from a thing
## which they were resting on.
## Other party members will later follow naturally once [RoamState] is ended.
func start_cutscene():
	var stand_up_mark = get_thing_stand_up_mark()
	if is_instance_valid(stand_up_mark):
		actm.add_act(
			make_move(
				[owner.party.player],
				[stand_up_mark]))
		actm.add_act(make_animate_player("default"))


## Finishes this cutscene, resetting any changes done to characters and things
## when the [RestCutscene] started
## and changes the current game session state to [RoamState].
func end_cutscene():
	super()
	owner.party.set_z_index(Utils.Elevation.FLOOR)
	set_thing_state(
		get_thing().name,
		"thing_interactable_state")
	cutscene_ended.emit("roam_state")


## Gets the marker where the player goes to move away from the thing they were resting on.
func get_thing_stand_up_mark() -> CharacterMark:
	return cutscenes.current_source_node.get_node("MentorStandUpMark")
