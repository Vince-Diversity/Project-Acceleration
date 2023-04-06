extends Node

@onready var menu_scn = preload("res://game/menu.tscn")
@onready var save_res = preload("res://loader/save_game.gd")
var loader: Loader
var save_dir: String
var room_node
var menu
var next: String


func _input(event):
	if event.is_action_pressed("ui_exit"):
		prompt_menu()


func load_room(room_name: String) -> void:
	States.current_room = room_name
	room_node = load(Utils.get_room_path(room_name)).instantiate()
	add_child(room_node)


func change_room() -> void:
	room_node.queue_free()
	load_room(next)
	room_node.run_room()


func prompt_menu() -> void:
	if !is_instance_valid(menu):
		menu = menu_scn.instantiate()
		menu.save_pressed.connect(_on_Menu_save_pressed)
		menu.reset_focus.connect(_on_Menu_reset_focus)
		add_child(menu)


func save_game_state(save_game: Resource):
	for property in States.property_list:
		save_game.data[property] = States.get(property)


func _on_Menu_save_pressed():
	var save_game = save_res.new()
	save_game.game_version = ProjectSettings.get_setting("application/config/version")
	save_game_state(save_game)
	var dir = DirAccess.open(save_dir)
	if not dir:
		DirAccess.make_dir_absolute(save_dir)
	var err = ResourceSaver.save(save_game, loader.save_path)
	if err != OK: print(err)


func _on_Menu_reset_focus():
	var cutscene: Cutscene = room_node.get_current_cutscene()
	cutscene.grab_cutscene_focus()

