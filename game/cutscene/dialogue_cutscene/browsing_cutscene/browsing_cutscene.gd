class_name BrowsingCutscene extends DialogueCutscene
## A cutscene containing properties for when the player is using items.
##
## This cutscene has toggles for what physics layer is on.
## Also, the player can use the revealer on the surface below the player
## by calling a [Cutscene] with the node name [member reveal_cutscene_name].

const reveal_cutscene_node_name: String = "Reveal"

## Toggle for enabling revealing the surface below the player.
var is_revealing_surface: bool = false

## Checks if the [Player] is currently on water.
var is_player_on_water: bool:
	get: return owner.party.player.ground_checkers.current_physics_layer == Utils.PhysicsLayer.WATER


## Called when the revealer is used on the surface below the player.
func reveal_surface():
	if owner.cutscenes.has_node(reveal_cutscene_node_name):
		# change cutscene node to revealer cutscene
		# pass the remaining acts to the new cutscene
		# should be safe when restricted to browsing dialogue
		var temp_actm = owner.cutscenes.current_cutscene.actm
		owner.cutscenes.change_cutscenes(reveal_cutscene_node_name)
		owner.cutscenes.current_cutscene.actm = temp_actm
		# run revealer cutscene
		if owner.cutscenes.current_cutscene.reveal():
			change_rooms(owner.cutscenes.current_cutscene.next_room_id, owner.cutscenes.current_cutscene.next_room_entrance_node)
