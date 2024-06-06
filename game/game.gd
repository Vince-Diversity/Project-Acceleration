class_name Game extends Node2D
## When added to the [SceneTree], a game session starts running.
##
## Initialises the [StateMachine], which manages [GameState] instances.
## References the [Loader] for saving or exiting the current game session,
## and modifying the [BGMPlayer] and [Screen].
## Creates a game environment by managing [Room] nodes when a game session starts
## or when changing rooms with [method change_rooms], checking for any [EntranceEvents].
## Also manages [PauseMenu] and [TextBox] nodes.

@onready var _menu_scn = preload("res://game/pause_menu.tscn")
@onready var _default_state: DefaultState = preload("res://game/game_state/default_state.gd").new("default_state")
@onready var _stm: StateMachine = preload("res://game/game_state/state_machine.gd").new(_default_state)
@onready var _text_box_scn: PackedScene = preload("res://game/ui/textbox/textbox.tscn")
@onready var _entrance_events = $EntranceEvents

## Temporary save data used to store the current game session.
## The cache updates whenever the current room is changed by [method change_rooms].
var cache: SaveGame

## Reference to the loader.
var loader: Loader

## Current game environment instance.
var current_room: Room

## Current pause menu instance, or null when the game is not paused.
var menu: PauseMenu

## Current text box instance, or null when there is no dialogue.
var text_box: TextBox


func _physics_process(delta):
	_stm.update_state(delta)


func _input(event: InputEvent):
	if event.is_action_pressed("ui_exit"):
		_pause()


func _unhandled_input(event):
	_stm.handle_input_state(event)


## Initialises this node before it is added to the [SceneTree].
## References the [Loader] and the loaded [SaveGame].
func init_game(
		given_loader: Loader,
		save_game: SaveGame):
	loader = given_loader
	cache = save_game


func _load_room(room_id: String, entrance_node: String):
	var room_path = Utils.get_room_path(room_id)
	current_room = load(room_path).instantiate()
	current_room.init_room(
		room_id,
		entrance_node,
		_stm,
		loader.bgm_player,
		loader.screen,
		change_rooms,
		_on_textbox_started,
		_on_cutscene_ended,
		_on_textbox_focused,
		_entrance_events._on_entrance_event_edited,
		_on_npc_removed)
	add_child(current_room)


## Updates the [member cache] save,
## calls [method add_room] and frees the [member current_room] if it exists.
## If the given [code]room_id[/code] does not match a [Room] scene filename,
## a default room is added instead.
func change_rooms(room_id: String, entrance_node: String):
	var room_path = Utils.get_room_path(room_id)
	_save_cache()
	if FileAccess.file_exists(room_path):
		current_room.call_deferred("free")
		add_room(room_id, entrance_node)
	else:
		_load_room("main_entrance", "DefaultDoor")


func _save_cache():
	_make_save_game(cache)


## Adds a new [Room] instance with the filename given by [code]room_id[/code] to the [SceneTree]
## and assigns a spawn point at the given [code]entrance_node[/code].
## Then loads the [member cache] save data to the new room
## and starts an entrance event,
## if the room has an activated event listed in [EntranceEvents].
func add_room(room_id: String, entrance_node: String):
	_load_room(room_id, entrance_node)
	# Deferred so that the current room is freed before loading cache.
	# Otherwise the cache will also be loaded on the old room.
	_load_preserved.call_deferred(cache)
	_handle_entrance_events.call_deferred(room_id, entrance_node)


func _make_save_game(sg: SaveGame):
	_stm.save_state(self, sg)


func _load_preserved(sg: SaveGame):
	_create_preserved_npcs(sg)
	# Iterating needed, SceneTree.call_group doesn't find nodes that are moved during loading
	for node in get_tree().get_nodes_in_group("Preserved"):
		if not node.has_method("load_save"): continue
		node.load_save(sg)


