class_name BrowseState extends GameState
## Enables the player to look through currently obtained items.

const browsing_cutscene_name = "BrowsingCutscene"

var _party: Party
var _previous_player_anim_name: String


## Initialises this state.
func init_state(given_party: Party):
	_party = given_party


## Allows the player to select an obtained item.
func handle_input(event: InputEvent):
	if event.is_action_pressed("ui_item"):
		_party.player.browsing_ended.emit()
	elif event.is_action_pressed("ui_accept"):
		_party.player.bubbles.select_option()


## Opens an [ItemBubble] instance above the player
## and plays a browsing animation.
func enter():
	_previous_player_anim_name = _party.player.get_animation()
	_party.player.set_animation("pocket")
	_party.player.bubbles.create_item_bubble()


## Closes the [ItemBubble] instance, hides any occasional items
## that were shown and restores the player animation to that before this state.
func exit():
	_party.player.close_item_bubble()
	if not is_instance_valid(_party.player.items.exhibit_item):
		_party.player.set_animation(_previous_player_anim_name)
		_party.player.anim_sprite.stop()
	_previous_player_anim_name = "";


## Saves the game, including any preserved changes in the game session so far.
func save(game: Game, sg: SaveGame):
	super(game, sg)
	save_current_game(game.get_tree(), sg)
