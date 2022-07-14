extends Resource

static func make(room, room_name: String) -> void:
	var dlg_path = Utils.dlg_dir + room_name + ".tres"
	room.dlg_res = load(dlg_path)