func _create_preserved_npcs(sg: SaveGame):
	# Assumes only one instance of idling room id exists for each npc
	if sg.data[sg.rooms_key].has(current_room.room_id):
		var room_dict = sg.data[sg.rooms_key][current_room.room_id]
		for npc_name in room_dict[sg.npcs_key].keys():
			var npc_dict = room_dict[sg.npcs_key][npc_name]
			if npc_dict[sg.idling_room_key] == current_room.room_id \
			and not current_room.npcs.has_node(npc_name):
				var npc = load(Utils.get_npc_path(npc_dict[sg.filename_key])).instantiate()
				current_room.npcs.add_child(npc)
				npc.make_npc("npc_still_state", current_room)


func _handle_entrance_events(room_id: String, entrance_node: String):
	if _entrance_events.events.has(room_id):
		var interaction_node = _entrance_events.events[room_id]["interaction_node"]
		if interaction_node.is_empty():
			interaction_node = current_room.add_unique_cutscene()
			_start_entrance_events.call_deferred(room_id, entrance_node, interaction_node)
		else:
			_start_entrance_events(room_id, entrance_node, interaction_node)


func _start_entrance_events(room_id: String, entrance_node: String, interaction_node: String):
	var event_dict = _entrance_events.events[room_id]
	if event_dict["is_enabled"]:
		current_room.start_cutscene(
			interaction_node,
			event_dict["dialogue_id"],
			event_dict["dialogue_node"],
			current_room.doors.get_node(entrance_node))


## Creates a save file at the location given by [member Loader.save_dir].
## Uses a copy of the [member Game.cache]
## and possibly updates it depending on the current game session state.
func save():
	var sg = cache.duplicate()
	_make_save_game(sg)
	var dir = DirAccess.open(loader.save_dir)
	if not dir:
		DirAccess.make_dir_absolute(loader.save_dir)
	ResourceSaver.save(sg, loader.save_path)


func _pause():
	if !is_instance_valid(menu):
		menu = _menu_scn.instantiate()
		menu.init_pause_menu(
			_on_PauseMenu_save_pressed,
			_on_PauseMenu_main_menu_pressed,
			_on_PauseMenu_closed,
			loader.bgm_player)
		add_child(menu)


## Adds a text box to the scene tree.
## The contents of the text box are given by the
## filename of the [DialogueResource] [code]dialogue_id[/code],
## title to the [method DialogueResource.get_next_dialogue_line] [code]dialogue_node[/code],
## target of the [signal DialogueManager.dialogue_ended]
## signal [code]dialogue_ended_target[/code]
## and the current activated [code]dialogue_cutscene[/code].
## Items have special titles given by [ItemSprite.interaction_dialogue_node].
## If the dialogue resource filename or title is not found,
## the title of an item is used instead.
## (Since there is only one item so far, there is only one item to pick,
## hence the [code]@experimental[/code] tag).
## Otherwise, a default dialogue resource is used instead.
## @experimental
func _on_textbox_started(
		dialogue_id: String,
		dialogue_node: String,
		dialogue_ended_target: Callable,
		dialogue_cutscene: DialogueCutscene):
	text_box = _text_box_scn.instantiate()
	add_child(text_box)
	var dlg_path = Utils.get_dlg_path(dialogue_id)
	if not ResourceLoader.exists(dlg_path):
		dlg_path = Utils.get_dlg_path("default")
	var dlg_res = load(dlg_path)
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
	text_box.start(dlg_res, dialogue_node, [dialogue_cutscene])


## Called when a [CutsceneState] ends.
## Changes game session state to that of [code]next_state_id[/code].
## If the cutscene was an entrance event,
## that event is updated, see [method EntranceEvents.update_event].
func _on_cutscene_ended(next_state_id: String):
	_stm.change_states(next_state_id)
	_entrance_events.update_event(current_room.room_id)


## Gives focus to the current [TextBox]
func _on_textbox_focused():
	text_box.reset_focus()


## Called when an [NPC] is freed.
## Removes the entry of that npc from [member cache].
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
	_stm.grab_state_focus()
