class_name NPC extends Character

@export var interaction_node: String
@export var dialogue_id: String
@export var dialogue_node: String
@export var bubble_content: Bubble.Content
@export var preserved_direction: Utils.AnimID
var preserved_position: Vector2


func _ready():
	if anim_sprite.sprite_frames.has_animation(
			Utils.anim_name[preserved_direction]):
		set_direction(
			Utils.get_anim_direction(preserved_direction))
		update_direction()
	preserved_position = global_position


func make_save(sg: SaveGame):
	sg.update_room_keys(owner.room_id)
	var npc_dict = {}
	sg.data[sg.rooms_key][owner.room_id][sg.npcs_key][name] = npc_dict
	npc_dict[sg.interaction_key] = interaction_node
	npc_dict[sg.dialogue_id_key] = dialogue_id
	npc_dict[sg.dialogue_node_key] = dialogue_node
	npc_dict[sg.position_key] = global_position
	npc_dict[sg.direction_key] = inputted_direction


func make_preserved_save(sg: SaveGame):
		var npc_dict = {}
		sg.data[sg.rooms_key][owner.room_id][sg.npcs_key][name] = npc_dict
		npc_dict[sg.interaction_key] = interaction_node
		npc_dict[sg.dialogue_id_key] = dialogue_id
		npc_dict[sg.dialogue_node_key] = dialogue_node
		npc_dict[sg.position_key] = preserved_position
		npc_dict[sg.direction_key] = Utils.get_anim_direction(preserved_direction)


func load_save(sg: SaveGame):
	if sg.data[sg.rooms_key].has(owner.room_id):
		var npc_dict = sg.data[sg.rooms_key][owner.room_id][sg.npcs_key][name]
		interaction_node = npc_dict[sg.interaction_key]
		dialogue_id = npc_dict[sg.dialogue_id_key]
		dialogue_node = npc_dict[sg.dialogue_node_key]
		global_position = npc_dict[sg.position_key]
		set_direction(npc_dict[sg.direction_key])
		update_direction()


func exit_cutscene():
	preserved_position = global_position
	preserved_direction = Utils.anim_direction[Utils.snap_to_compass(inputted_direction)]
