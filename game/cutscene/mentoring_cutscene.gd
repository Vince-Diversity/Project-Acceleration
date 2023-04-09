extends Cutscene

@onready var mentor_mark = $MentorMark
@onready var student_mark = $StudentMark
@onready var move_to_position_act_scr: GDScript = preload("res://game/cutscene/act/move_to_position_act.gd")
@onready var interact_act_scr: GDScript = preload("res://game/cutscene/act/interact_act.gd")


func make_cutscene(
		party: Party,
		textbox_started_target: Callable,
		dialogue_id: String,
		dialogue_node: String,
		cutscene_ended_target: Callable,
		textbox_focused_target: Callable):
	var move_to_position_act: Act = move_to_position_act_scr.new()
	var target_position: Array[Vector2] = [mentor_mark.global_position, student_mark.global_position]
	var target_direction: Array[Vector2] = [Vector2.UP, Vector2.UP]
	move_to_position_act.init_act(
		party,
		target_position,
		target_direction)
	actm.add_act(move_to_position_act)
	var interact_act: Act = interact_act_scr.new()
	interact_act.init_act(
		textbox_started_target,
		dialogue_id,
		dialogue_node,
		textbox_focused_target)
	actm.add_act(interact_act)
	cutscene_ended.connect(cutscene_ended_target)


func begin_cutscene():
	super()


func end_cutscene():
	cutscene_ended.emit("party_roam_state")


func update_cutscene(delta: float):
	super(delta)


func grab_cutscene_focus():
	super()
