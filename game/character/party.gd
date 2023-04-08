class_name Party extends Node2D

var player: Player


func add_member(path: String):
	var member: Character = load(path).instantiate()
	member.init_character(self)
	add_child(member)
	return member


func add_player(path):
	var member: Player = add_member(path)
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

func get_next_member(member: Character) -> Character:
	return get_party_ordered()[member.get_index() - 1]


func get_party_ordered() -> Array:
	return get_children()


func _set_following_direction(member: Character):
	var next_member: Character = get_next_member(member)
	var direction: Vector2 = next_member.global_position - member.global_position
	member.set_direction(direction)
