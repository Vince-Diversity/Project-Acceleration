class_name NPCJoinedState extends NPCState


func enter():
	super()
	npc.collision.set_disabled(true)
	npc.interact_area.set_monitoring(false)
	npc.interact_area.set_monitorable(false)
	npc.set_deferred("is_following", true)


func exit():
	super()
	npc.collision.set_disabled(false)
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


func make_preserved_save(sg: SaveGame):
	super(sg)


func load_save(_sg: SaveGame):
	# NPCs are re-imported when loading into party
	pass
