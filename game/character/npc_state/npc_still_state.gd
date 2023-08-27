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
	super(sg)


func make_preserved_save(sg: SaveGame):
	super(sg)


func load_save(sg: SaveGame):
	super(sg)
	if sg.data[sg.rooms_key].has(npc.room.room_id):
		var npc_dict = sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key][npc.name]
		if npc_dict[sg.was_joined_key]:
			npc.change_state("npc_joined_state")
			npc.room.party.add_npc_as_member(npc)
			npc.room.party._reset_members.call_deferred()
