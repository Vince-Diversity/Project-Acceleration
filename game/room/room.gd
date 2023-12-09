class_name Room extends Node2D

@export_file var bgm_file: String

@onready var ysort = $YSort
@onready var party = $YSort/Party
@onready var cutscenes = $RoomCutscenes
@onready var things = $YSort/Things
@onready var npcs = $YSort/NPCs
@onready var doors = $Doors
@onready var tile_map = $TileMap
@onready var roam_state: RoamState = preload("res://game/game_state/roam_state.gd").new("roam_state")
@onready var cutscene_state: CutsceneState = preload("res://game/game_state/cutscene_state.gd").new("cutscene_state")
@onready var rest_state: RestState = preload("res://game/game_state/rest_state.gd").new("rest_state")
@onready var browse_state: BrowseState = preload("res://game/game_state/browse_state.gd").new("browse_state")
@onready var dialogue_cutscene_scn: PackedScene = preload("res://game/cutscene/dialogue_cutscene.tscn")
var thing_rng: RandomNumberGenerator
var room_id: String
var entrance_node: String
var entrance: Door
var dlg_res: DialogueResource
var stm: StateMachine
var bgm: AudioStreamPlayer
var screen: Screen
var textbox_started_target: Callable
var cutscene_ended_target: Callable
var textbox_focused_target: Callable

signal room_changed(next_room_id: String, next_room_entrance_node: String)
signal player_interacted(interactable: Node2D)
signal end_interaction()
signal entrance_event_edited(room_id: String, is_enabled: bool)
signal npc_removed(npc_name: String)
signal item_()


func _ready():
	_ready_entrance()
	_ready_doors()
	_ready_things()
	_ready_npcs()
	_ready_states()
	_ready_cutscenes()
	stm.change_state(roam_state.state_id)


func _ready_entrance():
	if doors.get_child_count() == 0:
		room_changed.emit("main_entrance", "DefaultDoor")
		return
	if doors.has_node(entrance_node):
		entrance = doors.get_node(entrance_node)
	else:
		entrance = doors.get_children()[0]
	party.set_global_position(entrance.spawn_point.global_position)


func _ready_doors():
	for door in doors.get_children():
		door.make_thing(self)
		var door_interactable = door.get_node("InteractArea")
		player_interacted.connect(door_interactable.check_interaction)
		door_interactable.begin_interaction.connect(_on_door_begin_interaction)


func _ready_things():
	thing_rng = RandomNumberGenerator.new()
	var thing_seed = Utils.str_to_seed(name)
	thing_rng.set_seed(thing_seed)
	for thing in things.get_children():
		thing.make_thing(self)
		var thing_interactable = thing.get_node("InteractArea")
		player_interacted.connect(thing_interactable.check_interaction)
		thing_interactable.begin_interaction.connect(_on_begin_interaction)
		thing.set_rng(thing_rng)


func _ready_npcs():
	for npc in npcs.get_children():
		npc.make_npc("npc_still_state", self)


func _ready_states():
	roam_state.init_state(party)
	stm.add_state(roam_state)
	cutscene_state.init_state(cutscenes)
	stm.add_state(cutscene_state)
	rest_state.init_state(start_cutscene)
	stm.add_state(rest_state)
	browse_state.init_state(party)
	stm.add_state(browse_state)


func _ready_cutscenes():
	for cutscene in cutscenes.get_children():
		make_cutscene(cutscene)


func make_cutscene(cutscene: Cutscene):
	cutscene.init_cutscene(cutscenes, screen)
	cutscene.cutscene_started.connect(
		_on_cutscene_started)
	cutscene.cutscene_ended.connect(cutscene_ended_target)


