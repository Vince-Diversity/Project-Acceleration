class_name NPCStillState extends NPCState


func enter():
	npc.following_area.set_monitoring(false)
	npc.following_area.set_monitorable(false)
	if npc.anim_sprite.sprite_frames.has_animation(
			Utils.anim_name[npc.preserved_direction]):
		npc.set_direction(
			Utils.get_anim_direction(npc.preserved_direction))
		npc.update_direction()
	npc.preserved_position = npc.global_position


func exit():
	npc.following_area.set_monitoring(true)
	npc.following_area.set_monitorable(true)


func roam():
	pass


func make_save(sg: SaveGame):
	sg.update_room_keys(npc.owner.room_id)
	var npc_dict = {}
	sg.data[sg.rooms_key][npc.owner.room_id][sg.npcs_key][npc.name] = npc_dict
	npc_dict[sg.interaction_key] = npc.interaction_node
	npc_dict[sg.dialogue_id_key] = npc.dialogue_id
	npc_dict[sg.dialogue_node_key] = npc.dialogue_node
	npc_dict[sg.position_key] = npc.global_position
	npc_dict[sg.direction_key] = npc.inputted_direction


func make_preserved_save(sg: SaveGame):
	var npc_dict = {}
	sg.data[sg.rooms_key][npc.owner.room_id][sg.npcs_key][npc.name] = npc_dict
	npc_dict[sg.interaction_key] = npc.interaction_node
	npc_dict[sg.dialogue_id_key] = npc.dialogue_id
	npc_dict[sg.dialogue_node_key] = npc.dialogue_node
	npc_dict[sg.position_key] = npc.preserved_position
	npc_dict[sg.direction_key] = Utils.get_anim_direction(npc.preserved_direction)


func load_save(sg: SaveGame):
	if sg.data[sg.rooms_key].has(npc.owner.room_id):
		var npc_dict = sg.data[sg.rooms_key][npc.owner.room_id][sg.npcs_key][npc.name]
		npc.interaction_node = npc_dict[sg.interaction_key]
		npc.dialogue_id = npc_dict[sg.dialogue_id_key]
		npc.dialogue_node = npc_dict[sg.dialogue_node_key]
		npc.global_position = npc_dict[sg.position_key]
		npc.set_direction(npc_dict[sg.direction_key])
		npc.update_direction()
