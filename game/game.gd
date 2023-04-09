class_name Game extends Node

@onready var menu_scn = preload("res://game/pause_menu.tscn")
@onready var save_res = preload("res://loader/save_game.gd")
@onready var default_state: DefaultState = preload("res://game/state/default_state.gd").new("default_state")
@onready var menu_state: PauseMenuState = preload("res://game/state/pause_menu_state.gd").new("pause_menu_state")
@onready var stm: StateMachine = preload("res://game/state/state_machine.gd").new(default_state)
@onready var text_box_scn: PackedScene = preload("res://game/ui/textbox/textbox.tscn")
var loader: Loader
var save_dir: String
var current_room: Room
var menu: PauseMenu
var next_room_name: String
var text_box: TextBox
var dlg_res: DialogueResource


func _ready():
	stm.add_state(menu_state)


func _physics_process(delta):
	stm.update_state(delta)


func _input(event: InputEvent):
	stm.handle_input_state(event)


func _unhandled_input(event):
	stm.handle_unhandled_input_state(event)


func init_game(given_loader: Loader, given_save_dir: String):
	loader = given_loader
	save_dir = given_save_dir


func load_room(room_name: String):
	States.current_room = room_name
	current_room = load(Utils.get_room_path(room_name)).instantiate()
	current_room.init_room(
		stm,
		_on_menu_prompted,
		_on_textbox_started,
		_on_cutscene_ended,
		_on_textbox_focused)
	add_child(current_room)


func change_room():
	current_room.queue_free()
	load_room(next_room_name)
	current_room.run_room()


func save_game_state(save_game: Resource):
	for property in States.property_list:
		save_game.data[property] = States.get(property)


func _on_menu_prompted():
	if !is_instance_valid(menu):
		menu = menu_scn.instantiate()
		menu.init_pause_menu(
			stm,
			_on_Menu_save_pressed,
			_on_Menu_main_menu_pressed,
			_on_Menu_reset_focus)
		add_child(menu)
		stm.change_state(menu_state.state_id)
		get_tree().set_pause(true)


func _on_textbox_started(
		dialogue_id: String,
		dialogue_node: String,
		dialogue_ended_target: Callable):
	text_box = text_box_scn.instantiate()
	add_child(text_box)
	var dlg_path = Utils.get_dlg_path(dialogue_id)
	dlg_res = load(dlg_path)
	DialogueManager.dialogue_ended.connect(dialogue_ended_target, CONNECT_ONE_SHOT)
	text_box.start(dlg_res, dialogue_node)


func _on_cutscene_ended(next_state_id: String):
	stm.change_state(next_state_id)


func _on_textbox_focused():
	text_box.balloon.grab_focus()


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
		current_room.cutscenes.get_current_cutscene().grab_cutscene_focus()
