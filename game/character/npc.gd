class_name NPC extends Character
## Base scene for non-playable characters in the environment.
##
## An NPC is a character with whom the player can interact with
## when the current [NPCState] is an [NPCStillState] instance.
## NPCs can also be party of the current [Party] and instead follow
## where the player goes, when the state is an [NPCJoinedState] instance instead.
## [br]
## [br]
## When an NPC is a party member, it is possible that they leave the party
## in a different [Room]. The new room is tagged to this NPC by [member idling_room_id]
## to allow the NPC to be in one room only within the game world.
## [br]
## [br]
## Some NPCs can not enter the certain spawn points, called gateways,
## where [Door.is_gateway] is set to true. These NPCs are called "imaginary"
## and have the [member is_imaginary] property set to true.
## Hence, for an imaginary NPC, the game world is divided into categories.
## When the player attempts to enter a gateway with an imaginary NPC as party member,
## the NPC either waits at the gateway or returns to its spawn point.
## To enable this behaviour, the [member is_waiting_at_gateway] is set to true.

## Node name of the desired [Cutscene]. Optionally, a default cutscene is used if this field remains empty.
@export var interaction_node: String

## Filename of the [DialogueResource] containing the desired dialogue.
@export var dialogue_id: String

## Title of the desired dialogue, see [method DialogueResource.get_next_dialogue_line].
@export var dialogue_node: String

## The NPC's direction after the last [CutsceneState] ended.
@export var preserved_direction: Utils.AnimID

## The NPC's animation after the last [CutsceneState] ended.
@export var preserved_animation: String = "default"

## Toggles whether the NPC is imaginary and can hence not enter the overworld of the game.
@export var is_imaginary: bool = false

## Defaull [NPCState] when this NPC is added to the [SceneTree].
@export_enum(
	"npc_still_state",
	"npc_joined_state",
	"npc_waiting_state") var spawn_state: String = "npc_still_state"

## The filename of this node, without the extension.
## If this string is empty, the NPC node name (converted to snake case) will be used,
## so edit this when the NPC node name needs to be different.
@export var filename: String = ""

@onready var _still_state: NPCStillState = \
	preload("res://game/character/npc_state/npc_still_state.gd").new("npc_still_state", self)

@onready var _joined_state: NPCJoinedState = \
	preload("res://game/character/npc_state/npc_joined_state.gd").new("npc_joined_state", self)

@onready var _waiting_state: NPCWaitingState = \
	preload("res://game/character/npc_state/npc_waiting_state.gd").new("npc_waiting_state", self)

## Reference to the interaction area of this NPC.
@onready var interact_area: Interactable = $InteractArea

## Position of this NPC after the last [CutsceneState] ended.
var preserved_position: Vector2

## [enum Utils.Elevation] numbering of this NPC after the last [CutsceneState] ended.
var preserved_z_index : int

## [member Room.room_id] tag determining where this NPC resides
## last [CutsceneState] ended.
var preserved_idling_room_id: String

## List of [NPCState] instances labeled by each respective [member NPCState.state_id].
var state_list: Dictionary

## Current activated NPC state instance.
var current_state: NPCState

## Reference to the room instance.
var room: Room

## Toggles when this NPC is moving towards the next party member, see [Party].
var is_following: bool = false

## [member Room.room_id] tag determining where this NPC resides,
## if the NPC has been moved away from its default spawn room.
var idling_room_id: String

## Tag given to imaginary NPCs who wait at the entrance point to the overworld.
var is_waiting_at_gateway: bool = false


func _ready():
	if filename.is_empty(): filename = Utils.get_npc_id(name)
	state_list[_still_state.state_id] = _still_state
	state_list[_joined_state.state_id] = _joined_state
	state_list[_waiting_state.state_id] = _waiting_state
	current_state = state_list[spawn_state]
	current_state.enter()


## Initialises this scene after it is added to the [SceneTree].
func make_npc(
		given_npc_state: String,
		given_room: Room,
		custom_name: String = ""):
	if not custom_name.is_empty(): name = custom_name
	room = given_room
	change_states(given_npc_state)
	items.make_items(self)


## Changes the [member current_state] to the given [code]npc_state_id[/code].
func change_states(npc_state_id: String):
	current_state.exit()
	current_state = state_list[npc_state_id]
	current_state.enter()


## Updates this NPC's movement at every frame.
func roam():
	current_state.roam()


## Checks if the NPC has reached the next character's [member Character.following_area]
## and stops this NPC's following movement if so.
func _on_FollowingArea_area_entered(area: Area2D):
	if area == room.party.get_next_member(self).following_area:
		is_following = false


## Checks if the NPC has left the next character's [member Character.following_area]
## and starts this NPC's following movement if so.
func _on_FollowingArea_area_exited(area: Area2D):
	if area == room.party.get_next_member(self).following_area:
		is_following = true


## Saves this NPC to the given [code]sg[/code].
func make_save(sg: SaveGame):
	current_state.make_save(sg)


## Saves this NPC at a previous point in the game session to the given [code]sg[/code].
func make_preserved_save(sg: SaveGame):
	current_state.make_preserved_save(sg)


## Loads this NPC from the given [code]sg[/code].
func load_save(sg: SaveGame):
	current_state.load_save(sg)


## Called when a [CutsceneState] ends.
func exit_cutscene():
	preserved_position = global_position
	preserved_z_index = z_index
	preserved_idling_room_id = idling_room_id
