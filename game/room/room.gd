class_name Room extends Node2D

@onready var party = $YSort/Party
@onready var thing = $YSort/Cat
@onready var cutscenes = $RoomCutscenes
@onready var party_roam_state: State = preload("res://game/state/party_roam_state.gd").new("party_roam_state")
@onready var cutscene_state: State = preload("res://game/state/cutscene_state.gd").new("cutscene_state")
var stm: StateMachine
var dlg_res: DialogueResource


func _ready():
	party.add_player("res://game/character/player.tscn")
	party.add_member("res://game/character/member.tscn")
	party_roam_state.init_state(party)
	stm.add_state(party_roam_state)
	cutscene_state.init_state(cutscenes, self)
	stm.add_state(cutscene_state)
	stm.change_state(party_roam_state.state_id)


func _physics_process(delta):
	stm.update_state(delta)


# ToDo: move to state machine
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		check_interaction()


func init_room(given_stm: StateMachine):
	stm = given_stm


func check_interaction():
	if thing.interact_area.get_overlapping_areas():
		stm.change_state(cutscene_state.state_id)


func get_current_cutscene():
	return cutscenes.get_children()[0]

