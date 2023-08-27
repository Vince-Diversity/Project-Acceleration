class_name Party extends Node2D

var player: Player
var preserved_party_list: Array[String]


func create_player():
	player = load("res://game/character/player.tscn").instantiate()
	player.init_player(self)
	add_child(player)
	player.player_interacted.connect(owner._on_player_interacted)


func remove_member(member: NPC):
	if is_instance_valid(member):
		var member_position = member.global_position
		remove_child(member)
		owner.npcs.add_child(member)
		member.set_global_position(member_position)
	set_deferred("preserved_party_list", get_party_list())


func add_npc_as_member(npc: NPC):
	var npc_position = npc.global_position
	owner.npcs.remove_child(npc)
	_add_member(npc)
	npc.set_global_position(npc_position)
	_reset_members()


func _reset_members():
	var member
	for member_i in range(1, get_party_ordered().size()):
		member = get_party_ordered()[member_i]
		member.set_global_position(player.global_position)
		member.set_direction(
			Utils.get_anim_direction(Utils.AnimID.DOWN))
		member.update_direction()


func _add_member(member: NPC):
	add_child(member)
	move_child(member, 0)
	member.make_npc("npc_joined_state", owner)
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
		for npc_id in sg.data[sg.game_key][sg.party_key]:
			var npc = load(Utils.get_npc_path(npc_id)).instantiate()
			var npc_name = npc_id.to_pascal_case()
			if owner.npcs.has_node(npc_name):
				npc = owner.npcs.get_node(npc_name)
				add_npc_as_member(npc)
			else:
				_add_member(npc)
		create_player()
	for member in get_party_ordered():
		owner.entrance.set_entrance_direction(member)


func exit_cutscene():
	set_deferred("preserved_party_list", get_party_list())


func get_party_ordered() -> Array:
	var party_ordered := get_children()
	party_ordered.reverse()
	return party_ordered


func get_members_ordered() -> Array:
	var member_list: Array = []
	for member_i in range(1, get_party_ordered().size()):
		member_list.append((get_party_ordered()[member_i]))
	return member_list


func get_next_member(member: Character) -> Character:
	return get_children()[member.get_index() + 1]


func get_party_list() -> Array[String]:
	var party_list: Array[String] = []
	for member in get_members_ordered():
		party_list.append(member.name.to_snake_case())
	return party_list
