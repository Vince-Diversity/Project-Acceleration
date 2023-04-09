class_name PartyRoamState extends State

var party: Party

signal pause_menu_prompted
signal interaction_checked


func init_state(
		given_party: Party,
		pause_menu_prompted_target: Callable,
		interaction_checked_target: Callable):
	party = given_party
	pause_menu_prompted.connect(pause_menu_prompted_target)
	interaction_checked.connect(interaction_checked_target)


func update(_delta: float):
	party.roam()


func handle_input(event: InputEvent):
	if event.is_action_pressed("ui_exit"):
		pause_menu_prompted.emit()


func handle_unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		interaction_checked.emit()


func enter():
	pass


func exit():
	pass
