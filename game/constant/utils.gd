class_name Utils extends Object
## Static class with generally useful properties and methods.

## Character direction enumeration.
enum AnimID {DOWN, LEFT, UP, RIGHT}

## Menu direction enimeration
enum Direction {LEFT, RIGHT}

## Z-indices of [Room] child scenes enumeration.
## The numbering is the Z-index.
enum Elevation {
	FLOOR, ## The general environment.
	FRONT, ## In front of the general environment.
	UI, ## In front of any characters or things in the environment.
}

const dlg_dir = "res://resources/dialogue/"
const room_dir = "res://game/room/rooms/"
const profile_dir = "res://assets/profiles/"
const font_dir = "res://assets/fonts/"
const bgm_dir = "res://assets/sound/bgm/"
const npc_dir = "res://game/character/npcs/"
const entrance_event_dir = "res://resources/events/entrance_events/"
const item_dir = "res://game/item/items/"
const item_sprite_dir = "res://resources/items/item_sprites"
const character_sprite_dir = "res://resources/characters/"

## Maps a direction [Vector2] to an [enum AnimID] numbering.
const anim_direction = {
	Vector2.DOWN: AnimID.DOWN,
	Vector2.LEFT: AnimID.LEFT, 
	Vector2.UP: AnimID.UP,
	Vector2.RIGHT: AnimID.RIGHT,
}

## Maps an [enum AnimID] numbering to the [member AnimatedSprite2D.animation]
## name corresponding to movement of that animation numbering.
const anim_name = {
	AnimID.DOWN: "down",
	AnimID.LEFT: "left",
	AnimID.UP: "up",
	AnimID.RIGHT: "right",
}


## Reverse accessing of [constant anim_direction].
static func get_anim_direction(id: AnimID) -> Variant:
	return anim_direction.find_key(id)


## Reverse accessing of [constant anim_name].
static func get_anim_id(name: String) -> Variant:
	return anim_name.find_key(name)


## Converts the given node name [code]npc_name[/code]
## to the corresponding [NPC] filename.
static func get_npc_id(npc_name: String) -> String:
	return npc_name.to_snake_case()


## Reverse converter of [member get_npc_id].
static func get_npc_name(npc_id: String) -> String:
	return npc_id.to_pascal_case()


## Converts the given node name [code]item_name[/code]
## to the corresponding [ItemSprite] filename.
static func get_item_id(item_name: String) -> String:
	return item_name.to_snake_case()


## Gets the path of the [DialogueResource] with the given [dlg_id].
static func get_dlg_path(dlg_id: String) -> String:
	return Utils.dlg_dir.path_join(dlg_id + ".dialogue")


## Gets the path of the [Room] with the given [code]room_id[/code].
static func get_room_path(room_id: String) -> String:
	return Utils.room_dir + room_id + ".tscn"


## Gets an array of all resources in a given directory path [code]res_dir_path[/code].
static func get_res_arr(res_dir_path: String) -> Array:
	var res_dir = DirAccess.open(res_dir_path)
	var name_arr = Array(res_dir.get_files())
	for name in name_arr:
		if name.ends_with(".import") or name.ends_with(".gd"):
			name_arr.erase(name)
	return name_arr


## Calls a [code]boolean[/code] value function [code]res_condition[/code]
## on all resources at the given directory path [code]res_dir_path[/code].
## The given function takes one [Resource] argument.
## Useful for checking for existence of certain properties within a set of custom resources.
static func has_res(res_dir_path: String, res_condition: Callable) -> bool:
	for res_file in get_res_arr(res_dir_path):
		if res_condition.call(load(res_dir_path.path_join(res_file))):
			return true
	return false


## Gets the path to the background music [code].ogg[/code] asset
## with the given [code]bgm_name[/code] filename.
static func get_bgm_path(bgm_name: String) -> String:
	return bgm_dir.path_join(bgm_name + ".ogg")


## Gets the path to the [NPC] with the given [code]npc_id[/code].
static func get_npc_path(npc_id: String) -> String:
	return npc_dir.path_join(npc_id + ".tscn")


## Gets the path to the [SpriteFrames] with the given [code]character_id[/code].
static func get_character_sprite_path(character_id: String) -> String:
	return character_sprite_dir.path_join(character_id + ".tres")


## Gets the path to the [EntranceEvent] which is used for the [Room]
## with the given [code]room_id[/code].
static func get_entrance_event_path(room_id: String) -> String:
	return entrance_event_dir.path_join(room_id + ".tres")


## Gets the [Item] with the given [code]item_id[/code].
static func get_item_path(item_id: String) -> String:
	return item_dir.path_join(item_id + ".tscn")


## Gets the [ItemSprite] with the given [code]item_id[/code].
static func get_item_sprite_path(item_id: String) -> String:
	return item_sprite_dir.path_join(item_id + ".tres")


## Generates a seed from the given [code]string[/code].
static func str_to_seed(string: String) -> int:
	return hash(string)


## Converts the given [code]direction[/code] to a cardinal direction.
static func snap_to_compass(direction: Vector2) -> Vector2:
	if direction == Vector2.ZERO: return direction
	if direction in anim_direction.keys(): return direction
	var snapped_angle = snapped(direction.angle(), PI / 2)
	var snapped_vector = Vector2.RIGHT.rotated(snapped_angle)
	if is_equal_approx(snapped_vector.x, 0): snapped_vector.x = 0
	if is_equal_approx(snapped_vector.y, 0): snapped_vector.y = 0
	return snapped_vector


## Connects the [code]target[/code] to the [code]source_signal[/code]
## if the connection does not yet exist.
static func try_connect(source_signal, target):
	if not source_signal.is_connected(target):
		source_signal.connect(target)


## Disconnects the [code]target[/code] from the [code]source_signal[/code]
## if the connection exists.
static func try_disconnect(source_signal, target):
	if source_signal.is_connected(target):
		source_signal.disconnect(target)


## Gets an array of all filenames, without extensions,
## of the given directory path [code]dir_path[/code].
## Skips nested directories.
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


## Makes a boolean list containing true elements with the same size as [code]list[/code].
static func ones(list: Array) -> Array[bool]:
	var arr: Array[bool] = []
	for el in list:
		arr.append(true)
	return arr


## Checks if the given boolean [code]list[/code] contains any true element.
static func any(list: Array[bool]) -> bool:
	for el in list:
		if el == true:
			return true
	return false


## Converts polar coordinates to cartesian coordinates
## where [code]r[/code] is the radius and [code]a[/code] the angle.
static func ra2xy(r: float, a: float) -> Vector2:
	return Vector2(r*cos(a), r*sin(a))
