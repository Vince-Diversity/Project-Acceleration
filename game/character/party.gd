class_name Party extends Node2D

var player: Player


func add_member(path: String):
	var member: Member = load(path).instantiate()
	member.init_character(self)
	add_child(member)
	move_child(member, 0)
	return member


func add_player(path):
	var member: Player = load(path).instantiate()
	member.init_character(self)
	add_child(member)
	player = member


func roam():
	for member in get_party_ordered():
		member.roam()


func get_party_ordered() -> Array:
	var party_ordered := get_children()
	party_ordered.reverse()
	return party_ordered


func get_next_member(member: Character) -> Character:
	return get_children()[member.get_index() - 1]
