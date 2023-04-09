class_name Room extends Node2D

@onready var party = $YSort/Party
@onready var thing = $YSort/Cat
@onready var cutscenes = $RoomCutscenes
@onready var party_roam_state: PartyRoamState = preload("res://game/state/party_roam_state.gd").new("party_roam_state")
@onready var cutscene_state: CutsceneState = preload("res://game/state/cutscene_state.gd").new("cutscene_state")
var dlg_res: DialogueResource
var stm: StateMachine
var pause_menu_prompted_target: Callable
var textbox_started_target: Callable
var cutscene_ended_target: Callable
var textbox_focused_target: Callable


func _ready():
	party.add_player("res://game/character/player.tscn")
	party.add_member("res://game/character/member.tscn")
	party_roam_state.init_state(
		party,
		pause_menu_prompted_target,
		_on_interaction_checked)
	stm.add_state(party_roam_state)
	cutscene_state.init_state(
		cutscenes,
		self,
		pause_menu_prompted_target)
	stm.add_state(cutscene_state)
	stm.change_state(party_roam_state.state_id)
	cutscenes.get_current_cutscene().make_cutscene(
		party,
		textbox_started_target,
		"default",
		"default",
		cutscene_ended_target,
		textbox_focused_target)


func init_room(
		given_stm: StateMachine,
		given_pause_menu_prompted_target: Callable,
		given_textbox_started_target: Callable,
		given_cutscene_ended_target: Callable,
		given_textbox_focused_target: Callable):
	stm = given_stm
	pause_menu_prompted_target = given_pause_menu_prompted_target
	textbox_started_target = given_textbox_started_target
	cutscene_ended_target = given_cutscene_ended_target
	textbox_focused_target = given_textbox_focused_target


func _on_interaction_checked():
	if thing.interact_area.get_overlapping_areas():
		stm.change_state(cutscene_state.state_id)
