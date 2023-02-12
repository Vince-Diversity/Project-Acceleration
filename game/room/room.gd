extends Node2D

enum States {ROAM, CUTSCENE}

onready var party = $YSort/Party
onready var thing = $YSort/Cat
onready var cutscenes = $Cutscenes
var state = States.ROAM
var dlg_res: Resource

func _ready():
	state = States.ROAM

func _physics_process(delta):
	match state:
		States.ROAM:
			party.roam()
		States.CUTSCENE:
			cutscenes.get_children()[0].do_cutscene(delta, self)

func _unhandled_input(event):
	if event.is_action_pressed("ui_select"):
		check_interaction()

func check_interaction():
	if thing.interact_area.get_overlapping_areas():
		state = States.CUTSCENE
