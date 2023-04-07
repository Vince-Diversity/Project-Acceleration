extends Cutscene

@onready var mentor_mark = $MentorMark
@onready var student_mark = $StudentMark
var is_moving
var dlg_res: DialogueResource
var text_box: TextBox
var is_dlg_ended: bool


func do_cutscene(delta, root_node) -> void:
	room = root_node
	match step:
		0:
			is_moving = Utils.ones(room.party.get_party_ordered().size())
			step += 1
		1:
			_move_to_position(
			delta,
			room.party,
			[mentor_mark.global_position, student_mark.global_position],
			Vector2.UP)
		2: _interact()
		3: _wait_interact()
		4: _end_cutscene()

func grab_cutscene_focus() -> void:
	if text_box != null:
		text_box.balloon.grab_focus()


func _move_to_position(delta, party, target_position, target_direction) -> void:
	var member_list = party.get_party_ordered()
	if Utils.any(is_moving):
		for member_i in member_list.size():
			var character = member_list[member_i]
			var direction = target_position[member_i] - character.global_position
			if direction.length() > delta * character.speed:
				character.set_direction(direction)
				character.move()
			else:
				character.set_direction(target_direction)
				character.update_direction()
				is_moving[member_i] = false
	else:
		step += 1


func _interact():
	var text_box_scn = load("res://game/ui/default_balloon/balloon.tscn")
	text_box = text_box_scn.instantiate()
	add_child(text_box)
	dlg_res = load("res://resources/dialogue/default.dialogue")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended, CONNECT_ONE_SHOT)
	text_box.start(dlg_res, "default")
	is_dlg_ended = false
	step += 1


func _wait_interact():
	if is_dlg_ended:
		step += 1


func _end_cutscene():
	room.stm.change_state(room.party_roam_state.state_id)
	step = 0


func _on_dialogue_ended(ended_dlg_res: DialogueResource):
	if dlg_res == ended_dlg_res:
		is_dlg_ended = true

