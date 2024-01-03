class_name Thing extends StaticBody2D
## Base scene for interactable objects in the environment.
##
## A thing is part of the environment in the current [Room] instance that,
## unlike tiles in the [TileMap] of that room, has player interaction.
## Interaction is enabled when the [member current_state] is a
## [ThingInteractableState] instance, or disabled when it is a
## [ThingStaticState] instance.

## Node name of the desired [Cutscene]. Optionally, a default cutscene is used if this field remains empty.
@export var interaction_node: String

## Filename of the [DialogueResource] containing the desired dialogue.
@export var dialogue_id: String

## Title of the desired dialogue, see [method DialogueResource.get_next_dialogue_line].
@export var dialogue_node: String

## After interacted with once, toggles if this thing can be interacted with again.
@export var is_oneshot: bool = false

## Player animation when resting on this thing, if an interaction
## leading to a [RestCutscene] exists.
@export var rest_animation: String = "default"

## Toggles whether the [code]z_index[/code] of characters need to be changed
## during a [RestCutscene], if that exists.
@export var elevate_characters: bool = false

## Default [ThingState] when this thing is added to the [SceneTree].
@export_enum(
	"thing_interactable_state",
	"thing_static_state") var spawn_state_id: String = "thing_interactable_state"

## Reference to the sprite of this thing.
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

## Reference to the interaction area of of this thing.
@onready var interact_area: Interactable = $InteractArea

## Reference to the collision area of this thing.
@onready var collision: CollisionShape2D = $CollisionShape2D

## Reference to the current room instance.
@onready var room: Room = owner

@onready var _interactable_state: ThingInteractableState = \
	preload("res://game/thing/thing_state/thing_interactable_state.gd").new("thing_interactable_state", self)
@onready var _static_state: ThingStaticState = \
	preload("res://game/thing/thing_state/thing_static_state.gd").new("thing_static_state", self)
@onready var _permeable_state: ThingPermeableState = \
	preload("res://game/thing/thing_state/thing_permeable_state.gd").new("thing_permeable_state", self)

## List of [ThingState] instances labeled by each respective [member ThingState.state_id].
var state_list: Dictionary

## Current active thing state instance.
var current_state: ThingState

## ID of thing state after the last [CutsceneState] ended.
var preserved_state_id: String = spawn_state_id

## AnimatedSprite2D.animation after the last [CutsceneState] ended.
var preserved_anim_name: String = "default"


func _ready():
	state_list[_interactable_state.state_id] = _interactable_state
	state_list[_static_state.state_id] = _static_state
	state_list[_permeable_state.state_id] = _permeable_state
	current_state = state_list[spawn_state_id]
	current_state.enter()


## Saves this thing to the given [code]sg[/code].
func make_save(sg: SaveGame):
	current_state.make_save(sg)


## Saves this thing at a previous point in the game session to the given [code]sg[/code].
func make_preserved_save(sg: SaveGame):
	current_state.make_preserved_save(sg)


## Loads this thing from the given [code]sg[/code].
func load_save(sg: SaveGame):
	if sg.data[sg.rooms_key].has(room.room_id):
		var thing_dict = sg.data[sg.rooms_key][room.room_id][sg.things_key][name]
		change_states(thing_dict[sg.state_key])
		anim_sprite.set_animation(thing_dict[sg.anim_key])
		anim_sprite.set_frame(thing_dict[sg.frame_key])
		anim_sprite.play()


## Used to implement any RNG behaviour of this thing.
func set_rng(_thing_rng: RandomNumberGenerator):
	pass


## Changes the [member current_state] to the given [code]thing_state_id[/code].
func change_states(thing_state_id: String):
	current_state.exit()
	current_state = state_list[thing_state_id]
	current_state.enter()


## Called when a [CutsceneState] ends.
func exit_cutscene():
	preserved_state_id = current_state.state_id
	preserved_anim_name = anim_sprite.animation
