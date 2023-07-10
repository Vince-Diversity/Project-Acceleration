class_name Room extends Node2D

@onready var party = $YSort/Party
@onready var cutscenes = $RoomCutscenes
@onready var things = $YSort/Things
@onready var npcs = $YSort/NPCs
@onready var doors = $Doors
@onready var party_roam_state: PartyRoamState = preload("res://game/game_state/party_roam_state.gd").new("party_roam_state")
@onready var cutscene_state: CutsceneState = preload("res://game/game_state/cutscene_state.gd").new("cutscene_state")
@onready var dialogue_cutscene_scn: PackedScene = preload("res://game/cutscene/dialogue_cutscene.tscn")
var thing_rng: RandomNumberGenerator
var room_id: String
var entrance_node: String
var dlg_res: DialogueResource
var stm: StateMachine
var textbox_started_target: Callable
var cutscene_ended_target: Callable
var textbox_focused_target: Callable

signal room_changed(next_room_id: String, next_room_entrance_node: String)
signal player_interacted(interactable: Node2D)
signal end_interaction()


func _ready():
	_ready_party()
	_ready_entrance()
	_ready_doors()
	_ready_things()
	_ready_npcs()
	_ready_states()
	_ready_cutscenes()
	stm.change_state(party_roam_state.state_id)


func _ready_party():
	party.add_member("res://game/character/member.tscn")
	party.add_player("res://game/character/player.tscn")
	party.player.player_interacted.connect(_on_player_interacted)


func _ready_entrance():
	if doors.get_child_count() == 0:
		room_changed.emit("main_entrance", "DefaultDoor")
		return
	var entrance
	if doors.has_node(entrance_node):
		entrance = doors.get_node(entrance_node)
	else:
		entrance = doors.get_children()[0]
	party.global_position = entrance.spawn_point.global_position
	for member in party.get_party_ordered():
		entrance.set_entrance_direction(member)


func _ready_doors():
	for door in doors.get_children():
		player_interacted.connect(door.check_interaction)
		door.begin_interaction.connect(_on_door_begin_interaction)


func _ready_things():
	thing_rng = RandomNumberGenerator.new()
	var thing_seed = Utils.str_to_seed(name)
	thing_rng.set_seed(thing_seed)
	for thing in things.get_children():
		player_interacted.connect(thing.check_interaction)
		thing.begin_interaction.connect(_on_begin_interaction)
		thing.set_rng(thing_rng)


func _ready_npcs():
	for npc in npcs.get_children():
		player_interacted.connect(npc.check_interaction)
		npc.begin_interaction.connect(_on_begin_interaction)


func _ready_states():
	party_roam_state.init_state(
		party)
	stm.add_state(party_roam_state)
	cutscene_state.init_state(
		cutscenes)
	stm.add_state(cutscene_state)


func _ready_cutscenes():
	for cutscene in cutscenes.get_children():
		_ready_cutscene(cutscene)


func _ready_cutscene(cutscene: Cutscene):
	cutscene.cutscenes = cutscenes
	cutscene.cutscene_started.connect(
		_on_cutscene_started)
	cutscene.cutscene_ended.connect(cutscene_ended_target)


func init_room(
		given_room_id: String,
		given_entrance_node: String,
		given_stm: StateMachine,
		change_room_target: Callable,
		given_textbox_started_target: Callable,
		given_cutscene_ended_target: Callable,
		given_textbox_focused_target: Callable):
	room_id = given_room_id
	entrance_node = given_entrance_node
	stm = given_stm
	room_changed.connect(change_room_target, CONNECT_DEFERRED)
	textbox_started_target = given_textbox_started_target
	cutscene_ended_target = given_cutscene_ended_target
	textbox_focused_target = given_textbox_focused_target


func _on_player_interacted(interactable: Node2D):
	player_interacted.emit(interactable)


func _on_begin_interaction(target: Node2D):
	if cutscenes.has_node(target.interaction_node):
		cutscenes.change_cutscene(target.interaction_node)
		cutscenes.change_dialogue(target.dialogue_id, target.dialogue_node)
		cutscenes.change_source_node(target.name)
		cutscenes.current_cutscene.cutscene_started.emit()
		stm.change_state(cutscene_state.state_id)
		end_interaction.connect(target._on_end_interaction, CONNECT_ONE_SHOT)
	else:
		var dlg_cutscene: Cutscene = dialogue_cutscene_scn.instantiate()
		cutscenes.add_child(dlg_cutscene)
		dlg_cutscene.owner = self
		_ready_cutscene(dlg_cutscene)
		var new_name = "Default%s" % cutscenes.get_children().size()
		dlg_cutscene.name = new_name
		target.interaction_node = new_name
		_on_begin_interaction.call_deferred(target)


func _on_door_begin_interaction(door: Thing):
	var room_path = Utils.get_room_path(door.next_room_id)
	if FileAccess.file_exists(room_path):
		room_changed.emit(door.next_room_id, door.next_room_entrance_node)
	else:
		_on_begin_interaction(door)


func _on_cutscene_started():
	cutscenes.current_cutscene.make()
