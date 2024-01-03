class_name NPCJoinedState extends NPCState
## Lets this NPC follow the player as a [Party] member.


## Disables the [member Character.collision] of the NPC with this state.
## Also disables their [member NPC.interact_area] so that player interaction
## is disabled, and makes the NPC start following the player.
func enter():
	npc.collision.set_disabled(true)
	npc.interact_area.set_monitoring(false)
	npc.interact_area.set_monitorable(false)
	npc.set_deferred("is_following", true)


## Enables the [member Character.collision] of the NPC with this state.
## Also enables player interaction and sets [member NPC.is_following]
## to false for good measure.
func exit():
	super()
	npc.collision.set_disabled(false)
	npc.interact_area.set_monitoring(true)
	npc.interact_area.set_monitorable(true)
	npc.is_following = false


## Updates the direction of the NPC with this state to move
## towards the player or the next [Party] member,
## or plays their idle animation if the NPC is already next to them.
func roam():
	_set_following_direction()
	if npc.is_following:
		npc.move()
	else:
		npc.animate_idle()


func _set_following_direction():
	var next_member: Character = npc.room.party.get_next_member(npc)
	var direction: Vector2 = next_member.global_position - npc.global_position
	npc.set_direction(direction)


## Overrides the superclass with nothing so that no loading occurs,
## since NPCs are instantiated from their default scene when loaded into the [Party].
func load_save(_sg: SaveGame):
	pass
