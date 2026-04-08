class_name SacredIndoorCutscene extends DialogueCutscene
## This cutscene may change depending on where the Sacred NPC is.

## Checks if Sacred is in the current party.
var is_sacred_joined: bool:
	get:
		if owner.party.has_member("Sacred"):
			return true
		else: return false
