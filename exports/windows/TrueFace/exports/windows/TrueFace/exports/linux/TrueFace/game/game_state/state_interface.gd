class_name GameState extends GDScript
## Base class for game session states.
##
## Game session states enable the game to adapt to the current context.
## For example, when the current state is
## [RoamState], the arrow keys move the player, but when the current state is
## [CutsceneState] the arrow keys can only be used to switch between dialogue responses.
## These states also allow for different automatic behaviour,
## such as how the [CutsceneState] can enable a different party member movement pattern
## than just following the player around during the [RoamState].

## The filename (without the extension) is used as ID for this class.
var state_id: String


## Initialises this class, assigning the ID [member state_id].
func _init(given_state_id: String):
	state_id = given_state_id


## Called at every frame given by [method Node._physics_process].
func update(_delta: float):
	pass


## Called at each input event.
func handle_input(_event: InputEvent):
	pass


## Called when this state becomes the current state.
func enter():
	pass


## Called when this state is removed as the current state.
func exit():
	pass


## Called when managing focus of [Control] nodes.
func grab_focus():
	pass


## Called when saving the current game session to the given save resource [code]sg[/code].
## Unless overridden by a subclass, any node in the [code]Preserved[/code] group
## that has a method [code]make_save[/code] is included in this save.
func save(game: Game, sg: SaveGame):
	sg.data[sg.game_key] = {}
	sg.data[sg.game_key][sg.room_key] = game.current_room.room_id
	sg.data[sg.game_key][sg.entrance_key] = game.current_room.entrance_node


## Saves the current game session.
func save_current_game(scene_tree: SceneTree, sg: SaveGame):
	scene_tree.call_group("Preserved", "make_save", sg)


## Saves the game from a delayed game session
## if the saved nodes have such a designated method [code]make_preserved_save[/code].
## Otherwise, for nodes without that method, the current node instance is saved instead.
func save_preserved_game(scene_tree: SceneTree, sg: SaveGame):
	for node in scene_tree.get_nodes_in_group("Preserved"):
		if node.has_method("make_preserved_save"):
			node.make_preserved_save(sg)
		else:
			if not node.has_method("make_save"): continue
			node.make_save(sg)
