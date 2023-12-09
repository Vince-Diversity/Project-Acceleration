class_name BubblesState extends GDScript

var state_id: String
var player: Player


func _init(given_state_id: String):
	state_id = given_state_id


func init_state(given_player: Player):
	player = given_player


func enter():
	pass


func exit():
	pass


func create():
	player.make_item_bubble()


func select():
	player.set_deferred("nearest_interactable", null)


func reset():
	pass
