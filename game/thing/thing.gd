class_name Thing extends StaticBody2D

@export var interaction_node: String
@export var dialogue_id: String
@export var dialogue_node: String
@export var is_oneshot: bool = false
@export var rest_animation: String = "default"
@export var elevate_characters: bool = false
@export_enum(
	"thing_interactable_state",
	"thing_static_state") var spawn_state: String = "thing_interactable_state"
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact_area: CollisionShape2D = $InteractArea/CollisionShape2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var interactable_state: ThingInteractableState = \
	preload("res://game/thing/thing_state/thing_interactable_state.gd").new("thing_interactable_state", self)
@onready var static_state: ThingStaticState = \
	preload("res://game/thing/thing_state/thing_static_state.gd").new("thing_static_state", self)
@onready var permeable_state: ThingPermeableState = \
	preload("res://game/thing/thing_state/thing_permeable_state.gd").new("thing_permeable_state", self)
var state_list: Dictionary
var current_state: ThingState
var room: Room = owner


func _ready():
	state_list[interactable_state.state_id] = interactable_state
	state_list[static_state.state_id] = static_state
	state_list[permeable_state.state_id] = permeable_state
	current_state = state_list[spawn_state]
	current_state.enter()


func make_thing(given_room: Room):
	room = given_room


func make_save(sg: SaveGame):
	sg.update_room_keys(room.room_id)
	var thing_dict = {}
	sg.data[sg.rooms_key][room.room_id][sg.things_key][name] = thing_dict
	thing_dict[sg.state_key] = current_state.state_id
	thing_dict[sg.anim_key] = anim_sprite.animation
	thing_dict[sg.frame_key] = anim_sprite.frame


func make_preserved_save(sg: SaveGame):
	current_state.make_preserved_save(sg)


func load_save(sg: SaveGame):
	if sg.data[sg.rooms_key].has(room.room_id):
		var thing_dict = sg.data[sg.rooms_key][room.room_id][sg.things_key][name]
		change_state(thing_dict[sg.state_key])
		anim_sprite.set_animation(thing_dict[sg.anim_key])
		anim_sprite.set_frame(thing_dict[sg.frame_key])
		anim_sprite.play()


func set_rng(_thing_rng: RandomNumberGenerator):
	pass


func change_state(thing_state_id: String):
	current_state.exit()
	current_state = state_list[thing_state_id]
	current_state.enter()
