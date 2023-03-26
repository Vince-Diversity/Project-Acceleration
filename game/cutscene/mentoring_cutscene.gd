extends Cutscene

@onready var mentor_mark = $MentorMark
@onready var student_mark = $StudentMark
var is_moving

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
		3: _end_cutscene()

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
	print("%s pats %s" % ['Green', 'Cat'])
	step += 1

func _end_cutscene():
	room.state = room.States.ROAM
	step = 0
