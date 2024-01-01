class_name RestState extends GameState
## A temporary state when the player is sitting or resting in some way.
##
## Chairs and beds are examples of [Thing] instances which the player can rest on.

var _start_cutscene_target: Callable
var _stand_up_node_name: String
var _stand_up_source_node: Node2D


## Initialises this class.
func init_state(given_start_cutscene_target: Callable):
	_start_cutscene_target = given_start_cutscene_target


## Assigns properties of the cutscene that plays when this state ends.
func make_state(
		given_stand_up_node_name: String,
		given_stand_up_source_node: Node2D):
	_stand_up_node_name = given_stand_up_node_name
	_stand_up_source_node = given_stand_up_source_node


## Enables any directional input to end this state.
func handle_input(event: InputEvent):
	if event.is_action_pressed("ui_down") \
	or event.is_action_pressed("ui_right") \
	or event.is_action_pressed("ui_up") \
	or event.is_action_pressed("ui_left"):
		_start_cutscene_target.call(
			_stand_up_node_name,
			"",
			"",
			_stand_up_source_node)


## Saves the game from the last state that allows saving.
func save(game: Game, sg: SaveGame):
	super(game, sg)
	save_preserved_game(game.get_tree(), sg)
