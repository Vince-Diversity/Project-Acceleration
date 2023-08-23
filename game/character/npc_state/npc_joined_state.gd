class_name NPCJoinedState extends NPCState


func enter():
	npc.collosion.set_disabled(true)
	npc.interact_area.set_monitoring(false)
	npc.interact_area.set_monitorable(false)


func exit():
	npc.collosion.set_disabled(false)
	npc.interact_area.set_monitoring(true)
	npc.interact_area.set_monitorable(true)


func roam():
	npc._set_following_direction()
	if npc.is_following:
		npc.move()
	else:
		npc.animate_idle()



func make_save(sg: SaveGame):
	if npc.is_imaginary:
		super(sg)


func make_preserved_save(sg: SaveGame):
	if npc.is_imaginary:
		super(sg)


func load_save(sg: SaveGame):
	if npc.is_imaginary:
		super(sg)
