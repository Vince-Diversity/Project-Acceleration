class_name RestCutscene extends SilentCutscene
## Base class for cutscenes where players and other party members rest on
## [Thing] instances like chairs and beds. Enters the [RestState].

## Node name of this cutscene.
@export var stand_up_node_name: String = "StandUpCutscene"

## Node name of the party member also involved in the cutscene.
## Currently, just one member is needed.
@export var member_name: String = "Blue"

@onready var _stand_up_cutscene_scn = preload("res://game/cutscene/silent_cutscene/rest_cutscene/stand_up_cutscene.tscn")

## Creates acts and configures the involved characters and things to allow for the cutscene to play out.
func start_cutscene():
	next_state = "rest_state"
	if get_thing().elevate_characters:
		owner.party.set_z_index(Utils.Elevation.FRONT)
	set_thing_state(
		get_thing().name,
		"thing_permeable_state")
	_make_rest_state()


func _make_rest_state():
	owner.add_cutscene(_stand_up_cutscene_scn.instantiate(), stand_up_node_name)
	owner.rest_state.make_state(
		stand_up_node_name,
		get_thing())


## Gets the resting animation name which a character has when resting.
func get_thing_rest_animation() -> String:
	return cutscenes.current_source_node.rest_animation


## Gets the marker where the player moves to rest.
func get_thing_player_rest_mark() -> CharacterMark:
	return cutscenes.current_source_node.get_node("MentorRestMark")


## Gets the marker where a party member moves to rest.
func get_thing_member_rest_mark() -> CharacterMark:
	return cutscenes.current_source_node.get_node("StudentRestMark")
