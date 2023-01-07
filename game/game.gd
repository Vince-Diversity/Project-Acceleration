extends Node

onready var room_scn = preload("res://game/room/room.tscn")
onready var menu_scn = preload("res://game/menu.tscn")
onready var save_res = preload("res://loader/save_game.gd")
var save_dir: String = Loader.save_dir
var room_node
var menu
var next: String

func _ready():
	load_room(States.current_room)
	room_node.run_room()

func _input(event):
	if event.is_action_pressed("ui_exit"):
		prompt_menu()

func load_room(room_name: String) -> void:
	States.current_room = room_name
	room_node = room_scn.instance()
	add_child(room_node)
	room_node.ui.connect("change_room", self, "change_room")

func change_room() -> void:
	room_node.queue_free()
	load_room(next)
	room_node.run_room()

func prompt_menu() -> void:
	if !is_instance_valid(menu):
		menu = menu_scn.instance()
		menu.connect("save_pressed", self, "_on_Menu_save_pressed")
		menu.connect("reset_focus", self, "_on_Menu_reset_focus")
		add_child(menu)

func save_game_state(save_game: Resource):
	for property in States.property_list:
		save_game.data[property] = States.get(property)

func _on_Menu_save_pressed():
	var save_game = save_res.new()
	save_game.game_version = ProjectSettings.get_setting("application/config/version")
	save_game_state(save_game)
	var dir = Directory.new()
	if not dir.dir_exists(save_dir):
		dir.make_dir_recursive(save_dir)
	var err = ResourceSaver.save(Loader.save_path, save_game)
	if err != OK: print(err)

func _on_Menu_reset_focus():
	room_node.ui.text_box.grab_next_focus()
