class_name ThingState extends GDScript
## Base class for [Thing] states.


## The filename (without the extension) is used as ID for this class.
var state_id: String

## Reference to the thing with this state.
var thing: Thing


## Initialises this class, assigning the ID [member state_id]
## and target [member thing].
func _init(given_state_id: String, given_thing: Thing):
	state_id = given_state_id
	thing = given_thing


## Called when this state becomes the current state.
func enter():
	pass


## Called when this state is removed as the current state.
func exit():
	pass


## Called when the player interacts with the given [Interactable] scene root.
func check_interaction(_interactable_scene: Node2D):
	pass


## Saves the thing with this state to the given [code]sg[/code].
func make_save(sg: SaveGame):
	sg.update_room_keys(thing.owner.room_id)
	var thing_dict = {}
	sg.data[sg.rooms_key][thing.owner.room_id][sg.things_key][thing.name] = thing_dict
	thing_dict[sg.state_key] = thing.current_state.state_id
	thing_dict[sg.anim_key] = thing.anim_sprite.animation
	thing_dict[sg.frame_key] = thing.anim_sprite.frame


## Saves this thing at a previous point in the game session to the given [code]sg[/code].
## The animation of the target thing is saved at frame 0.
func make_preserved_save(sg: SaveGame):
	sg.update_room_keys(thing.owner.room_id)
	var thing_dict = {}
	sg.data[sg.rooms_key][thing.owner.room_id][sg.things_key][thing.name] = thing_dict
	thing_dict[sg.state_key] = thing.preserved_state_id
	thing_dict[sg.anim_key] = thing.preserved_anim_name
	thing_dict[sg.frame_key] = 0
