class_name NPCJoinedState extends NPCState


func enter():
	npc.collosion.set_disabled(true)
	npc.interact_area.set_monitoring(false)
	npc.interact_area.set_monitorable(false)
	npc.set_deferred("is_following", true)


func exit():
	npc.collosion.set_disabled(false)
	npc.interact_area.set_monitoring(true)
	npc.interact_area.set_monitorable(true)
	npc.is_following = false


func check_interaction(_given_interactable: Node2D):
	pass


func roam():
	npc._set_following_direction()
	if npc.is_following:
		npc.move()
	else:
		npc.animate_idle()



func make_save(sg: SaveGame):
	super(sg)
	var npc_dict = sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key][npc.name]
	npc_dict[sg.was_joined_key] = true


func make_preserved_save(sg: SaveGame):
	super(sg)


func load_save(sg: SaveGame):
	if npc.room.entrance.is_gateway:
		super(sg)
	else:
		if sg.data[sg.rooms_key].has(npc.room.room_id):
			var npc_dict = sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key][npc.name]
			npc.interaction_node = npc_dict[sg.interaction_key]
			npc.dialogue_id = npc_dict[sg.dialogue_id_key]
			npc.dialogue_node = npc_dict[sg.dialogue_node_key]
			npc.set_global_position(npc.room.party.global_position)
			npc.room.entrance.set_entrance_direction(npc)
			npc.idling_room_id = npc_dict[sg.idling_room_key]
