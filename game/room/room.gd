class_name Room extends Node2D

@onready var party = $YSort/Party
@onready var thing = $YSort/Cat
@onready var cutscenes = $RoomCutscenes
@onready var party_roam_state: PartyRoamState = preload("res://game/state/party_roam_state.gd").new("party_roam_state")
@onready var cutscene_state: CutsceneState = preload("res://game/state/cutscene_state.gd").new("cutscene_state")
var dlg_res: DialogueResource
var stm: StateMachine
var prompt_pause_menu_target: Callable


func _ready():
	party.add_player("res://game/character/player.tscn")
	party.add_member("res://game/character/member.tscn")
	party_roam_state.init_state(
		party,
		prompt_pause_menu_target,
		_on_check_interaction)
	stm.add_state(party_roam_state)
	cutscene_state.init_state(
		cutscenes,
		self,
		prompt_pause_menu_target)
	stm.add_state(cutscene_state)
	stm.change_state(party_roam_state.state_id)


func _physics_process(delta):
	stm.update_state(delta)


func _unhandled_input(event):
	stm.handle_unhandled_input_state(event)


func init_room(
		given_stm: StateMachine,
		given_prompt_pause_menu_target: Callable):
	stm = given_stm
	prompt_pause_menu_target = given_prompt_pause_menu_target


func get_current_cutscene():
	return cutscenes.get_children()[0]


func _on_check_interaction():
	if thing.interact_area.get_overlapping_areas():
		stm.change_state(cutscene_state.state_id)
