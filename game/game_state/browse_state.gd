class_name BrowseState extends GameState

const browsing_cutscene_name = "BrowsingCutscene"
var room: Room
var party: Party
var cutscenes: RoomCutscenes
var previous_player_anim_name: String


func init_state(given_room: Room):
	room = given_room
	party = room.party
	cutscenes = room.cutscenes


func update(_delta: float):
	pass


func handle_input(event: InputEvent):
	if event.is_action_pressed("ui_item"):
		party.player.browsing_ended.emit()
	elif event.is_action_pressed("ui_accept"):
		_retrieve_item()


func enter():
	previous_player_anim_name = party.player.get_animation()
	party.player.set_animation("pocket")
	party.player.make_item_bubble()


func exit():
	party.player.close_bubbles()
	party.player.reset_bubbles()
	if not party.player.is_exhibiting():
		party.player.set_animation(previous_player_anim_name)
		party.player.anim_sprite.stop()


func grab_focus():
	pass


func save(game: Game, sg: SaveGame):
	super(game, sg)
	game.get_tree().call_group("Preserved", "make_save", sg)


func _retrieve_item():
	if party.player.is_near_interactable():
		_make_item_interaction_cutscene()
	else:
		party.player.exhibit(party.player.get_thought_item_id())
		_make_browsing_cutscene()


func _make_item_interaction_cutscene():
	var interaction_node = room.add_unique_cutscene()
	room.start_cutscene.call(
		interaction_node,
		party.player.nearest_interactable.dialogue_id,
		party.player.get_thought_item_sprite().interaction_dialogue_node,
		party.player.nearest_interactable)


func _make_browsing_cutscene():
	cutscenes.add_cutscene(room.dialogue_cutscene_scn, browsing_cutscene_name)
	room.start_cutscene.call(
		browsing_cutscene_name,
		"browse_items",
		party.player.get_thought_item_sprite().browse_dialogue_node,
		party.player.items.exhibit_item)
