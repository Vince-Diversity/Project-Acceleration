class_name PartyRoamState extends GameState

var party: Party


func init_state(
		given_party: Party):
	party = given_party


func update(_delta: float):
	party.roam()


func handle_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		party.player.check_interaction()


func enter():
	pass


func exit():
	for member in party.get_party_ordered():
		member.animate_idle()
	pass


func grab_focus():
	pass


func save(game: Game, sg: SaveGame):
	super(game, sg)
	for node in game.get_tree().get_nodes_in_group("Preserved"):
		if not node.has_method("make_save"): continue
		node.make_save(sg)
