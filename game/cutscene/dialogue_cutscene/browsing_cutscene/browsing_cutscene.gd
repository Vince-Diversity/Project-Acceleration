class_name BrowsingCutscene extends DialogueCutscene
## A cutscene containing properties for when the player is using items.


## Checks if the [Player] is currently on water.
var is_player_on_water: bool:
	get: return owner.party.player.ground_checkers.current_physics_layer == Utils.PhysicsLayer.WATER
