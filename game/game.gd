class_name Game extends Node

@onready var menu_scn = preload("res://game/pause_menu.tscn")
@onready var save_res = preload("res://loader/save_game.gd")
@onready var default_state: DefaultState = preload("res://game/state/default_state.gd").new("default_state")
@onready var cutscene_state: CutsceneState = preload("res://game/state/cutscene_state.gd").new("cutscene_state")
@onready var stm: StateMachine = preload("res://game/state/state_machine.gd").new(default_state)
@onready var text_box_scn: PackedScene = preload("res://game/ui/textbox/textbox.tscn")
var loader: Loader
var save_dir: String
var menu: PauseMenu
var text_box: TextBox
var dlg_res: DialogueResource
var current_room: Room


func _physics_process(delta):
	stm.update_state(delta)


func _input(event: InputEvent):
	if event.is_action_pressed("ui_exit"):
		_pause()


func _unhandled_input(event):
	stm.handle_input_state(event)


func init_game(given_loader: Loader, given_save_dir: String):
	loader = given_loader
	save_dir = given_save_dir


func make_save(save_game: SaveGame):
	save_game.data["current_room_id"] = current_room.room_id
	save_game.data["entrance_node"] = current_room.entrance_node


func load_room(room_id: String, entrance_node: String):
	var room_path = Utils.get_room_path(room_id)
	current_room = load(room_path).instantiate()
	current_room.init_room(
		room_id,
		entrance_node,
		stm,
		change_room,
		_on_textbox_started,
		_on_cutscene_ended,
		_on_textbox_focused)
	add_child(current_room)


func change_room(room_id: String, entrance_node: String):
	var room_path = Utils.get_room_path(room_id)
	if FileAccess.file_exists(room_path):
		current_room.queue_free()
		load_room(room_id, entrance_node)
	else:
		push_error('Room not found: "%s"' % room_path)


func save():
	var save_game: SaveGame = save_res.new()
	save_game.game_version = ProjectSettings.get_setting("application/config/version")
	make_save(save_game)
	var dir = DirAccess.open(save_dir)
	if not dir:
		DirAccess.make_dir_absolute(save_dir)
	ResourceSaver.save(save_game, loader.save_path)


func _pause():
	if !is_instance_valid(menu):
		menu = menu_scn.instantiate()
		menu.init_pause_menu(
			_on_PauseMenu_save_pressed,
			_on_PauseMenu_main_menu_pressed,
			_on_PauseMenu_closed)
		add_child(menu)
		


func _on_textbox_started(
		dialogue_id: String,
		dialogue_node: String,
		dialogue_ended_target: Callable):
	text_box = text_box_scn.instantiate()
	add_child(text_box)
	var dlg_path = Utils.get_dlg_path(dialogue_id)
	if !FileAccess.file_exists(dlg_path): # if the dialogue resource does not exist
		dlg_path = Utils.get_dlg_path("default")
	dlg_res = load(dlg_path)
	if dlg_res.lines.size() <= 0: # if the dialogue resource is empty
		dlg_path = Utils.get_dlg_path("default")
		dlg_res = load(dlg_path)
	DialogueManager.dialogue_ended.connect(dialogue_ended_target, CONNECT_ONE_SHOT)
	if dialogue_node.is_empty(): # if no dialogue node is given
		dialogue_node = "default"
	# if the given dialogue node is not in the dialogue resource,
	# it seems to be starting on the first dialogue node
	text_box.start(dlg_res, dialogue_node)


func _on_cutscene_ended(next_state_id: String):
	stm.change_state(next_state_id)


func _on_textbox_focused():
	text_box.reset_focus()


func _on_PauseMenu_save_pressed():
	save()


func _on_PauseMenu_main_menu_pressed():
	loader.enter_main_menu()


func _on_PauseMenu_closed():
	_reset_focus()


func _reset_focus():
	stm.grab_state_focus()
