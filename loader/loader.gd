class_name Loader extends Node

## Change this mode when releasing
var save_dir: String = dev_mode_save_dir

const dev_mode_save_dir := "res://dev/save/"
const game_save_dir := "user://save/"
const main_menu_path := "res://loader/main_menu/main_menu.tscn"
const game_path := "res://game/game.tscn"
@onready var main_menu_scn: PackedScene = preload(main_menu_path)
@onready var game_scn: PackedScene = preload(game_path)
var save_filename: String = "cirruseng_v%s.tres" % ProjectSettings.get_setting("application/config/version")
var save_path: String = save_dir.path_join(save_filename)
var game: Game
var main_menu: MainMenu


func _ready():
	main_menu = main_menu_scn.instantiate()
	main_menu.init_main_menu(self)
	_add_child_to_root_deferred(main_menu)


## Change this function for making a new game default
func _ready_new_game():
	main_menu.queue_free()
	game.load_room("main_entrance", "DoorDown")


func new_game():
#	States.reset_states()
	game = game_scn.instantiate()
	game.init_game(self, save_dir)
	_add_child_to_root(game)
	_ready_new_game()


func enter_game():
	main_menu.queue_free()
	var save_game: Resource = load(save_path)
	_load_game_state(save_game)
	game = game_scn.instantiate()
	game.init_game(self, save_dir)
	_add_child_to_root(game)
	game.load_room("", "")


func enter_main_menu():
	game.queue_free()
	main_menu = main_menu_scn.instantiate()
	main_menu.init_main_menu(self)
	_add_child_to_root(main_menu)


func _add_child_to_root(node: Node):
	get_tree().get_root().add_child(node)


func _add_child_to_root_deferred(node: Node):
	get_tree().get_root().call_deferred("add_child", node)


func _load_game_state(save_game: Resource):
	for key in save_game.data:
		pass
#		States.set(key, save_game.data[key])
