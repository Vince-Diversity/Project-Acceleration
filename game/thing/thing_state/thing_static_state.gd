class_name ThingStaticState extends ThingState
## Disables player interaction with a [Thing].


## Disables the interaction area of the thing with this state,
## and ensures that its collision area is enabled.
func enter():
	thing.interact_area.set_monitoring(false)
	thing.interact_area.set_monitorable(false)
	thing.collision.set_deferred("disabled", false)


## Same as [method ThingsState.make_preserved_save].
func make_preserved_save(sg: SaveGame):
	super(sg)
