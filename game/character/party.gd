class_name Party extends Node2D

var player: Player
var preserved_party_list: Array[String]


func add_player():
	player = load("res://game/character/player.tscn").instantiate()
	player.init_player(self)
	add_child(player)
	player.player_interacted.connect(owner._on_player_interacted)


func add_member(path: String):
	var member: NPC = load(path).instantiate()
	add_child(member)
	move_child(member, 0)
	member.make_npc(self, "npc_joined_state")
	set_deferred("preserved_party_list", get_party_list())
	return member


func remove_member(member_name):
	var member = get_node(member_name)
	if is_instance_valid(member):
		remove_child(member)
	set_deferred("preserved_party_list", get_party_list())


func roam():
	for member in get_party_ordered():
		member.roam()


func make_save(sg: SaveGame):
	sg.data[sg.game_key][sg.party_key] = get_party_list()


func make_preserved_save(sg: SaveGame):
	sg.data[sg.game_key][sg.party_key] = preserved_party_list


func load_save(sg: SaveGame):
	if sg.data[sg.game_key].has(sg.party_key):
		for npc_name in sg.data[sg.game_key][sg.party_key]:
			add_member(Utils.get_npc_path(npc_name))
	add_player()
	for member in get_party_ordered():
		owner.entrance.set_entrance_direction(member)


func exit_cutscene():
	set_deferred("preserved_party_list", get_party_list())


func get_party_ordered() -> Array:
	var party_ordered := get_children()
	party_ordered.reverse()
	return party_ordered


func get_next_member(member: Character) -> Character:
	return get_children()[member.get_index() - 1]


func get_party_list() -> Array[String]:
	var party_list: Array[String] = []
	for member_i in range(1, get_party_ordered().size()):
		party_list.append(get_party_ordered()[member_i].name.to_snake_case())
	return party_list
