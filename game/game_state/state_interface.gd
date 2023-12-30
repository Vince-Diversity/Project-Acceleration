class_name GameState extends GDScript
## Base class for game session states.
##
## Game session states enables the game to adapt to the context of the game session.
## For example, when the current state is
## [RoamState], the arrow keys moves the player, but when the current state is
## [CutsceneState] the arrow keys can only be used to switch between dialogue responses.
## These states also allow for different automatic behaviour,
## such as how the [CutsceneState] can enable a different party member movement pattern
## than just following the player around during the [RoamState].

## The filename (without the extension) is used as ID for this class.
var state_id: String


func _init(given_state_id: String):
	state_id = given_state_id


## Called at each frame update.
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


## Called when saving the given save resource sg.
func save(game: Game, sg: SaveGame):
	sg.data[sg.game_key] = {}
	sg.data[sg.game_key][sg.room_key] = game.current_room.room_id
	sg.data[sg.game_key][sg.entrance_key] = game.current_room.entrance_node
