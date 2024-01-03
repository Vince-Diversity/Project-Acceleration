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


@onready var _direction_node: Marker2D = $Direction

## Reference to the interaction area of the player.
@onready var interact_area: Area2D = $Direction/InteractArea

## Reference to the bubbles child node.
@onready var bubbles: Bubbles = $Bubbles

## The [Interactable] scene root that is closest to the player.
## Is automatically updated at every frame.
## Also updates the [member Bubbles.current_state] accordingly.
var nearest_interactable: Node2D:
	set(interactable):
		nearest_interactable = interactable
		_set_nearest_interactable(interactable)

## Emitted when the player interacts with the given [Interactable] scene root.
signal player_interacted(interactable_scene: Node2D)

## Emitted when the player starts browsing through obtained items.
signal browsing_started

## Emitted when the player stops browsing through obtained items.
signal browsing_ended


func _ready():
	_update_angle()
	player_interacted.connect(_on_player_interacted)


## Initialises the player before it is added to the [SceneTree].
func init_player(
		given_party: Party,
		player_interacted_target: Callable,
		browsing_started_target: Callable,
		browsing_ended_target: Callable):
	party = given_party
	player_interacted.connect(player_interacted_target)
	browsing_started.connect(browsing_started_target)
	browsing_ended.connect(browsing_ended_target)
	browsing_ended.connect(_on_browsing_ended)


## Further initialises the player after it is added to the [SceneTree].
func make_player(
		idle_bubbles_selected_target: Callable,
		interact_bubbles_selected_target: Callable):
	bubbles.idle_bubbles_selected.connect(idle_bubbles_selected_target)
	bubbles.interact_bubbles_selected.connect(interact_bubbles_selected_target)
	bubbles.make_bubbles(self)


## Updated at every frame to enable player movement.
## Reads the currently inputted direction and moves the player accordingly,
## or plays their idle animation if no movement is inputted.
## Also updates the [member nearest_interactable].
func roam():
	_update_input_direction()
	if inputted_direction == Vector2.ZERO:
		animate_idle()
	else:
		move()
	_check_nearest_interactable()


## Moves the player and updates the angle of the player's interaction area.
func move():
	super()
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


## Adds a thought bubble starting on the first entry of [member Items.item_id_list]
## if the player has any obtained items.
func make_item_bubble():
	if not items.item_id_list.is_empty():
		bubbles.add_item_bubble(items.item_id_list[0])


## Closes any item thought bubbles.
func close_item_bubble():
	bubbles.item_bubble.close()


## Gets the item sprite of the current thought bubble, possibly null.
func get_thought_item_sprite() -> ItemSprite:
	return bubbles.item_bubble.current_item_sprite


## Called when the player interacts with the given [Interactable] scene root, if that exists.
func _on_player_interacted(_interactable_scene: Node2D):
	set_deferred("nearest_interactable", null)


## Called when a [BrowseState] finishes.
func _on_browsing_ended():
	bubbles.reset_bubbles()
