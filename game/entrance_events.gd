extends Node2D

const enabled_key = "is_enabled"
const interaction_key = "interaction_node"
const dialogue_id_key = "dialogue_id"
const dialogue_node_key = "dialogue_node"
const oneshot_key = "is_oneshot"

# Dictionary mapping event id to event resource
var events: Dictionary


func _ready():
	_ready_entrance_events()


func _ready_entrance_events():
	for room_id in Utils.get_files_in_dir(Utils.entrance_event_dir):
		var event_path = Utils.get_entrance_event_path(room_id)
		var event_res = load(event_path)
		var event_dict := {}
		events[room_id] = event_dict
		event_dict[enabled_key] = event_res["is_enabled"]
		event_dict[interaction_key] = event_res["interaction_node"]
		event_dict[dialogue_id_key] = event_res["dialogue_id"]
		event_dict[dialogue_node_key] = event_res["dialogue_node"]
		event_dict[oneshot_key] = event_res["is_oneshot"]


func update_event(room_id: String):
	if events.has(room_id):
		if events[room_id].is_oneshot:
			events[room_id][enabled_key] = false


func remove_event(room_id: String):
	if events.has(room_id):
		events.erase(room_id)


func make_save(sg: SaveGame):
	sg.data[sg.game_key][sg.entrance_event_key] = events


func make_preserved_save(sg: SaveGame):
	make_save(sg)


func load_save(sg: SaveGame):
	if sg.data[sg.game_key].has(sg.entrance_event_key):
		events = sg.data[sg.game_key][sg.entrance_event_key]
