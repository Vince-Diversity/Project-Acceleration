extends Cutscene

@onready var mentor_mark = $MentorMark
@onready var student_mark = $StudentMark


func make():
	var move_to_position_act: Act = move_to_position_act_scr.new()
	var target_position: Array[Vector2] = [
		mentor_mark.global_position,
		student_mark.global_position]
	var target_direction: Array[Vector2] = [
		mentor_mark.get_target_direction(),
		student_mark.get_target_direction()]
	move_to_position_act.init_act(
		owner.party,
		target_position,
		target_direction)
	actm.add_act(move_to_position_act)
	var interact_act: Act = interact_act_scr.new()
	interact_act.init_act(
		owner.textbox_started_target,
		cutscenes.current_dialogue_id,
		cutscenes.current_dialogue_node,
		owner.textbox_focused_target)
	actm.add_act(interact_act)


func begin_cutscene():
	super()


func end_cutscene():
	cutscene_ended.emit("party_roam_state")


func update_cutscene(delta: float):
	super(delta)


func grab_cutscene_focus():
	super()
