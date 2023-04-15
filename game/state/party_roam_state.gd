class_name PartyRoamState extends State

var party: Party


func init_state(
		given_party: Party):
	party = given_party


func update(_delta: float):
	party.player.check_nearest_interactable()
	party.roam()


func handle_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		party.player.check_interaction()


func enter():
	pass


func exit():
	pass


func grab_focus():
	pass
