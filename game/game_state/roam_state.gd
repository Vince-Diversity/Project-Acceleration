class_name RoamState extends GameState
## Enables the player to move freely in the environment.

var _party: Party


## Initialises this class.
func init_state(
		given_party: Party):
	_party = given_party


## Updates positions of player and other party members at every frame.
func update(_delta: float):
	_party.roam()


## Allows the player to interact with the environment
## or browse through obtained items.
func handle_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		_party.player.check_interaction()
	elif event.is_action_pressed("ui_item"):
		_party.player.check_stored_items()


## Stops any ongoing movement animations.
func exit():
	super()
	for member in _party.get_party_ordered():
		member.animate_idle()
	pass


## Saves the game, including any preserved changes in the game session so far.
func save(game: Game, sg: SaveGame):
	super(game, sg)
	game.get_tree().call_group("Preserved", "make_save", sg)
