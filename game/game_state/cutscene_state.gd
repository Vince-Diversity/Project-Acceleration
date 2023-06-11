class_name CutsceneState extends GameState

var cutscenes: RoomCutscenes


func init_state(
		given_cutscenes: RoomCutscenes):
	cutscenes = given_cutscenes


func update(delta: float):
	cutscenes.current_cutscene.update_cutscene(delta)


func handle_input(_event: InputEvent):
	pass


func enter():
	cutscenes.current_cutscene.begin_cutscene()


func exit():
	cutscenes.reset()


func grab_focus():
	cutscenes.current_cutscene.grab_cutscene_focus()


func save(game: Game, save_game: SaveGame):
	super(game, save_game)
	var source_thing = game.current_room.things.get_node(cutscenes.current_source_node)
	for node in game.get_tree().get_nodes_in_group("Preserved"):
		if not node.has_method("make_save"): continue
		if node == source_thing: continue
		node.make_save(save_game)

	var source_thing_dict = {}
	save_game.data["rooms"][source_thing.owner.room_id]["things"][source_thing.name] = source_thing_dict
	source_thing_dict["current_state"] = source_thing.current_state.state_id
	source_thing_dict["current_anim"] = "default"
	source_thing_dict["current_frame"] = 0
