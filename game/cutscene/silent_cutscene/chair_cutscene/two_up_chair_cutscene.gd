extends SilentCutscene

@onready var stand_up_cutscene_scn = preload("res://game/cutscene/silent_cutscene/chair_cutscene/two_stand_up_cutscene.tscn")
var stand_up_node_name = "TwoStandUpCutscene"
var npc_node = "Blue"


func make():
	set_thing_state(
		get_thing().name,
		"thing_permeable_state")
	if owner.party.has_node(npc_node):
		add_async([
			[make_move, [
				[owner.party.player],
				[cutscenes.current_source_node.get_node("MentorChairMark")]]],
			[make_animate_player, ["sit_down"]]])
		add_async([
			[make_move, [
				[owner.party.get_node(npc_node)],
				[cutscenes.current_source_node.get_node("StudentChairMark")]]],
			[make_animate, [
				owner.party.get_node(npc_node).anim_sprite,
				"sit_down"]]])
		actm.add_act(make_async())
	else:
		actm.add_act(
			make_move(
				[owner.party.player],
				[cutscenes.current_source_node.get_node("MentorChairMark")]))
		actm.add_act(make_animate_player("sit_down"))
	_make_rest_state()


func end_cutscene():
	super()
	cutscene_ended.emit("rest_state")


func _make_rest_state():
	if not owner.cutscenes.has_node(stand_up_node_name):
		var stand_up_cutscene = stand_up_cutscene_scn.instantiate()
		owner.add_cutscene(stand_up_cutscene, stand_up_node_name)
	owner.rest_state.make_state(
		stand_up_node_name,
		get_thing())
