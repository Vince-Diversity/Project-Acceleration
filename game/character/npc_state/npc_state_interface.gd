class_name NPCState extends GDScript

var state_id: String
var npc: NPC


func _init(given_state_id: String, given_npc: NPC):
	state_id = given_state_id
	npc = given_npc


func enter():
	if is_instance_valid(npc.room):
		Utils.try_connect(npc.room.player_interacted, check_interaction)
		Utils.try_connect(npc.interact_area.begin_interaction, npc.room._on_begin_interaction)


func exit():
	Utils.try_disconnect(npc.room.player_interacted, check_interaction)
	Utils.try_disconnect(npc.interact_area.begin_interaction, npc.room._on_begin_interaction)


func check_interaction(_interactable_scene: Node2D):
	pass


func roam():
	pass


func go_back_waiting(sg: SaveGame):
	# Edits the save before it loads
	var npc_dict = sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key][npc.name]
	npc_dict[sg.interaction_key] = ""
	npc_dict[sg.dialogue_id_key] = "default_join"
	npc_dict[sg.dialogue_node_key] = "default"
	npc_dict[sg.position_key] = npc.global_position
	npc_dict[sg.direction_key] = npc.inputted_direction


func make_save(sg: SaveGame):
	sg.update_room_keys(npc.room.room_id)
	var npc_dict = {}
	sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key][npc.name] = npc_dict
	npc_dict[sg.interaction_key] = npc.interaction_node
	npc_dict[sg.dialogue_id_key] = npc.dialogue_id
	npc_dict[sg.dialogue_node_key] = npc.dialogue_node
	npc_dict[sg.position_key] = npc.global_position
	npc_dict[sg.direction_key] = npc.inputted_direction
	npc_dict[sg.anim_key] = npc.get_animation()
	npc_dict[sg.idling_room_key] = npc.idling_room_id
	npc_dict[sg.was_joined_key] = npc.is_waiting_at_gateway
	npc_dict[sg.z_index_key] = npc.z_index


func make_preserved_save(sg: SaveGame):
	var npc_dict = {}
	sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key][npc.name] = npc_dict
	npc_dict[sg.interaction_key] = npc.interaction_node
	npc_dict[sg.dialogue_id_key] = npc.dialogue_id
	npc_dict[sg.dialogue_node_key] = npc.dialogue_node
	npc_dict[sg.position_key] = npc.preserved_position
	npc_dict[sg.direction_key] = Utils.get_anim_direction(npc.preserved_direction)
	npc_dict[sg.anim_key] = npc.preserved_animation
	npc_dict[sg.idling_room_key] = ""
	npc_dict[sg.was_joined_key] = false
	npc_dict[sg.z_index_key] = npc.preserved_z_index


func load_save(sg: SaveGame):
	if sg.data[sg.rooms_key].has(npc.room.room_id):
		var npc_dict = sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key][npc.name]
		npc.interaction_node = npc_dict[sg.interaction_key]
		npc.dialogue_id = npc_dict[sg.dialogue_id_key]
		npc.dialogue_node = npc_dict[sg.dialogue_node_key]
		npc.set_global_position(npc_dict[sg.position_key])
		npc.set_direction(npc_dict[sg.direction_key])
		npc.update_direction()
		npc.set_animation(npc_dict[sg.anim_key])
		npc.idling_room_id = npc_dict[sg.idling_room_key]
		npc.is_waiting_at_gateway = npc_dict[sg.was_joined_key]
		npc.set_z_index(npc_dict[sg.z_index_key])
