class_name PartyRoamState extends State

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


func grab_focus():
	pass
