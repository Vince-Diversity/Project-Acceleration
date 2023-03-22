extends Node2D

var player: Character


func add_member(path):
	var member = load(path).instantiate()
	add_child(member)
	member.party = self
	return member


func add_player(path):
	var member = add_member(path)
	player = member
	move_child(member, 0)


func roam():
	for member in get_party_ordered():
		if member == player:
			member.update_input_direction()
			if member.inputted_direction == Vector2.ZERO:
				member.animate_idle()
			else:
				member.move()
		else:
			_set_following_direction(member)
			if member.is_following:
				member.move()
			else:
				member.animate_idle()

func get_next_ally(member):
	return get_party_ordered()[member.get_index() - 1]


func get_party_ordered() -> Array:
	return get_children()


func _set_following_direction(member):
	var next_ally = get_next_ally(member)
	var direction = next_ally.global_position - member.global_position
	member.set_direction(direction)

