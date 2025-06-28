class_name OuroborosCutscene extends DialogueCutscene
## This cutscene may change depending on if the player skipped getting introduced to Ouroboros.

## Checks if Sacred is in the current party.
var is_ouroboros_joined: bool:
	get:
		if owner.party.player.has_item("ouroboros"):
			return true
		else: return false
