class_name CutsceneState extends GameState
## a

## a
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
	cutscenes.get_tree().call_group("Preserved", "exit_cutscene")
	cutscenes.reset()


func grab_focus():
	cutscenes.current_cutscene.grab_cutscene_focus()


func save(game: Game, sg: SaveGame):
	super(game, sg)
	for node in cutscenes.get_tree().get_nodes_in_group("Preserved"):
		if node.has_method("make_preserved_save"):
			node.make_preserved_save(sg)
		else:
			if not node.has_method("make_save"): continue
			node.make_save(sg)
