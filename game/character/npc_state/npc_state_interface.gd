class_name NPCState extends GDScript

# the id is the scipt filename
var state_id: String
var npc: NPC


func _init(given_state_id: String, given_npc: NPC):
	state_id = given_state_id
	npc = given_npc


func enter():
	pass


func exit():
	pass


func roam():
	pass


func make_save(_sg: SaveGame):
	pass


func make_preserved_save(_sg: SaveGame):
	pass


func load_save(_sg: SaveGame):
	pass
