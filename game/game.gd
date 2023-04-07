class_name Game extends Node

@onready var menu_scn = preload("res://game/pause_menu.tscn")
@onready var save_res = preload("res://loader/save_game.gd")
@onready var stm: StateMachine = preload("res://game/state/state_machine.gd").new()
@onready var menu_state: State = preload("res://game/state/menu_state.gd").new("menu_state")
var loader: Loader
var save_dir: String
var current_room: Room
var menu: PauseMenu
var next_room_name: String


func _ready():
	stm.add_state(menu_state)


# ToDo: move to state machine
func _input(event):
	if event.is_action_pressed("ui_exit"):
		prompt_menu()


func init_game(given_loader: Loader, given_save_dir: String):
	loader = given_loader
	save_dir = given_save_dir


func load_room(room_name: String):
	States.current_room = room_name
	current_room = load(Utils.get_room_path(room_name)).instantiate()
	current_room.init_room(stm)
	add_child(current_room)


func change_room():
	current_room.queue_free()
	load_room(next_room_name)
	current_room.run_room()


func prompt_menu():
	if !is_instance_valid(menu):
		menu = menu_scn.instantiate()
		menu.init_pause_menu(
			stm,
			_on_Menu_save_pressed,
			_on_Menu_main_menu_pressed,
			_on_Menu_reset_focus)
		add_child(menu)
		stm.change_state(menu_state.state_id)


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


func _on_Menu_main_menu_pressed():
	loader.enter_main_menu()


func _on_Menu_reset_focus():
	if stm.previous_state.state_id == "cutscene_state":
		current_room.get_current_cutscene().grab_cutscene_focus()
