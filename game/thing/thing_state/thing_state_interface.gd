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
