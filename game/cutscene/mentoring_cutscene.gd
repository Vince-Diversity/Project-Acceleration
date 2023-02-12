extends Cutscene

onready var mentor_mark = $MentorMark
onready var student_mark = $StudentMark

func do_cutscene(delta, root_node) -> void:
	room = root_node
	match step:
		0: _move_to_position(delta, room.party, mentor_mark.global_position)
		1: _turn_to_direction(delta, room.party, Vector2.UP)
		2: _interact()
		3: _end_cutscene()

func _move_to_position(delta, character, target_position) -> void:
	var direction = target_position - character.global_position
	if direction.length() > delta * character.speed:
		character.set_direction(direction)
		character.move()
	else: step += 1

func _turn_to_direction(_delta, character, target_direction) -> void:
	character.set_direction(target_direction)
	character.move()
	step += 1

func _interact():
	print("%s pats %s" % ['Green', 'Cat'])
	step += 1

func _end_cutscene():
	room.state = room.States.ROAM
	step = 0
