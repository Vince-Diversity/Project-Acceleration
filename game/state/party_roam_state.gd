class_name PartyRoamState extends State

var party: Party

signal prompt_pause_menu
signal check_interaction


func init_state(
		given_party: Party,
		prompt_pause_menu_target: Callable,
		check_interaction_target: Callable):
	party = given_party
	prompt_pause_menu.connect(prompt_pause_menu_target)
	check_interaction.connect(check_interaction_target)


func update(_delta: float):
	party.roam()


func handle_input(event: InputEvent):
	if event.is_action_pressed("ui_exit"):
		prompt_pause_menu.emit()


func handle_unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		check_interaction.emit()


func enter():
	pass


func exit():
	pass
