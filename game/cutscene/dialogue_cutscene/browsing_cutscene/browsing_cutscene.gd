class_name BrowsingCutscene extends DialogueCutscene
## A cutscene containing properties for when the player is using items.
##
## This cutscene has toggles for what physics layer is on.
## Also, the player can use the revealer on the surface below the player
## by calling a [Cutscene] with the node name [member reveal_cutscene_name].

const reveal_node_name: String = "Reveal"

## Toggle for enabling revealing the surface below the player.
var is_revealing_surface: bool = false

## Checks if the [Player] is currently on water.
var is_player_on_water: bool:
	get: return owner.party.player.ground_checkers.current_physics_layer == Utils.PhysicsLayer.WATER


## Called when the revealer is used on the surface below the player.
func reveal_surface():
	if owner.has_node(reveal_node_name):
		var reveal_node = owner.get_node(reveal_node_name)
		if reveal_node.is_current_surface_imaginary():
			change_rooms(reveal_node.next_room_id, reveal_node.next_room_entrance_node)
			return
	# play default dialogue
	actm.add_act(make_dialogue("default_reveal", "default"))
