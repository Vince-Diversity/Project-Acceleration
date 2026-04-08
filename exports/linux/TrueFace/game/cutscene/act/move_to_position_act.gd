class_name MoveAct extends Act
## Moves a list of [Character] nodes along a line.


## The list of [Character] nodes for this act.
var character_list: Array

## The list of [CharacterMark] nodes marking all target positions for this act.
var mark_list: Array

## A boolean array showing if each character in this act has not yet reached the target position.
var is_moving: Array[bool]


## Initialises this class.
func init_act(
		given_character_list: Array,
		given_mark_list: Array):
	character_list = given_character_list
	mark_list = given_mark_list
	is_moving = Utils.ones(character_list)


## Plays character movement of all characters in this act simultaneously.
## When every character has reached their target positions, this act finishes.
func update(delta: float):
	if Utils.any(is_moving):
		for char_i in character_list.size():
			var character = character_list[char_i]
			var direction = mark_list[char_i].global_position - character.global_position
			if direction.length() > delta * character.speed:
				character.set_direction(direction)
				character.move(delta)
			else:
				character.set_direction(mark_list[char_i].get_target_direction())
				character.update_direction()
				is_moving[char_i] = false
	else:
		act_finished.emit()
