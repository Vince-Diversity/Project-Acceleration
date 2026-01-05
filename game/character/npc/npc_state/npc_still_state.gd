class_name NPCStillState extends NPCState
## Enables player interaction with an [NPC].


## Connects interaction signals to the NPC with this state if those signals are not yet connected.
## Also disables their [Character.following_area], updates their [NPC.preserved_position]
## and sets their animation and direction to that given by [NPC.preserved.animation]
## and [NPC.preserved.direction].
func enter():
	if is_instance_valid(npc.room):
		Utils.try_connect(npc.room.player_interacted, check_interaction)
		Utils.try_connect(npc.interact_area.begin_interaction, npc.room._on_begin_interaction)
	npc.following_area.set_monitoring(false)
	npc.following_area.set_monitorable(false)
	_enter_preserved()


## Disconnects interaction signals to the NPC with this state if those signals are connected.
func exit():
	Utils.try_disconnect(npc.room.player_interacted, check_interaction)
	Utils.try_disconnect(npc.interact_area.begin_interaction, npc.room._on_begin_interaction)


## Checks if the NPC with this state is the desired [code]interactable_scene[/code]
## and begins the interaction if so.
func check_interaction(interactable_scene: Node2D):
	if interactable_scene == npc:
		npc.get_node("InteractArea").begin_interaction.emit(npc)


## Checks in the given save resource [code]sg[/code]
## if this NPC is in the current [Room]. If not, this NPC is freed.
## Also checks if this NPC was saved at a room other than their default room.
## and frees this NPC if so. Otherwise, the NPC is loaded from the given save resource.
## If the NPC was a party member it enters [NPCWaitingState].
func load_save(sg: SaveGame):
	# Makes sure this NPC is not in another room
	if sg.data[sg.rooms_key].has(npc.room.room_id):
		# Check if NPC is in a different room than its default room
		if _remove_moved_npc(sg): return
		var npcs_dict = sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key]
		# Check if NPC is removed from the save
		if npcs_dict.has(npc.name):
			super(sg)
		else:
			npc.queue_free()
	# Check if NPC is waiting at a gateway
	if sg.data[sg.rooms_key].has(npc.room.room_id):
		var npcs_dict = sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key]
		if npcs_dict.has(npc.name):
			var npc_dict = npcs_dict[npc.name]
			if npc_dict[sg.was_joined_key]:
				npc.change_states("npc_waiting_state")
		else:
			npc.queue_free()


func _enter_preserved():
	if npc.anim_sprite.sprite_frames.has_animation(npc.preserved_animation):
		npc.set_animation(npc.preserved_animation)
	elif npc.anim_sprite.sprite_frames.has_animation(
			Utils.anim_name[npc.preserved_direction]):
		npc.set_direction(
			Utils.get_anim_direction(npc.preserved_direction))
		npc.update_direction()
	npc.preserved_position = npc.global_position


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
