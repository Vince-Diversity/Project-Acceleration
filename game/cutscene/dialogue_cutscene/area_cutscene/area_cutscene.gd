class_name AreaCutscene extends DialogueCutscene
# Base class for custom dialogue cutscenes that activates when entering or leaving certain subareas within the same world.
# The idea is that the cutscene only plays the first time that area is entered or left.
# However, for now at least, re-entering the [Room] instance with this cutscene makes it possible to replay this cutscene.
# This is because cutscenes are not saved in the cache or in a save file.

## Filename of the [DialogueResource] containing the desired dialogue.
@export var dialogue_id: String

## Title of the desired dialogue, see [method DialogueResource.get_next_dialogue_line].
@export var dialogue_node: String

@onready var event_area = $EventArea

## Emitted to start a cutscene
signal area_cutscene_started(
	interaction_node: String,
	dialogue_id: String,
	dialogue_node: String)


## Connects the signal that starts this cutscene.
func init_cutscene(given_cutscenes: RoomCutscenes, given_screen: Screen):
	super(given_cutscenes, given_screen)
	area_cutscene_started.connect(cutscenes.owner._on_begin_area_cutscene, CONNECT_ONE_SHOT)


## Checks that the entered body is the player.
func is_body_valid(body: PhysicsBody2D) -> bool:
	return body == cutscenes.owner.party.player
