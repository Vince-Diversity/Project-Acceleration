class_name ThingState extends GDScript

# the id is the scipt filename
var state_id: String
var thing: Thing


func _init(given_state_id: String, given_thing: Thing):
	state_id = given_state_id
	thing = given_thing

func enter():
	pass


func exit():
	pass


func check_interaction(_given_interactable: Node2D):
	pass


func make_preserved_save(sg: SaveGame):
	var thing_dict = {}
	sg.data[sg.rooms_key][thing.owner.room_id][sg.things_key][thing.name] = thing_dict
	thing_dict[sg.state_key] = state_id
	thing_dict[sg.anim_key] = "default"
	thing_dict[sg.frame_key] = 0
