class_name Cutscene extends Node2D

@onready var actm_scr: GDScript = preload("res://game/cutscene/act/act_manager.gd")
var actm: ActManager
var cutscenes: RoomCutscenes

signal cutscene_begun()
signal cutscene_ended(next_state_id: String)


func _ready():
	actm = actm_scr.new(end_cutscene)


func make():
	pass


func begin_cutscene():
	actm.enter_next_act()


func end_cutscene():
	cutscene_ended.emit("default_state")


func update_cutscene(delta: float):
	actm.update_act(delta)


func grab_cutscene_focus():
	actm.grab_act_focus()
