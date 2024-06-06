class_name Party extends Node2D
## Parent node to the [Player] and party member [NPC] nodes.
##
## The party node is used for managing and saving members of the player's party,
## and for loading the members including the player.
## When an [NPC] is a party member, the NPC follows the player as the player moves around,
## or the next [NPC] if there are other joined members.
## The following order is such that the first joined member follows the player,
## the next member follows that joined member, and so on.
## The order of these child nodes are such that the player is rendered on top of
## the party member which follows the player around, and so on for other members,
## As a consequence, the child node order that is given by [Node.get_children]
## is the reverse of the party member order. To get a list of party members in order,
## the [method get_party_ordered] can be used, or [method get_members_ordered]
## to exclude the player from that list.

@onready var _player_scn = preload("res://game/character/player/player.tscn")

## The player child node.
var player: Player

## List of the party members' node names, excluding the player,
## after the last [CutsceneState] ended.
var preserved_party_list: Array[String]


## Removes the given party [code]member[/code] node name,
## adding it to the [Room] [code]NPCs[/code] node instead.
func remove_member(member: NPC):
	if is_instance_valid(member):
		var member_position = member.global_position
		remove_child(member)
		owner.npcs.add_child(member)
		member.change_states("npc_still_state")
		member.set_global_position(member_position)
		member.idling_room_id = owner.room_id


## Adds the given [code]npc[/code] as the last party member,
## removing it from the [Room] [code]NPCs[/code] node.
func add_npc_as_member(npc: NPC):
	var npc_position = npc.global_position
	owner.npcs.remove_child(npc)
	_add_member(npc)
	npc.set_global_position(npc_position)


## Checks if the [NPC] with the given [code]npc_node[/code] name is a party member.
func has_member(npc_node: String) -> bool:
	if get_party_list().has(npc_node): return true
	return false


## Updated at every frame to make all party members move around.
func roam():
	for member in get_party_ordered():
		member.roam()


## Saves this party to the given [code]sg[/code].
func make_save(sg: SaveGame):
	sg.data[sg.party_key] = get_party_list()


## Saves this party at a previous point in the game session to the given [code]sg[/code].
func make_preserved_save(sg: SaveGame):
	sg.data[sg.party_key] = preserved_party_list


## Loads the party from the given [code]sg[/code].
## Once this is loaded loaded, the player's items are loaded
## and the direction of all party members are updated to that of the spawn point [Door].
func load_save(sg: SaveGame):
	if sg.data.has(sg.party_key):
		for npc_name in sg.data[sg.party_key]:
			var npc_dict = sg.data[sg.rooms_key][owner.room.room_id][sg.npcs_key][npc_name]
			var npc_id = npc_dict[sg.filename_key]
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
	player = _player_scn.instantiate()
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


## Called when a [CutsceneState] ends.
func exit_cutscene():
	set_deferred("preserved_party_list", get_party_list())


## Gets an array of party member nodes in the order which they follow one another,
## which means the player is the first entry.
func get_party_ordered() -> Array:
	var party_ordered := get_children()
	party_ordered.reverse()
	return party_ordered



## Gets an array of party members that excludes the player, in the order which
## they follow one another.
func get_members_ordered() -> Array:
	var member_list: Array = []
	for member_i in range(1, get_party_ordered().size()):
		member_list.append((get_party_ordered()[member_i]))
	return member_list


## Gets the party member which the given [code]member[/code] is following.
func get_next_member(member: NPC) -> Character:
	return get_children()[member.get_index() + 1]


## Gets a list of party member node names in the order which they follow one another.
func get_party_list() -> Array[String]:
	var party_list: Array[String] = []
	for member in get_members_ordered():
		party_list.append(member.name)
	return party_list
