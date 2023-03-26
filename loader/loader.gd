class_name Loader extends Node

const dev_mode_save_dir := "res://dev/save/"
const game_save_dir := "user://save/"
const game_path := "res://game/game.tscn"
const main_menu_path := "res://main_menu/main_menu.tscn"

## Change this mode when releasing
var save_dir: String = dev_mode_save_dir

var save_filename: String = "cirruseng_v%s.tres" % ProjectSettings.get_setting("application/config/version")
var save_path: String = save_dir.path_join(save_filename)
var game
var main_menu


func _ready():
	main_menu = load(main_menu_path).instantiate()
	main_menu.loader = self
	get_tree().get_root().call_deferred("add_child", main_menu)


## Change this function for making a new game default
func _ready_new_game():
	States.current_room = "room"
	main_menu.queue_free()
	game.load_room(States.current_room)
	game.room_node.party.add_player("res://game/character/player.tscn")
	game.room_node.party.add_member("res://game/character/ally.tscn")
	game.loader = self
	game.save_dir = save_dir


func _add_child_to_root(node_path: String):
	game = load(node_path).instantiate()
	get_tree().get_root().add_child(game)


func new_game():
	States.reset_states()
	_add_child_to_root(game_path)
	_ready_new_game()


# ToDo
func enter_game():
	var save_game: Resource = load(save_path)
	load_game_state(save_game)
	_add_child_to_root(game_path)


func enter_main_menu():
	var err = get_tree().change_scene_to_file(main_menu_path)
	if err != OK: push_error(err)


func load_game_state(save_game: Resource):
	for key in save_game.data:
		States.set(key, save_game.data[key])

