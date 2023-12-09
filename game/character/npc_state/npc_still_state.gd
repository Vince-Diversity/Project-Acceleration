class_name NPCStillState extends NPCState


func enter():
	super()
	npc.following_area.set_monitoring(false)
	npc.following_area.set_monitorable(false)
	if npc.anim_sprite.sprite_frames.has_animation(npc.preserved_animation):
		npc.set_animation(npc.preserved_animation)
	elif npc.anim_sprite.sprite_frames.has_animation(
			Utils.anim_name[npc.preserved_direction]):
		npc.set_direction(
			Utils.get_anim_direction(npc.preserved_direction))
		npc.update_direction()
	npc.preserved_position = npc.global_position


func exit():
	super()
	npc.following_area.set_monitoring(true)
	npc.following_area.set_monitorable(true)


func check_interaction(given_interactable: Node2D):
	if given_interactable == npc:
		npc.get_node("InteractArea").begin_interaction.emit(npc)


func roam():
	pass


func make_save(sg: SaveGame):
	super(sg)


func make_preserved_save(sg: SaveGame):
	super(sg)


func load_save(sg: SaveGame):
	if sg.data[sg.rooms_key].has(npc.room.room_id):
		# Check if NPC is in a different room than its default room
		if _remove_moved_npc(sg): return
		var npcs_dict = sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key]
		# Check if NPC is removed from the save
		if npcs_dict.has(npc.name):
			super(sg)
			var npc_dict = npcs_dict[npc.name]
			# Check if NPC is waiting at a gateway
			if npc_dict[sg.was_joined_key]:
				npc.room.party.add_npc_as_member(npc)
				npc.is_waiting_at_gateway = false
		else:
			npc.queue_free()


func _remove_moved_npc(sg: SaveGame) -> bool:
	for room_id in sg.data[sg.rooms_key]:
		var room_dict = sg.data[sg.rooms_key][room_id]
		for npc_name in room_dict[sg.npcs_key].keys():
			var npc_dict = room_dict[sg.npcs_key][npc_name]
			if not npc_dict[sg.idling_room_key].is_empty():
				if npc_name == npc.name \
				and npc_dict[sg.idling_room_key] != npc.room.room_id:
					npc.queue_free()
					return true
	return false
