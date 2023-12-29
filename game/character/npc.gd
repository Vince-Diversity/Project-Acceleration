class_name NPC extends Character

@export var interaction_node: String
@export var dialogue_id: String
@export var dialogue_node: String
@export var preserved_direction: Utils.AnimID
@export var preserved_animation: String = ""
@export var is_imaginary: bool = false
@export_enum(
	"npc_still_state",
	"npc_joined_state") var spawn_state: String = "npc_still_state"
@onready var still_state: NPCStillState = \
	preload("res://game/character/npc_state/npc_still_state.gd").new("npc_still_state", self)
@onready var joined_state: NPCJoinedState = \
	preload("res://game/character/npc_state/npc_joined_state.gd").new("npc_joined_state", self)
@onready var interact_area = $InteractArea
var preserved_position: Vector2
var preserved_z_index : int
var state_list: Dictionary
var current_state: NPCState
var room: Room
var is_following: bool = false
var idling_room_id: String
var is_waiting_at_gateway: bool = false


func _ready():
	state_list[still_state.state_id] = still_state
	state_list[joined_state.state_id] = joined_state
	current_state = state_list[spawn_state]
	current_state.enter()


func make_npc(
		given_npc_state: String,
		given_room: Room):
	room = given_room
	change_state(given_npc_state)


func change_state(thing_state_id: String):
	current_state.exit()
	current_state = state_list[thing_state_id]
	current_state.enter()


func roam():
	current_state.roam()


func _set_following_direction():
	var next_member: Character = room.party.get_next_member(self)
	var direction: Vector2 = next_member.global_position - global_position
	set_direction(direction)


func _on_FollowingArea_area_entered(area: Area2D):
	if area == room.party.get_next_member(self).following_area:
		is_following = false


func _on_FollowingArea_area_exited(area: Area2D):
	if area == room.party.get_next_member(self).following_area:
		is_following = true


func make_save(sg: SaveGame):
	current_state.make_save(sg)


func make_preserved_save(sg: SaveGame):
	current_state.make_preserved_save(sg)


func load_save(sg: SaveGame):
	current_state.load_save(sg)


func exit_cutscene():
	preserved_position = global_position
	preserved_z_index = z_index
