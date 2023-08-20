class_name NPC extends Character

@export var interaction_node: String
@export var dialogue_id: String
@export var dialogue_node: String
@export var bubble_content: Bubble.Content
@export var preserved_direction: Utils.AnimID
@export_enum(
	"npc_still_state",
	"npc_joined_state") var spawn_state: String = "npc_still_state"
@onready var still_state: NPCStillState = \
	preload("res://game/character/npc_state/npc_still_state.gd").new("npc_still_state", self)
@onready var joined_state: NPCJoinedState = \
	preload("res://game/character/npc_state/npc_joined_state.gd").new("npc_joined_state", self)
@onready var interact_area = $InteractArea
var is_following: bool = false
var preserved_position: Vector2
var state_list: Dictionary
var current_state: NPCState


func _ready():
	state_list[still_state.state_id] = still_state
	state_list[joined_state.state_id] = joined_state
	current_state = state_list[spawn_state]
	current_state.enter()


func make_npc(given_party: Party, given_npc_state: String):
	party = given_party
	change_state(given_npc_state)


func change_state(thing_state_id: String):
	current_state.exit()
	current_state = state_list[thing_state_id]
	current_state.enter()


func roam():
	current_state.roam()


func _set_following_direction():
	var next_member: Character = party.get_next_member(self)
	var direction: Vector2 = next_member.global_position - global_position
	set_direction(direction)


func _on_FollowingArea_area_entered(area: Area2D):
	if area == party.get_next_member(self).following_area:
		is_following = false


func _on_FollowingArea_area_exited(area: Area2D):
	if area == party.get_next_member(self).following_area:
		is_following = true


func make_save(sg: SaveGame):
	current_state.make_save(sg)


func make_preserved_save(sg: SaveGame):
	current_state.make_preserved_state(sg)


func load_save(sg: SaveGame):
	current_state.load_save(sg)


func exit_cutscene():
	preserved_position = global_position
	preserved_direction = Utils.anim_direction[Utils.snap_to_compass(inputted_direction)]
