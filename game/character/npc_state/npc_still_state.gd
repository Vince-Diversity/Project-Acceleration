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
