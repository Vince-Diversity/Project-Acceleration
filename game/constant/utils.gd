class_name Utils extends Object

enum InputType {RESPONSE, ACTION, REACTIVATION}
enum AnimID {DOWN, LEFT, UP, RIGHT}

const dlg_dir = "res://resources/dialogue/"
const room_dir = "res://game/room/"

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


static func snap_to_compass(direction: Vector2) -> Vector2:
	if direction == Vector2.ZERO: return direction
	if direction in anim_direction.keys(): return direction
	var snapped_angle = snapped(direction.angle(), PI / 2)
	var snapped_vector = Vector2.RIGHT.rotated(snapped_angle)
	if is_equal_approx(snapped_vector.x, 0): snapped_vector.x = 0
	if is_equal_approx(snapped_vector.y, 0): snapped_vector.y = 0
	return snapped_vector


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
