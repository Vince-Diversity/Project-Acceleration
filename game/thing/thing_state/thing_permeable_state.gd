class_name ThingPermeableState extends ThingState


func enter():
	thing.interact_area.set_disabled(false)
	thing.collision.set_deferred("disabled", true)


func exit():
	pass


func check_interaction(_interactable_scene: Node2D):
	pass


func make_preserved_save(sg: SaveGame):
	var thing_dict = {}
	sg.data[sg.rooms_key][thing.owner.room_id][sg.things_key][thing.name] = thing_dict
	thing_dict[sg.state_key] = thing.spawn_state
	thing_dict[sg.anim_key] = "default"
	thing_dict[sg.frame_key] = 0
