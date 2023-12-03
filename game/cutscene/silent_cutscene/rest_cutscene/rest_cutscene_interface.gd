class_name RestCutscene extends SilentCutscene

@export var stand_up_node_name: String = "StandUpCutscene"
@export var member_name: String = "Blue"
@onready var stand_up_cutscene_scn = preload("res://game/cutscene/silent_cutscene/rest_cutscene/stand_up_cutscene.tscn")


func make():
	if get_thing().elevate_characters:
		owner.party.set_z_index(Utils.Elevation.FRONT)
	set_thing_state(
		get_thing().name,
		"thing_permeable_state")
	_make_rest_state()


func end_cutscene():
	super()
	cutscene_ended.emit("rest_state")


func get_thing_rest_animation() -> String:
	return cutscenes.current_source_node.rest_animation


func get_thing_player_rest_mark() -> CharacterMark:
	return cutscenes.current_source_node.get_node("MentorRestMark")


func get_thing_member_rest_mark() -> CharacterMark:
	return cutscenes.current_source_node.get_node("StudentRestMark")


func _make_rest_state():
	if not owner.cutscenes.has_node(stand_up_node_name):
		var stand_up_cutscene = stand_up_cutscene_scn.instantiate()
		owner.add_cutscene(stand_up_cutscene, stand_up_node_name)
	owner.rest_state.make_state(
		stand_up_node_name,
		get_thing())
