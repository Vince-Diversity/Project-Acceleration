class_name EntranceEvent extends Resource
## Specifies event data for an event that plays immediately when entering a new [Room] instance.
##
## The ID of this event is the [member Room.room_id] where the event plays.
## It is sufficient to let the filename of this resource to be that ID.

## Toggles this event on or off.
@export var is_enabled: bool = true

## Node name of the desired [Cutscene]. Optionally, a default cutscene is used if this field remains empty.
@export var interaction_node: String = ""

## Filename of the [DialogueResource] containing the desired dialogue.
@export var dialogue_id: String = ""

## Title of the desired dialogue, see [method DialogueResource.get_next_dialogue_line].
@export var dialogue_node: String = ""

## Disables the event after it is played out once.
@export var is_oneshot: bool = true
