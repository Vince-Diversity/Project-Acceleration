class_name Utils extends Object

enum AnimID {DOWN, LEFT, UP, RIGHT}

const dlg_dir = "res://resources/dialogue/"
const room_dir = "res://game/room/rooms/"
const profile_dir = "res://assets/profiles/"
const bgm_dir = "res://assets/sound/bgm/"
const npc_dir = "res://game/character/npcs/"
const entrance_event_dir = "res://resources/events/entrance_events/"

const anim_direction = {
	Vector2.DOWN: AnimID.DOWN,
	Vector2.LEFT: AnimID.LEFT, 
	Vector2.UP: AnimID.UP,
	Vector2.RIGHT: AnimID.RIGHT,
}

const anim_name = {
	AnimID.DOWN: "down",
	AnimID.LEFT: "left",
	AnimID.UP: "up",
	AnimID.RIGHT: "right",
}


static func get_anim_direction(id: AnimID) -> Variant:
	return anim_direction.find_key(id)


static func get_anim_id(name: String) -> Variant:
	return anim_name.find_key(name)


static func get_npc_id(npc_name: String) -> String:
	return npc_name.to_snake_case()


static func get_npc_name(npc_id: String) -> String:
	return npc_id.to_pascal_case()


static func connect_neighbouring_elems(arr: Array):
	if arr.size() > 1:
		arr[0].focus_neighbour_bottom = arr[1].get_path()
		arr[-1].focus_neighbour_top = arr[-2].get_path()
		if arr.size() > 2:
			for i in range(1, arr.size()-2):
				arr[i].focus_neighbour_top = arr[i-1].get_path()
				arr[i].focus_neighbour_bottom = arr[i+1].get_path()


static func get_res_filename(res: Resource) -> String:
	return res.get_path().get_file().trim_suffix("." + res.get_path().get_extension())


static func get_dlg_path(dlg_id: String) -> String:
	return Utils.dlg_dir.path_join(dlg_id + ".dialogue")


static func get_room_path(room_name: String) -> String:
	return Utils.room_dir + room_name + ".tscn"


static func get_res_arr(res_dir_path: String) -> Array:
	var res_dir = DirAccess.open(res_dir_path)
	var name_arr = Array(res_dir.get_files())
	for name in name_arr:
		if name.ends_with(".import"):
			name_arr.erase(name)
	return name_arr


static func get_profile_path(dlg_line: DialogueLine, expression: String) -> String:
	var name = dlg_line.character_replacements[0].expression[0].value
	var profile_id
	if expression.is_empty():
		profile_id = name
	else:
		profile_id = "%s_%s" % [name, expression]
	return profile_dir.path_join(name).path_join(profile_id + ".png")


static func get_bgm_path(bgm_name: String):
	return bgm_dir.path_join(bgm_name + ".ogg")


static func get_npc_path(npc_name: String):
	return npc_dir.path_join(npc_name + ".tscn")


static func get_entrance_event_path(room_id: String):
	return entrance_event_dir.path_join(room_id + ".tres")


static func str_to_seed(name: String) -> int:
	return hash(name)


static func snap_to_compass(direction: Vector2) -> Vector2:
	if direction == Vector2.ZERO: return direction
	if direction in anim_direction.keys(): return direction
	var snapped_angle = snapped(direction.angle(), PI / 2)
	var snapped_vector = Vector2.RIGHT.rotated(snapped_angle)
	if is_equal_approx(snapped_vector.x, 0): snapped_vector.x = 0
	if is_equal_approx(snapped_vector.y, 0): snapped_vector.y = 0
	return snapped_vector


static func get_files_in_dir(dir_path) -> Array[String]:
	var file_arr: Array[String] = []
	var dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				file_arr.append(file_name.split('.')[0])
			file_name = dir.get_next()
	return file_arr


# Makes a boolean array containing true elements
static func ones(list: Array) -> Array[bool]:
	var arr: Array[bool] = []
	for el in list:
		arr.append(true)
	return arr


# Checks if boolean array only contains false
static func any(list: Array[bool]) -> bool:
	for el in list:
		if el == true:
			return true
	return false
