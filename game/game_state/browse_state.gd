class_name BrowseState extends GameState

var party: Party


func init_state(given_party: Party):
	party = given_party


func update(_delta: float):
	pass


func handle_input(event: InputEvent):
	if event.is_action_pressed("ui_item"):
		party.player.browsing_ended.emit()


func enter():
	pass


func exit():
	party.player.item_bubble.close()


func grab_focus():
	pass


func save(game: Game, sg: SaveGame):
	super(game, sg)
	game.get_tree().call_group("Preserved", "make_save", sg)
