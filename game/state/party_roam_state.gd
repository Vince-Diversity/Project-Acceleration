class_name PartyRoamState extends State

var party: Party


func init_state(given_party: Party):
	party = given_party


func update(_delta: float):
	party.roam()


func handle_input():
	pass


func enter():
	pass


func exit():
	pass
