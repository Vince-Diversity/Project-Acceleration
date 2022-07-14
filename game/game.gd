extends Node

onready var room_scn = preload("res://game/room/room.tscn")
onready var room_maker: Resource = preload("res://game/room/room_maker.gd")
onready var menu_scn = preload("res://game/ui/menu.tscn")
onready var save_res = preload("res://loader/save_game.gd")
var save_dir: String = Loader.dev_mode_save_dir
var room_node
var next: String

func _ready():
	load_room(States.current_room)

func _input(event):
	if event.is_action_pressed("ui_exit"):
		prompt_menu()

func load_room(room_name: String) -> void:
	room_node = room_scn.instance()
	room_maker.make(room_node, room_name)
	add_child(room_node)
	States.current_room = room_name
	room_node.ui.connect("finished", self, "change_room")

func change_room() -> void:
	room_node.queue_free()
	load_room(next)

func prompt_menu() -> void:
	var menu = menu_scn.instance()
	menu.connect("save_pressed", self, "_on_Menu_save_pressed")
	add_child(menu)

func save_game_state(save_game: Resource):
	save_game.data["current_room"] = States.current_room
	save_game.data["visited"] = States.visited
	save_game.data["in_blue_space"] = States.in_blue_space

func _on_Menu_save_pressed():
	var save_game = save_res.new()
	save_game.game_version = ProjectSettings.get_setting("application/config/version")
	save_game_state(save_game)
	var dir = Directory.new()
	if not dir.dir_exists(save_dir):
		dir.make_dir_recursive(save_dir)
	var err = ResourceSaver.save(Loader.save_path, save_game)
	if err != OK: print(err)