func init_room(
		given_room_id: String,
		given_entrance_node: String,
		given_stm: StateMachine,
		given_bgm: BGMPlayer,
		given_screen: Screen,
		change_room_target: Callable,
		given_textbox_started_target: Callable,
		given_cutscene_ended_target: Callable,
		given_textbox_focused_target: Callable,
		entrance_event_edited_target: Callable,
		npc_removed_target: Callable):
	room_id = given_room_id
	entrance_node = given_entrance_node
	stm = given_stm
	bgm = given_bgm
	bgm.update_stream(bgm_file)
	screen = given_screen
	room_changed.connect(change_room_target, CONNECT_DEFERRED)
	textbox_started_target = given_textbox_started_target
	cutscene_ended_target = given_cutscene_ended_target
	textbox_focused_target = given_textbox_focused_target
	entrance_event_edited.connect(entrance_event_edited_target)
	npc_removed.connect(npc_removed_target)


func handle_cutscene(target_root: Node2D):
	if cutscenes.has_node(target_root.interaction_node):
		start_cutscene(
			target_root.interaction_node,
			target_root.dialogue_id,
			target_root.dialogue_node,
			target_root)
	else:
		var cutscene_node = add_unique_cutscene()
		target_root.interaction_node = cutscene_node
		_on_begin_interaction.call_deferred(target_root)


func start_cutscene(
		interaction_node: String,
		dialogue_id: String,
		dialogue_node: String,
		source_node: Node2D):
	cutscenes.change_cutscene(interaction_node)
	cutscenes.change_dialogue(dialogue_id, dialogue_node)
	cutscenes.change_source_node(source_node)
	cutscenes.current_cutscene.cutscene_started.emit()
	stm.change_state(cutscene_state.state_id)
	end_interaction.connect(source_node.get_node("InteractArea")._on_end_interaction, CONNECT_ONE_SHOT)


func add_unique_cutscene() -> String:
	# When using this, wait for the cutscene node to be added before starting the cutscene
	var dlg_cutscene: DialogueCutscene = dialogue_cutscene_scn.instantiate()
	var interaction_node = "Default%s" % cutscenes.get_children().size()
	add_cutscene(dlg_cutscene, interaction_node)
	return interaction_node


func add_cutscene(cutscene: Cutscene, interaction_node: String):
	if not cutscenes.has_node(interaction_node):
		cutscenes.add_child(cutscene)
		cutscene.owner = self
		make_cutscene(cutscene)
		cutscene.name = interaction_node


func remove_members_at_gateway(door: Door):
	for member in party.get_members_ordered():
		if member.is_imaginary and door.is_gateway:
			party.remove_member(member)
			member.is_waiting_at_gateway = true


func create_npc(npc_node: String):
	var npc_id = Utils.get_npc_id(npc_node)
	var npc = load(Utils.get_npc_path(npc_id)).instantiate()
	npcs.add_child(npc)
	npc.make_npc(npc.spawn_state, self)
	npc.idling_room_id = room_id


func remove_npc(npc_node: String):
	var npc = npcs.get_node(npc_node)
	npc_removed.emit(npc.name)
	npc.queue_free()


func change_room(next_room_id: String, next_room_entrance_node: String):
	room_changed.emit(next_room_id, next_room_entrance_node)


func _on_player_interacted(interactable: Node2D):
	player_interacted.emit(interactable)


func _on_begin_interaction(target_root: Node2D):
	handle_cutscene(target_root)


func _on_door_begin_interaction(door: Door):
	var room_path = Utils.get_room_path(door.next_room_id)
	if FileAccess.file_exists(room_path):
		remove_members_at_gateway(door)
		change_room(door.next_room_id, door.next_room_entrance_node)
	else:
		_on_begin_interaction(door)


func _on_cutscene_started():
	cutscenes.current_cutscene.make()


func _on_browsing_started():
	stm.change_state("browse_state")


func _on_browsing_ended():
	stm.change_state("roam_state")


func _on_idle_bubbles_selected():
	cutscenes.add_cutscene(dialogue_cutscene_scn, browse_state.browsing_cutscene_name)
	start_cutscene(
		browse_state.browsing_cutscene_name,
		"browse_items",
		party.player.get_thought_item_sprite().browse_dialogue_node,
		party.player.items.exhibit_item)


func _on_interact_bubbles_selected():
	start_cutscene(
		add_unique_cutscene(),
		party.player.nearest_interactable.dialogue_id,
		party.player.get_thought_item_sprite().interaction_dialogue_node,
		party.player.nearest_interactable)
