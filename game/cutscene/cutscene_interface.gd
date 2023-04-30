class_name Cutscene extends Node2D

@onready var actm_scr: GDScript = preload("res://game/cutscene/act/act_manager.gd")
@onready var move_to_position_act_scr: GDScript = preload("res://game/cutscene/act/move_to_position_act.gd")
@onready var dialogue_act_scr: GDScript = preload("res://game/cutscene/act/dialogue_act.gd")
@onready var animate_act_scr: GDScript = preload("res://game/cutscene/act/animate_act.gd")
var actm: ActManager
var cutscenes: RoomCutscenes

signal cutscene_started
signal cutscene_ended(next_state_id: String)


func _ready():
	actm = actm_scr.new(end_cutscene)


func make():
	pass


func make_dialogue_act():
	var dialogue_act: Act = dialogue_act_scr.new()
	dialogue_act.init_act(
		owner.textbox_started_target,
		cutscenes.current_dialogue_id,
		cutscenes.current_dialogue_node,
		owner.textbox_focused_target,
		self)
	actm.add_act(dialogue_act)


func begin_cutscene():
	actm.enter_next_act()


func end_cutscene():
	cutscene_ended.emit("default_state")


func update_cutscene(delta: float):
	actm.update_act(delta)


func grab_cutscene_focus():
	actm.grab_act_focus()
