class_name EntranceEvents extends Node2D
## Lists cutscene events that play immediately when entering a new [Room] instance.
##
## The [member events] maps every room that has an entrance event to an [EntranceEvent] custom resource.
## By default, when this node is added to the [SceneTree],
## the contents of all entrance event resources in the filesystem
## are copied to nested dictionaries in [member events],
## where the nested keys are given in the constants section.
## The events are then updated to the current save cache or save file.

const enabled_key = "is_enabled"
const interaction_key = "interaction_node"
const dialogue_id_key = "dialogue_id"
const dialogue_node_key = "dialogue_node"
const oneshot_key = "is_oneshot"

## Dictionary mapping event IDs to [EntranceEvent] instances.
## The event ID is the [member Room.room_id] where the event happens.
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

## Disables the entrance event of the [Room] with the given [code]room_id[/code]
## if it is intended to play just once.
func update_event(room_id: String):
	if events.has(room_id):
		if events[room_id].is_oneshot:
			events[room_id][enabled_key] = false


## Removes the entrance event of the [Room] with the given [code]room_id[/code].
func remove_event(room_id: String):
	if events.has(room_id):
		events.erase(room_id)


## Saves the entrance events to the given [code]sg[/code].
func make_save(sg: SaveGame):
	sg.data[sg.game_key][sg.entrance_event_key] = events


## Same as [method make_save].
func make_preserved_save(sg: SaveGame):
	make_save(sg)


## Loads entrance events from the given [code]sg[/code].
func load_save(sg: SaveGame):
	if sg.data[sg.game_key].has(sg.entrance_event_key):
		events = sg.data[sg.game_key][sg.entrance_event_key]


## Toggles the entrance event of the given [code]room_id[/code]
## according to [code]is_enabled[/code], if the given [code]room_id[/code] exists.
func _on_entrance_event_edited(room_id: String, is_enabled: bool):
	if events.has(room_id):
		events[room_id]["is_enabled"] = is_enabled
