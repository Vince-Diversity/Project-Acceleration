class_name SaveGame extends Resource
## Stores all save data.
##
## The save format is a [Resource] instance, categorised with dictionaries and arrays.
## The stored data can be built-in types but not nodes or resources.
## All dictionary keys are collected in the constants section.
## The [member game_version] and [member data] properties
## need to be exported variables, so that this resource can be duplicated later
## in [method Game.save], according to [method Resource.duplicate].

const game_key = "game"
const room_key = "current_room_id"
const entrance_key = "entrance_node"
const entrance_event_key = "entrance_event"
const party_key = "party"
const items_key = "items"

const rooms_key = "rooms"
const things_key = "things"
const npcs_key = "npcs"

const condition_key = "conditions"
const mentoring_condition_key = "is_mentoring"

const state_key = "current_state"
const filename_key = "filename"

const anim_key = "current_anim"
const frame_key = "current_frame"
const interaction_key = "interaction_node"
const dialogue_id_key = "dialogue_id"
const dialogue_node_key = "dialogue_node"
const position_key = "position"
const direction_key = "direction"
const was_joined_key = "was_joined"
const idling_room_key = "idling_room"
const z_index_key = "z_index"

const bgm_toggle_key = "bgm_toggle"

const item_list_key = "item_list"
const floating_key = "floating_item"


## Current version of the game.
@export var game_version := ""

## Dictionary with save data.
## It is initalised with all the subcategories of the save data.
@export var data := {
	condition_key: {},
	game_key: {},
	items_key: {},
	party_key: [],
	rooms_key: {},
}


## Initialises a new room entry to the save data.
func update_room_keys(room_id: String):
	if not data[rooms_key].has(room_id):
		var room_dict = {}
		data[rooms_key][room_id] = room_dict
		room_dict[things_key] = {}
		room_dict[npcs_key] = {}
		room_dict[party_key] = {}
