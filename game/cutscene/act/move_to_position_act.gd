extends Act

var party: Party
var is_party_moving: Array[bool]
var target_position: Array[Vector2]
var target_direction: Array[Vector2]


func init_act(given_party: Party,
		given_target_position: Array[Vector2],
		given_target_direction: Array[Vector2]):
	party = given_party
	target_position = given_target_position
	target_direction = given_target_direction


func update(delta: float):
	var member_list: Array = party.get_party_ordered()
	if Utils.any(is_party_moving):
		for member_i in member_list.size():
			var character = member_list[member_i]
			var direction = target_position[member_i] - character.global_position
			if direction.length() > delta * character.speed:
				character.set_direction(direction)
				character.move()
			else:
				character.set_direction(target_direction[member_i])
				character.update_direction()
				is_party_moving[member_i] = false
	else:
		act_finished.emit()


func enter():
	is_party_moving = Utils.ones(party.get_party_ordered())


func exit():
	pass


func grab_focus():
	pass
