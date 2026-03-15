extends SilentCutscene
## A transitional cutscene for entering [RestState] when the player is stuck in ice shards.

## Ice shards [Thing] node that the player is stuck in.
@export var ice_shards_node: Thing

## Name of [Cutscene] node to be created to play when the player to break free from the ice shards.
@export var ice_breakout_node_name: String = "IceBreakoutCutscene"

@onready var _ice_breakout_cutscene_scn = preload("res://game/cutscene/silent_cutscene/ice_breakout_cutscene/ice_breakout_cutscene.tscn")


func start_cutscene():
	next_state = "rest_state"
	var ice_breakout_cutscene = _ice_breakout_cutscene_scn.instantiate()
	owner.add_cutscene(ice_breakout_cutscene, ice_breakout_node_name)
	ice_breakout_cutscene.ice_shards_node = ice_shards_node
	set_thing_state(
		ice_shards_node.name,
		"thing_permeable_state")
	owner.party.player.anim_sprite.set_animation("leap")
	owner.party.player.anim_sprite.set_frame(0)
	owner.rest_state.make_state(
		ice_breakout_node_name,
		ice_shards_node)
