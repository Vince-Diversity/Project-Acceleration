class_name BrowseState extends GameState

const browsing_cutscene_name = "BrowsingCutscene"
var party: Party
var previous_player_anim_name: String


func init_state(given_party: Party):
	party = given_party


func update(_delta: float):
	pass


func handle_input(event: InputEvent):
	if event.is_action_pressed("ui_item"):
		party.player.browsing_ended.emit()
	elif event.is_action_pressed("ui_accept"):
		party.player.bubbles.select_option()


func enter():
	previous_player_anim_name = party.player.get_animation()
	party.player.set_animation("pocket")
	party.player.bubbles.create_item_bubble()


func exit():
	party.player.close_item_bubble()
	if not is_instance_valid(party.player.items.exhibit_item):
		party.player.set_animation(previous_player_anim_name)
		party.player.anim_sprite.stop()


func grab_focus():
	pass


func save(game: Game, sg: SaveGame):
	super(game, sg)
	game.get_tree().call_group("Preserved", "make_save", sg)
