extends Node

const dev_mode_save_dir := "res://dev/save/"
const game_save_dir := "user://save/"
const game_path := "res://game/game.tscn"
const main_menu_path := "res://main_menu/main_menu.tscn"
var save_dir = dev_mode_save_dir
var save_filename = "cirruseng_v%s.tres" % ProjectSettings.get_setting("application/config/version")
var save_path = save_dir.plus_file(save_filename)

func new_game():
	States.reset_states()
	
	States.current_room = Names.room_names[Names.Rooms.CAT_LAB]
	States.blue_joined = true
	
	var err = get_tree().change_scene(game_path)
	if err != OK: push_error(err)

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
