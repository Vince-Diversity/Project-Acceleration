class_name CutsceneState extends GameState
## Enables a cutscene to play out.
##
## If the cutscene has dialogue, note that this state
## does not handle inputs to the dialogue.
## For such purpose, the Dialogue addon is used instead and
## the input handler is given in the current [TextBox] instance.
## [br]
## [br]
## When saving the game during a cutscene, before it finishes, the changes 
## done so far to the current game session are not saved.
## Instead, the game session before the cutscene started is saved.

var _cutscenes: RoomCutscenes


## Initialises this class.
func init_state(
		given_cutscenes: RoomCutscenes):
	_cutscenes = given_cutscenes


## Plays out any occuring cutscene acts at every frame.
func update(delta: float):
	_cutscenes.current_cutscene.update_cutscene(delta)


## Starts the [member RoomCutscenes.current_cutscene].
func enter():
	_cutscenes.current_cutscene.begin_cutscene()


## Clears the current cutscene data from [RoomCutscenes]
## and enables any changes made during the cutscene to be preserved when saving.
func exit():
	_cutscenes.get_tree().call_group("Preserved", "exit_cutscene")
	_cutscenes.reset()


## Directs the focus onto the current cutscene control.
func grab_focus():
	_cutscenes.current_cutscene.grab_cutscene_focus()


## Saves the game, but excludes changes done during the cutscene
## if the saved node has such a designated method [code]make_preserved_save[/code].
func save(game: Game, sg: SaveGame):
	super(game, sg)
	for node in _cutscenes.get_tree().get_nodes_in_group("Preserved"):
		if node.has_method("make_preserved_save"):
			node.make_preserved_save(sg)
		else:
			if not node.has_method("make_save"): continue
			node.make_save(sg)
