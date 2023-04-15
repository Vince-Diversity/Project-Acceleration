class_name Room extends Node2D

@onready var party = $YSort/Party
@onready var cutscenes = $RoomCutscenes
@onready var things = $YSort/Things
@onready var doors = $Doors
@onready var party_roam_state: PartyRoamState = preload("res://game/state/party_roam_state.gd").new("party_roam_state")
@onready var cutscene_state: CutsceneState = preload("res://game/state/cutscene_state.gd").new("cutscene_state")
var room_id: String
var entrance_node: String
var dlg_res: DialogueResource
var stm: StateMachine
var textbox_started_target: Callable
var cutscene_ended_target: Callable
var textbox_focused_target: Callable

signal room_changed(door: Door)
signal player_interacted(interactable: Node2D)


func _ready():
	party.add_player("res://game/character/player.tscn")
	party.player.player_interacted.connect(_on_player_interacted)
	party.add_member("res://game/character/member.tscn")
	var entrance = doors.get_node(entrance_node)
	if !is_instance_valid(entrance):
		entrance = doors.get_children()[0]
	party.global_position = entrance.spawn_point.global_position
	for member in party.get_party_ordered():
		entrance.set_entrance_direction(member)
	for thing in things.get_children():
		player_interacted.connect(thing.check_interaction)
		thing.begin_interaction.connect(_on_thing_begin_interaction)
	for door in doors.get_children():
		player_interacted.connect(door.check_interaction)
		door.begin_interaction.connect(_on_door_begin_interaction)
	party_roam_state.init_state(
		party)
	stm.add_state(party_roam_state)
	cutscene_state.init_state(
		cutscenes)
	stm.add_state(cutscene_state)
	for cutscene in cutscenes.get_children():
		cutscene.cutscenes = cutscenes
		cutscene.cutscene_begun.connect(
			_on_cutscene_begun_first_time, CONNECT_ONE_SHOT)
		cutscene.cutscene_ended.connect(cutscene_ended_target)
	stm.change_state(party_roam_state.state_id)


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
	room_changed.connect(change_room_target)
	textbox_started_target = given_textbox_started_target
	cutscene_ended_target = given_cutscene_ended_target
	textbox_focused_target = given_textbox_focused_target


func _on_player_interacted(interactable: Node2D):
	player_interacted.emit(interactable)


func _on_thing_begin_interaction(thing: Thing):
	if cutscenes.has_node(thing.interaction_node):
		cutscenes.change_cutscene(thing.interaction_node)
		cutscenes.change_dialogue(thing.dialogue_id, thing.dialogue_node)
		cutscenes.current_cutscene.cutscene_begun.emit()
		stm.change_state(cutscene_state.state_id)
	else:
		push_error('Interaction node not found: "%s"' % thing.interaction_node)


func _on_door_begin_interaction(door: Thing):
	room_changed.emit(door.next_room_id, door.next_room_entrance_node)


func _on_cutscene_begun_first_time():
	cutscenes.current_cutscene.make()
