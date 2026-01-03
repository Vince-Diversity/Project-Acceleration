class_name Player extends Character
## The character who is controlled by the player.
##
## The player character can interact with [Interactable] scenes in the environment
## using the player [member interact_area]. This area is different from other [Interactable]
## areas in that it only extends in front of the player and turns with the player.
## [br]
## [br]
## Also, the player character makes thought bubbles to signify when the player can
## make something in the game happen. These thought bubbles are managed by the
## [Bubbles] child node. When the player has obtained an item in their [Items] list,
## thought bubbles are also used to select items.

# The player character speed during ordinary state.
@export var ordinary_speed: float

# The player character speed during skating state.
@export var skating_speed: float

# The periodic distrance travelled to spawn new ice during skating state.
@export var skating_ice_wavelength: float

# The duration of spawned ice during skating state.
@export var skating_ice_lifetime: float

@onready var _direction_node: Marker2D = $Direction

@onready var _skating_ice_mark: Marker2D = $SkatingIceMark

## Reference to the interaction area of the player.
@onready var interact_area: Area2D = $Direction/InteractArea

## Reference to the bubbles child node.
@onready var bubbles: Bubbles = $Bubbles

@onready var _ordinary_state: PlayerOrdinaryState = \
	preload("res://game/character/player/player_state/player_ordinary_state.gd").new("player_ordinary_state", self)

@onready var _skating_state: PlayerSkatingState = \
	preload("res://game/character/player/player_state/player_skating_state.gd").new("player_skating_state", self)

@onready var _skating_ice_scn: PackedScene = \
	preload("res://game/vfx/skates/skating_ice.tscn")

## The [Interactable] scene root that is closest to the player.
## Is automatically updated at every frame.
## Also updates the [member Bubbles.current_state] accordingly.
var nearest_interactable: Node2D:
	set(interactable):
		nearest_interactable = interactable
		_set_nearest_interactable(interactable)

## Defaull [NPCState] when this NPC is added to the [SceneTree].
var spawn_state: String = "player_ordinary_state"

## List of [PlayerState] instances labeled by each respective [member PlayerState.state_id].
var state_list: Dictionary

## Current activated NPC state instance.
var current_state: PlayerState

## Emitted when the player interacts with the given [Interactable] scene root.
signal player_interacted(interactable_scene: Node2D)

## Emitted when the player starts browsing through obtained items.
signal browsing_started

## Emitted when the player stops browsing through obtained items.
signal browsing_ended

## Emitted when the player creates a visual effect.
signal vfx_created(vfx_scene: Node2D)


func _ready():
	state_list[_ordinary_state.state_id] = _ordinary_state
	state_list[_skating_state.state_id] = _skating_state
	current_state = state_list[spawn_state]
	current_state.enter()
	_update_angle()
	player_interacted.connect(_on_player_interacted)


## Initialises the player before it is added to the [SceneTree].
func init_player(
		given_party: Party,
		player_interacted_target: Callable,
		browsing_started_target: Callable,
		browsing_ended_target: Callable,
		vfx_created_target: Callable):
	party = given_party
	player_interacted.connect(player_interacted_target)
	browsing_started.connect(browsing_started_target)
	browsing_ended.connect(browsing_ended_target)
	browsing_ended.connect(_on_browsing_ended)
	vfx_created.connect(vfx_created_target)


## Further initialises the player after it is added to the [SceneTree].
func make_player(
		idle_bubbles_selected_target: Callable,
		interact_bubbles_selected_target: Callable):
	bubbles.idle_bubbles_selected.connect(idle_bubbles_selected_target)
	bubbles.interact_bubbles_selected.connect(interact_bubbles_selected_target)
	bubbles.make_bubbles(self)
	items.make_items(self)


## Changes the [member current_state] to the given [code]player_state_id[/code].
func change_states(player_state_id: String):
	current_state.exit()
	current_state = state_list[player_state_id]
	current_state.enter()


## Updated at every frame to enable player movement.
## Reads the currently inputted direction and moves the player accordingly,
## or plays their idle animation if no movement is inputted.
## Also updates the [member nearest_interactable].
func roam(delta: float):
	_update_input_direction()
	if inputted_direction == Vector2.ZERO:
		current_state.animate_idle()
	else:
		current_state.move(delta)
	_check_nearest_interactable()


## Moves the player depending on the player state 
## and updates the angle of the player's interaction area.
func move(delta: float):
	current_state.move(delta)
	_update_angle()


## Updates the player's direction and the angle of the player's interaction area.
func update_direction():
	super()
	_update_angle()


func _update_angle():
	_direction_node.rotation = Utils.snap_to_compass(inputted_direction).angle()


func _update_input_direction():
	inputted_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")


func _check_nearest_interactable():
	var areas: Array[Area2D] = interact_area.get_overlapping_areas()
	if areas.is_empty():
		nearest_interactable = null
	else:
		var shortest_distance: float = INF
		var next_nearest_interactable: Node2D
		for area in areas:
			var distance = area.global_position.distance_to(global_position)
			if distance < shortest_distance:
				shortest_distance = distance
				next_nearest_interactable = area.owner
		if next_nearest_interactable != nearest_interactable:
			nearest_interactable = next_nearest_interactable


## Begins a player interaction with the [member nearest_interactable].
func check_interaction():
	if is_instance_valid(nearest_interactable):
		player_interacted.emit(nearest_interactable)


func _set_nearest_interactable(new_interactable: Node2D):
	if is_instance_valid(new_interactable):
		bubbles.try_change_states("bubbles_interact_state")
	else:
		bubbles.try_change_states("bubbles_idle_state")


## Begins a [BrowseState] if the player has any obtained items.
func check_stored_items():
	if not items.item_id_list.is_empty():
		browsing_started.emit()


## True if the player has the item with the given [code]item_id[/code].
func has_item(given_item_id):
	return items.item_id_list.has(given_item_id)


## Adds a thought bubble from the [member Items.item_id_list]
## if the player has any obtained items.
func make_item_bubble():
	if not items.item_id_list.is_empty():
		bubbles.add_item_bubble(
			items.item_id_list[bubbles.current_state.current_item_index],
			items.item_id_list.size())


## Closes any item thought bubbles.
func close_item_bubble():
	bubbles.item_bubble.close()


## Add one skating ice visual effect instance below the player.
func add_skating_ice():
	var skating_ice = _skating_ice_scn.instantiate()
	skating_ice.init_vfx(_skating_ice_mark.global_position, skating_ice_lifetime)
	vfx_created.emit(skating_ice)


## Called when the player interacts with the given [Interactable] scene root, if that exists.
func _on_player_interacted(_interactable_scene: Node2D):
	set_deferred("nearest_interactable", null)


## Called when a [BrowseState] finishes.
func _on_browsing_ended():
	bubbles.reset_bubbles()
