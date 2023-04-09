class_name PartyRoamState extends State

var party: Party

signal interaction_checked


func init_state(
		given_party: Party,
		interaction_checked_target: Callable):
	party = given_party
	interaction_checked.connect(interaction_checked_target)


func update(_delta: float):
	party.roam()


func handle_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		interaction_checked.emit()


func enter():
	pass


func exit():
	pass


func grab_focus():
	pass
