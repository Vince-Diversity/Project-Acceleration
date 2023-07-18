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


func save(game: Game, sg: SaveGame):
	sg.data[sg.game_key] = {}
	sg.data[sg.game_key][sg.room_key] = game.current_room.room_id
	sg.data[sg.game_key][sg.entrance_key] = game.current_room.entrance_node
