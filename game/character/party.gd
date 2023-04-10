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
		member.roam()


func get_party_ordered() -> Array:
	return get_children()
