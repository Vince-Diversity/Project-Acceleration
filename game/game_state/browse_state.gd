class_name BrowseState extends GameState

const browsing_node_name = "BrowsingCutscene"
var party: Party
var cutscenes: RoomCutscenes
var start_cutscene_target: Callable
var browsing_cutscene_scn: PackedScene
var previous_player_anim_name: String


func init_state(
		given_party: Party,
		given_cutscenes: RoomCutscenes,
		given_start_cutscene_target: Callable,
		given_browsing_cutscene_scn: PackedScene):
	party = given_party
	cutscenes = given_cutscenes
	start_cutscene_target = given_start_cutscene_target
	browsing_cutscene_scn = given_browsing_cutscene_scn


func update(_delta: float):
	pass


func handle_input(event: InputEvent):
	if event.is_action_pressed("ui_item"):
		party.player.browsing_ended.emit()
	elif event.is_action_pressed("ui_accept"):
		_retrieve_item()


func enter():
	previous_player_anim_name = party.player.get_animation()
	party.player.make_item_bubble()
	party.player.set_animation("pocket")


func exit():
	party.player.item_bubble.close()
	if not party.player.is_exhibiting():
		party.player.set_animation(previous_player_anim_name)


func grab_focus():
	pass


func save(game: Game, sg: SaveGame):
	super(game, sg)
	game.get_tree().call_group("Preserved", "make_save", sg)


func _retrieve_item():
	if party.player.is_near_interactable():
		party.player.check_stored_items_near_interactable()
	else:
		party.player.exhibit(party.player.get_thought_item_id())
		_make_browsing_cutscene()


func _make_browsing_cutscene():
	cutscenes.add_cutscene(browsing_cutscene_scn, browsing_node_name)
	start_cutscene_target.call(
		browsing_node_name,
		"browse_items",
		party.player.get_thought_item_sprite().browse_dialogue_node,
		party.player.items.exhibit_item)
