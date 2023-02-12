extends Node

const dev_mode_save_dir := "res://dev/save/"
const game_save_dir := "user://save/"
const game_path := "res://game/game.tscn"
const main_menu_path := "res://main_menu/main_menu.tscn"

## Change this mode when releasing
var save_dir = dev_mode_save_dir

var save_filename = "cirruseng_v%s.tres" % ProjectSettings.get_setting("application/config/version")
var save_path = save_dir.plus_file(save_filename)
var game

## Change this function for making a new game default
func _ready_new_game():
	States.current_room = "room"
	game.load_room(States.current_room)
	game.room_node.party.add_player("res://game/character/player.tscn")
	game.room_node.party.add_member("res://game/character/ally.tscn")

func new_game():
	States.reset_states()
	game = load(game_path).instance()
	get_tree().get_root().add_child(game)
	yield(get_tree(), "idle_frame")
	_ready_new_game()

func enter_game():
	var save_game: Resource = load(save_path)
	load_game_state(save_game)
	var err = get_tree().change_scene(game_path)
	if err != OK: push_error(err)

func enter_main_menu():
	var err = get_tree().change_scene(main_menu_path)
	if err != OK: push_error(err)

func load_game_state(save_game: Resource):
	for key in save_game.data:
		States.set(key, save_game.data[key])
