class_name Loader extends Node

## Change this mode when releasing
var save_dir: String = dev_mode_save_dir

## New game spawn point used during dev
var new_game_room_id: String = "main_entrance"
var new_game_entrance_node: String = "DoorDown"

const dev_mode_save_dir := "res://dev/save/"
const game_save_dir := "user://save/"
const main_menu_path := "res://loader/main_menu/main_menu.tscn"
const game_path := "res://game/game.tscn"
@onready var main_menu_scn: PackedScene = preload(main_menu_path)
@onready var game_scn: PackedScene = preload(game_path)
@onready var screen_scn: PackedScene = preload("res://loader/screen.tscn")
var save_filename: String = "cirruseng_v%s.tres" % ProjectSettings.get_setting("application/config/version")
var save_path: String = save_dir.path_join(save_filename)
var game: Game
var main_menu: MainMenu
var screen: Screen


func _ready():
	_ready_screen()
	_ready_main_menu()


func _ready_screen():
	screen = screen_scn.instantiate()
	get_tree().get_root().call_deferred("add_child", screen)


func _ready_main_menu():
	main_menu = main_menu_scn.instantiate()
	main_menu.init_main_menu(self)
	_add_child_to_root_deferred(main_menu)


func new_game():
	var room_path = Utils.get_room_path(new_game_room_id)
	if FileAccess.file_exists(room_path):
		var save_game = SaveGame.new()
		save_game.game_version = ProjectSettings.get_setting("application/config/version")
		_change_to_game(save_game)
		game.load_room(new_game_room_id, new_game_entrance_node)


func enter_game():
	var save_game: Resource = load(save_path)
	_change_to_game(save_game)
	game.load_room(game.cache.data["game"]["current_room_id"], game.cache.data["game"]["entrance_node"])
	game.load_preserved(game.cache)


func enter_main_menu():
	game.queue_free()
	main_menu = main_menu_scn.instantiate()
	main_menu.init_main_menu(self)
	_add_child_to_root(main_menu)


func _change_to_game(save_game: SaveGame):
	main_menu.queue_free()
	game = game_scn.instantiate()
	game.init_game(self, save_dir, save_game)
	_add_child_to_root(game)


func _add_child_to_root(node: Node):
	get_tree().get_root().add_child(node)


func _add_child_to_root_deferred(node: Node):
	get_tree().get_root().call_deferred("add_child", node)
