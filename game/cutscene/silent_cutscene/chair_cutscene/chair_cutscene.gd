extends SilentCutscene

@onready var stand_up_cutscene_scn = preload("res://game/cutscene/silent_cutscene/chair_cutscene/stand_up_cutscene.tscn")
var stand_up_node_name = "StandUpCutscene"


func make():
	set_thing_state(
		get_thing().name,
		"thing_permeable_state")
	actm.add_act(
		make_move(
			[owner.party.player],
			[get_thing_character_mark()]))
	actm.add_act(make_animate_player("sit_down"))
	_make_rest_state()


func end_cutscene():
	super()
	cutscene_ended.emit("rest_state")


func get_thing_character_mark() -> CharacterMark:
	return cutscenes.current_source_node.character_mark


func _make_rest_state():
	if not owner.cutscenes.has_node(stand_up_node_name):
		var stand_up_cutscene = stand_up_cutscene_scn.instantiate()
		owner.add_cutscene(stand_up_cutscene, stand_up_node_name)
	owner.rest_state.make_state(
		stand_up_node_name,
		get_thing())
