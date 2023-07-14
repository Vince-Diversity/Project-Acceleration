extends Act

var character_list: Array
var mark_list: Array
var is_moving: Array[bool]


func init_act(
		given_character_list: Array,
		given_mark_list: Array):
	character_list = given_character_list
	mark_list = given_mark_list


func update(delta: float):
	if Utils.any(is_moving):
		for char_i in character_list.size():
			var character = character_list[char_i]
			var direction = mark_list[char_i].global_position - character.global_position
			if direction.length() > delta * character.speed:
				character.set_direction(direction)
				character.move()
			else:
				character.set_direction(mark_list[char_i].get_target_direction())
				character.update_direction()
				is_moving[char_i] = false
	else:
		act_finished.emit()


func enter():
	is_moving = Utils.ones(character_list)


func exit():
	pass


func grab_focus():
	pass
