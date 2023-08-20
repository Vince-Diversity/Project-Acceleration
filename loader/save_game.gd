class_name SaveGame extends Resource

const game_key = "game"
const room_key = "current_room_id"
const entrance_key = "entrance_node"
const party_key = "party_key"

const rooms_key = "rooms"
const things_key = "things"
const npcs_key = "npcs"

const state_key = "current_state"
const anim_key = "current_anim"
const frame_key = "current_frame"
const interaction_key = "interaction_node"
const dialogue_id_key = "dialogue_id"
const dialogue_node_key = "dialogue_node"
const position_key = "position"
const direction_key = "direction"


@export var game_version := ""
@export var data := {
	game_key: {},
	rooms_key: {},
}


func update_room_keys(room_id: String):
	if not data[rooms_key].has(room_id):
		var room_dict = {}
		data[rooms_key][room_id] = room_dict
		room_dict[things_key] = {}
		room_dict[npcs_key] = {}
