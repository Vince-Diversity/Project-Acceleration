class_name Party extends Node2D

@onready var player_scn = preload("res://game/character/player/player.tscn")
var player: Player
var preserved_party_list: Array[String]


func remove_member(member: NPC):
	if is_instance_valid(member):
		var member_position = member.global_position
		remove_child(member)
		owner.npcs.add_child(member)
		member.change_state("npc_still_state")
		member.set_global_position(member_position)
		member.idling_room_id = owner.room_id


func add_npc_as_member(npc: NPC):
	var npc_position = npc.global_position
	owner.npcs.remove_child(npc)
	_add_member(npc)
	npc.set_global_position(npc_position)


func has_member(npc_name: String) -> bool:
	if get_party_list().has(npc_name): return true
	return false


func roam():
	for member in get_party_ordered():
		member.roam()


func make_save(sg: SaveGame):
	sg.data[sg.party_key] = get_party_list()


func make_preserved_save(sg: SaveGame):
	sg.data[sg.party_key] = preserved_party_list


func load_save(sg: SaveGame):
	if sg.data.has(sg.party_key):
		for npc_name in sg.data[sg.party_key]:
			var npc_id = Utils.get_npc_id(npc_name)
			var npc: NPC
			if owner.npcs.has_node(npc_name):
				npc = owner.npcs.get_node(npc_name)
				if npc.is_imaginary:
					if owner.entrance.is_gateway:
						npc.current_state.go_back_waiting(sg)
					else:
						# The default NPC is excessive so remove it
						owner.npcs.remove_child(npc)
						_create_member(npc_id)
				else:
					add_npc_as_member(npc)
			else:
				_create_member(npc_id)
		_create_player()
	for member in get_party_ordered():
		owner.entrance.set_entrance_direction(member)
	player.items.load_save_from_parent(sg)


func _add_member(member: NPC):
	add_child(member)
	move_child(member, 0)
	member.make_npc("npc_joined_state", owner)
	set_deferred("preserved_party_list", get_party_list())
	member.idling_room_id = ""


func _create_member(npc_id: String):
	var npc = load(Utils.get_npc_path(npc_id)).instantiate()
	_add_member(npc)


func _create_player():
	player = player_scn.instantiate()
	player.init_player(
		self,
		owner._on_player_interacted,
		owner._on_browsing_started,
		owner._on_browsing_ended)
	add_child(player)
	player.make_player(
		owner._on_idle_bubbles_selected,
		owner._on_interact_bubbles_selected)
	set_deferred("preserved_party_list", get_party_list())


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
		party_list.append(member.name)
	return party_list
