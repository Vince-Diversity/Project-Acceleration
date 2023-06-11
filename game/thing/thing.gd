class_name Thing extends StaticBody2D

@export var interaction_node: String
@export var dialogue_id: String
@export var dialogue_node: String
@export var is_oneshot: bool = false
@export var bubble_content: Bubble.Content
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact_area: CollisionShape2D = $InteractArea/CollisionShape2D
@onready var interactable_state: ThingInteractableState = \
	preload("res://game/thing/thing_state/thing_interactable_state.gd").new("thing_interactable_state", self)
@onready var static_state: ThingStaticState = \
	preload("res://game/thing/thing_state/thing_static_state.gd").new("thing_static_state", self)
var state_list: Dictionary
var current_state: ThingState

signal begin_interaction(thing: Thing)


func _ready():
	state_list[interactable_state.state_id] = interactable_state
	state_list[static_state.state_id] = static_state
	current_state = interactable_state
	interactable_state.enter()


func make_save(save_game: SaveGame):
	if not save_game.data.has("rooms"):
		save_game.data["rooms"] = {}
	if not save_game.data["rooms"].has(owner.room_id):
		save_game.data["rooms"][owner.room_id] = {}
		save_game.data["rooms"][owner.room_id]["things"] = {}
	save_game.data["rooms"][owner.room_id]["things"][name] = {}

	save_game.data["rooms"][owner.room_id]["things"][name]["current_state"] = current_state.state_id
	var thing_dict = save_game.data["rooms"][owner.room_id]["things"][name]
	thing_dict["current_anim"] = anim_sprite.animation
	thing_dict["current_frame"] = anim_sprite.frame


func load_save(save_game: SaveGame):
	if save_game.data["rooms"].has(owner.room_id):
		var thing_dict = save_game.data["rooms"][owner.room_id]["things"][name]
		change_state(thing_dict["current_state"])
		anim_sprite.set_animation(thing_dict["current_anim"])
		anim_sprite.set_frame(thing_dict["current_frame"])
		anim_sprite.play()


func set_rng(_thing_rng: RandomNumberGenerator):
	pass


func check_interaction(given_interactable: Node2D):
	current_state.check_interaction(given_interactable)


func change_state(thing_state_id: String):
	current_state.exit()
	current_state = state_list[thing_state_id]
	current_state.enter()


func _on_thing_end_interaction():
	if is_oneshot:
		change_state("thing_static_state")
