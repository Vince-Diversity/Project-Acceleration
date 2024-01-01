class_name ThingPermeableState extends ThingState
## Enables the player to move through [member ThingState.thing],
## which can be useful for a cutscene.


## Disables the collision area of [member ThingState.thing],
## and ensures that its interaction area is enabled, for good measure.
func enter():
	thing.interact_area.set_disabled(false)
	thing.collision.set_deferred("disabled", true)


## Saves default properties of [member ThingState.thing] to the given [code]sg[/code],
## which makes it compatible with saving during a [RestState].
## This works as long as the things that are used for that state
## keep the same behaviour as when first added to the [SceneTree].
func make_preserved_save(sg: SaveGame):
	super(sg)
	var thing_dict = sg.data[sg.rooms_key][thing.owner.room_id][sg.things_key][thing.name]
	thing_dict[sg.state_key] = thing.spawn_state_id
	thing_dict[sg.anim_key] = "default"
	thing_dict[sg.frame_key] = 0
