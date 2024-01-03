class_name NPCState extends GDScript
## Base class for NPC states

## The filename (without the extension) is used as ID for this class.
var state_id: String

## Reference to the NPC with this state.
var npc: NPC


## Initialises this class, assigning the ID [member state_id]
## and target [member npc].
func _init(given_state_id: String, given_npc: NPC):
	state_id = given_state_id
	npc = given_npc


## Called when this state becomes the current state.
func enter():
	pass


## Called when this state is removed as the current state.
func exit():
	pass


## Called when the player interacts with the given [Interactable] scene root.
func check_interaction(_interactable_scene: Node2D):
	pass


## Called at every frame to move of the NPC with this state.
func roam():
	pass


## Edits the given [code]sg[/code] to have the npc waiting at a gateway.
## Updates the save before loading it.
## Used for imaginary NPCs, see [NPC].
func go_back_waiting(sg: SaveGame):
	var npc_dict = sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key][npc.name]
	npc_dict[sg.interaction_key] = ""
	npc_dict[sg.dialogue_id_key] = "default_join"
	npc_dict[sg.dialogue_node_key] = "default"
	npc_dict[sg.position_key] = npc.global_position
	npc_dict[sg.direction_key] = npc.inputted_direction


## Saves the NPC with this state to the given [code]sg[/code].
func make_save(sg: SaveGame):
	sg.update_room_keys(npc.room.room_id)
	var npc_dict = {}
	sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key][npc.name] = npc_dict
	npc_dict[sg.interaction_key] = npc.interaction_node
	npc_dict[sg.dialogue_id_key] = npc.dialogue_id
	npc_dict[sg.dialogue_node_key] = npc.dialogue_node
	npc_dict[sg.position_key] = npc.global_position
	npc_dict[sg.direction_key] = npc.inputted_direction
	npc_dict[sg.anim_key] = npc.anim_sprite.animation
	npc_dict[sg.idling_room_key] = npc.idling_room_id
	npc_dict[sg.was_joined_key] = npc.is_waiting_at_gateway
	npc_dict[sg.z_index_key] = npc.z_index


## Saves the NPC with this state at a previous point in the game session to the given [code]sg[/code].
## The save is also such that the NPC does not get moved from its default [Room] and is not a party member.
func make_preserved_save(sg: SaveGame):
	var npc_dict = {}
	sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key][npc.name] = npc_dict
	npc_dict[sg.interaction_key] = npc.interaction_node
	npc_dict[sg.dialogue_id_key] = npc.dialogue_id
	npc_dict[sg.dialogue_node_key] = npc.dialogue_node
	npc_dict[sg.position_key] = npc.preserved_position
	npc_dict[sg.direction_key] = Utils.get_anim_direction(npc.preserved_direction)
	npc_dict[sg.anim_key] = npc.preserved_animation
	npc_dict[sg.idling_room_key] = ""
	npc_dict[sg.was_joined_key] = false
	npc_dict[sg.z_index_key] = npc.preserved_z_index


## Loads the NPC with this state from the given [code]sg[/code].
func load_save(sg: SaveGame):
	if sg.data[sg.rooms_key].has(npc.room.room_id):
		var npc_dict = sg.data[sg.rooms_key][npc.room.room_id][sg.npcs_key][npc.name]
		npc.interaction_node = npc_dict[sg.interaction_key]
		npc.dialogue_id = npc_dict[sg.dialogue_id_key]
		npc.dialogue_node = npc_dict[sg.dialogue_node_key]
		npc.set_global_position(npc_dict[sg.position_key])
		npc.set_direction(npc_dict[sg.direction_key])
		npc.update_direction()
		npc.set_animation(npc_dict[sg.anim_key])
		npc.idling_room_id = npc_dict[sg.idling_room_key]
		npc.is_waiting_at_gateway = npc_dict[sg.was_joined_key]
		npc.set_z_index(npc_dict[sg.z_index_key])
