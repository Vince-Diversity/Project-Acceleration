class_name Game extends Node2D

@onready var menu_scn = preload("res://game/pause_menu.tscn")
@onready var save_res = preload("res://loader/save_game.gd")
@onready var default_state: DefaultState = preload("res://game/game_state/default_state.gd").new("default_state")
@onready var stm: StateMachine = preload("res://game/game_state/state_machine.gd").new(default_state)
@onready var text_box_scn: PackedScene = preload("res://game/ui/textbox/textbox.tscn")
@onready var entrance_events = $EntranceEvents
var cache: SaveGame
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


func init_game(
		given_loader: Loader, given_save_dir: String, save_game: SaveGame):
	loader = given_loader
	save_dir = given_save_dir
	cache = save_game


func load_room(room_id: String, entrance_node: String):
	var room_path = Utils.get_room_path(room_id)
	current_room = load(room_path).instantiate()
	current_room.init_room(
		room_id,
		entrance_node,
		stm,
		loader.bgm_player,
		loader.screen,
		change_room,
		_on_textbox_started,
		_on_cutscene_ended,
		_on_textbox_focused,
		_on_entrance_event_edited,
		_on_npc_removed)
	add_child(current_room)


func change_room(room_id: String, entrance_node: String):
	var room_path = Utils.get_room_path(room_id)
	save_cache()
	if FileAccess.file_exists(room_path):
		# Free the current room before loading cache
		# Otherwise the cache will also be loaded on the old room
		current_room.call_deferred("free")
		add_room(room_id, entrance_node)
	else:
		load_room("main_entrance", "DefaultDoor")


func save_cache():
	make_save_game(cache)


func add_room(room_id: String, entrance_node: String):
	load_room(room_id, entrance_node)
	load_preserved.call_deferred(cache)
	handle_entrance_events.call_deferred(room_id, entrance_node)


func make_save_game(sg: SaveGame):
	stm.save_state(self, sg)


func load_preserved(sg: SaveGame):
	create_preserved_npcs(sg)
	# Iterating needed, SceneTree.call_group doesn't find nodes that are moved during loading
	for node in get_tree().get_nodes_in_group("Preserved"):
		if not node.has_method("load_save"): continue
		node.load_save(sg)


func create_preserved_npcs(sg: SaveGame):
	# Assumes only one instance of idling room id exists for each npc
	if sg.data[sg.rooms_key].has(current_room.room_id):
		var room_dict = sg.data[sg.rooms_key][current_room.room_id]
		for npc_name in room_dict[sg.npcs_key].keys():
			var npc_dict = room_dict[sg.npcs_key][npc_name]
			if npc_dict[sg.idling_room_key] == current_room.room_id \
			and not current_room.npcs.has_node(npc_name):
				var npc = load(Utils.get_npc_path(Utils.get_npc_id(npc_name))).instantiate()
				current_room.npcs.add_child(npc)
				npc.make_npc("npc_still_state", current_room)


func handle_entrance_events(room_id: String, entrance_node: String):
	if entrance_events.events.has(room_id):
		var interaction_node = entrance_events.events[room_id]["interaction_node"]
		if interaction_node.is_empty():
			interaction_node = current_room.add_unique_cutscene()
			start_entrance_events.call_deferred(room_id, entrance_node, interaction_node)
		else:
			start_entrance_events(room_id, entrance_node, interaction_node)


func start_entrance_events(room_id: String, entrance_node: String, interaction_node: String):
	var event_dict = entrance_events.events[room_id]
	if event_dict["is_enabled"]:
		current_room.start_cutscene(
			interaction_node,
			event_dict["dialogue_id"],
			event_dict["dialogue_node"],
			current_room.doors.get_node(entrance_node))


func save():
	var sg = cache.duplicate()
	make_save_game(sg)
	var dir = DirAccess.open(save_dir)
	if not dir:
		DirAccess.make_dir_absolute(save_dir)
	ResourceSaver.save(sg, loader.save_path)


func _pause():
	if !is_instance_valid(menu):
		menu = menu_scn.instantiate()
		menu.init_pause_menu(
			_on_PauseMenu_save_pressed,
			_on_PauseMenu_main_menu_pressed,
			_on_PauseMenu_closed,
			loader.bgm_player)
		add_child(menu)


func _on_textbox_started(
		dialogue_id: String,
		dialogue_node: String,
		dialogue_ended_target: Callable,
		cutscene: DialogueCutscene):
	text_box = text_box_scn.instantiate()
	add_child(text_box)
	var dlg_path = Utils.get_dlg_path(dialogue_id)
	if not ResourceLoader.exists(dlg_path):
		dlg_path = Utils.get_dlg_path("default")
	dlg_res = load(dlg_path)
	if dlg_res.lines.size() <= 0 or not dlg_res.titles.has(dialogue_node):
		if Utils.has_res(
				Utils.item_sprite_dir,
				func(item_sprite):
					return item_sprite.interaction_dialogue_node == dialogue_node):
			dlg_path = Utils.get_dlg_path("default_reveal")
			dialogue_node = "default"
		else:
			dlg_path = Utils.get_dlg_path("default")
			dialogue_node = "default"
		dlg_res = load(dlg_path)
	DialogueManager.dialogue_ended.connect(dialogue_ended_target, CONNECT_ONE_SHOT)
	text_box.start(dlg_res, dialogue_node, [cutscene])


func _on_cutscene_ended(next_state_id: String):
	stm.change_state(next_state_id)
	entrance_events.update_event(current_room.room_id)


func _on_textbox_focused():
	text_box.reset_focus()


func _on_entrance_event_edited(room_id: String, is_enabled: bool):
	if entrance_events.events.has(room_id):
		entrance_events.events[room_id]["is_enabled"] = is_enabled


func _on_npc_removed(removed_npc_name: String):
	if cache.data[cache.rooms_key].has(current_room.room_id):
		var npcs_dict = cache.data[cache.rooms_key][current_room.room_id][cache.npcs_key]
		if npcs_dict.has(removed_npc_name):
			npcs_dict.erase(removed_npc_name)


func _on_PauseMenu_save_pressed():
	save()


func _on_PauseMenu_main_menu_pressed():
	loader.enter_main_menu()


func _on_PauseMenu_closed():
	_reset_focus()


func _reset_focus():
	stm.grab_state_focus()
