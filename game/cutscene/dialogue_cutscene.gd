class_name DialogueCutscene extends Cutscene

@onready var mentor_mark = $MentorMark
@onready var student_mark = $StudentMark


func make():
	make_interact_act()


func move(next_dialogue_node: String):
	make_move_to_position_act()
	make_next_dialogue(next_dialogue_node)


func make_move_to_position_act():
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


func make_next_dialogue(next_dialogue_node: String):
	cutscenes.change_dialogue(
		cutscenes.current_dialogue_id,
		next_dialogue_node)
	make_interact_act()


func begin_cutscene():
	super()


func end_cutscene():
	cutscene_ended.emit("party_roam_state")


func update_cutscene(delta: float):
	super(delta)


func grab_cutscene_focus():
	super()
