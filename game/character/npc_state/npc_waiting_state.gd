class_name NPCWaitingState extends NPCState
## Implements smoother ways for an [NPC] to rejoin the party after the player returns.
##
## Assumes that an NPC has been in [NPCStillState] before changing to this state.
## That means the NPC does not need to be loaded from the current save instance again.


## Makes sure there is connected interaction signals to the NPC with this state.
func enter():
	if is_instance_valid(npc.room):
		Utils.try_connect(npc.room.player_interacted, check_interaction)
		Utils.try_connect(npc.interact_area.begin_interaction, npc.room._on_begin_interaction)


## Toggles NPC waiting to false in the current instance of [SaveGame].
## Disconnects interaction signals to the NPC with this state if those signals are connected.
func exit():
	npc.is_waiting_at_gateway = false
	Utils.try_disconnect(npc.room.player_interacted, check_interaction)
	Utils.try_disconnect(npc.interact_area.begin_interaction, npc.room._on_begin_interaction)


## Checks if the NPC with this state is the desired [code]interactable_scene[/code].
## If so the NPC rejoins the party.
func check_interaction(interactable_scene: Node2D):
	if interactable_scene == npc:
		npc.room.party.add_npc_as_member(npc)


## Overrides the superclass with nothing so that no loading occurs,
## because the default NPC scene loader has already loaded the NPC
## before changing to this waiting state.
func load_save(_sg: SaveGame):
	pass
