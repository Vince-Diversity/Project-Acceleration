class_name GameState extends GDScript

# The filename without extension is used as ID
var state_id: String


func _init(given_state_id: String):
	state_id = given_state_id


func update(_delta: float):
	pass


func handle_input(_event: InputEvent):
	pass


func enter():
	pass


func exit():
	pass


func grab_focus():
	pass


func save(game: Game, save_game: SaveGame):
	save_game.data["game"] = {}
	save_game.data["game"]["current_room_id"] = game.current_room.room_id
	save_game.data["game"]["entrance_node"] = game.current_room.entrance_node
