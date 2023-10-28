extends Node2D

# Dictionary mapping event id to event resource
var events: Dictionary


func _ready():
	_ready_entrance_events()


func _ready_entrance_events():
	for room_id in Utils.get_files_in_dir(Utils.entrance_event_dir):
		var event_path = Utils.get_entrance_event_path(room_id)
		var event_res = load(event_path)
		events[room_id] = event_res


func update_event(room_id: String):
	if events.has(room_id):
		if events[room_id].is_oneshot:
			remove_event(room_id)


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
