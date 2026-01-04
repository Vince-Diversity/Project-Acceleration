class_name Loader extends Node
## Loads the [MainMenu], [Game] and [Screen] nodes, and creates [SaveGame] resources.
##
## The methods in this class is used to switch between the game and the main menu.
## Methods and properties tagged as [code]@experimental[/code] are
## temporary when developing the game.

## Path to directory with save data.
## Change this to [constant game_save_dir] when releasing.
## @experimental
var save_dir: String = dev_mode_save_dir

## Directory with the save file.
const game_save_dir := "user://save/"

## Temporary directory with save file, for convenience.
const dev_mode_save_dir := "res://dev/save/"

## The first room that is loaded during development.
## @experimental
var new_game_room_id: String = "main_entrance"

## The first entrance during developmemt.
## @experimental
var new_game_entrance_node: String = "PassageDown"

## The first party during development.
## @experimental
var new_game_party_list: Array[String] = ["Blue"]

@onready var _main_menu_scn: PackedScene = preload("res://loader/main_menu/main_menu.tscn")
@onready var _game_scn: PackedScene = preload("res://game/game.tscn")
@onready var _screen_scn: PackedScene = preload("res://loader/screen/screen.tscn")
@onready var _bgm_player_scn: PackedScene = preload("res://loader/sound/bgm_player.tscn")

## Path to the save file.
var save_path: String = save_dir.path_join("cirruseng_v%s.tres" % ProjectSettings.get_setting("application/config/version"))

## Current game session instance.
var game: Game

## Current main menu instance.
var main_menu: MainMenu

## Current transition screen instance.
var screen: Screen

## Current background music player instance.
var bgm_player: BGMPlayer


func _ready():
	_ready_screen()
	_ready_bgm_player()
	_ready_main_menu()


func _ready_screen():
	screen = _screen_scn.instantiate()
	get_tree().get_root().call_deferred("add_child", screen)


func _ready_bgm_player():
	bgm_player = _bgm_player_scn.instantiate()
	get_tree().get_root().call_deferred("add_child", bgm_player)


func _ready_main_menu():
	main_menu = _main_menu_scn.instantiate()
	main_menu.init_main_menu(self)
	_add_child_to_root_deferred(main_menu)


## Starts a new game.
## Adds temporary game data used during development.
## @experimental
func new_game():
	var room_path = Utils.get_room_path(new_game_room_id)
	if FileAccess.file_exists(room_path):
		var sg = SaveGame.new()
		sg.game_version = ProjectSettings.get_setting("application/config/version")
		sg.data[sg.party_key] = new_game_party_list
		sg.data[sg.player_key][sg.player_state_key] = "player_ordinary_state"
		Condition.new_game_init_condition(sg)
		_change_to_game(sg)
		game.add_room(new_game_room_id, new_game_entrance_node)


## Loads an existing save file and starts a game.
func enter_game():
	var sg: Resource = load(save_path)
	_change_to_game(sg)
	game.add_room(
		game.cache.data[sg.game_key][sg.room_key],
		game.cache.data[sg.game_key][sg.entrance_key])
	bgm_player.reset_stream()


## Frees the current game session and enters the main menu.
func enter_main_menu():
	game.queue_free()
	screen.reset_fade()
	bgm_player.reset_stream()
	main_menu = _main_menu_scn.instantiate()
	main_menu.init_main_menu(self)
	_add_child_to_root(main_menu)


func _change_to_game(save_game: SaveGame):
	main_menu.queue_free()
	game = _game_scn.instantiate()
	game.init_game(self, save_game)
	_add_child_to_root(game)


func _add_child_to_root(node: Node):
	get_tree().get_root().add_child(node)


func _add_child_to_root_deferred(node: Node):
	get_tree().get_root().call_deferred("add_child", node)
