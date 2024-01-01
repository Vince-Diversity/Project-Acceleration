class_name ThingStaticState extends ThingState
## Disables player interaction with [member ThingState.thing].


## Disables the interaction area of [member ThingState.thing],
## and ensures that its collision area is enabled.
func enter():
	thing.interact_area.set_disabled(true)
	thing.collision.set_deferred("disabled", false)


## Same as [method ThingsState.make_preserved_save].
func make_preserved_save(sg: SaveGame):
	super(sg)
