class_name NPCState extends GDScript

# the id is the scipt filename
var state_id: String
var npc: NPC


func _init(given_state_id: String, given_npc: NPC):
	state_id = given_state_id
	npc = given_npc


func enter():
	pass


func exit():
	pass


func roam():
	pass


func make_save(sg: SaveGame):
	sg.update_room_keys(npc.room.room_id)
	var npc_dict = {}
	sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key][npc.name] = npc_dict
	npc_dict[sg.interaction_key] = npc.interaction_node
	npc_dict[sg.dialogue_id_key] = npc.dialogue_id
	npc_dict[sg.dialogue_node_key] = npc.dialogue_node
	npc_dict[sg.position_key] = npc.global_position
	npc_dict[sg.direction_key] = npc.inputted_direction
	npc_dict[sg.was_joined_key] = false
	npc_dict[sg.idling_room_key] = npc.idling_room_id


func make_preserved_save(sg: SaveGame):
	var npc_dict = {}
	sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key][npc.name] = npc_dict
	npc_dict[sg.interaction_key] = npc.interaction_node
	npc_dict[sg.dialogue_id_key] = npc.dialogue_id
	npc_dict[sg.dialogue_node_key] = npc.dialogue_node
	npc_dict[sg.position_key] = npc.preserved_position
	npc_dict[sg.direction_key] = Utils.get_anim_direction(npc.preserved_direction)
	npc_dict[sg.was_joined_key] = false
	npc_dict[sg.idling_room_key] = npc.idling_room_id


func load_save(sg: SaveGame):
	if sg.data[sg.rooms_key].has(npc.room.room_id):
		var npc_dict = sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key][npc.name]
		npc.interaction_node = npc_dict[sg.interaction_key]
		npc.dialogue_id = npc_dict[sg.dialogue_id_key]
		npc.dialogue_node = npc_dict[sg.dialogue_node_key]
		npc.set_global_position(npc_dict[sg.position_key])
		npc.set_direction(npc_dict[sg.direction_key])
		npc.update_direction()
		npc.idling_room_id = npc_dict[sg.idling_room_key]
