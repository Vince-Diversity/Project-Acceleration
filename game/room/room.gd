class_name Room extends Node2D
## Base class for the current environment of a game session.
##
## Scenes of the subclasses of this node are used to build the game world.
## When selecing which room scene to load, the [member room_id] property is used as an identifier.
## Each scene has a [TileMap] for mapping and [Door] instances for spawn and exit points.
## The [Player] is a child of the [Party] node and [NPC] instances are either children of
## the [code]NPCs[/code] node or, when the npc is a party member, the [code][Party][/code] node.
## Also, [Thing] instances in the environment are added as children of the [code]Things[/code] node.
## [br]
## [br]
## Subclasses of [Cutscene] nodes can be added as children to the
## [RoomCutscenes] node to enable custom cutscenes.
## Optionally, for cutscenes that emerge from interaction with
## a [Thing] or [NPC], if no matching cutscene is added a default cutscene
## instance will be added automatically.
## [br]
## [br]
## Party members are always added when the room scene is added to the [SceneTree].
## All other children can be added manually to the scene using the Godot editor.
## When the contents of the environment are changed, which can for example happen during cutscenes,
## the changes are stored in the [member Game.cache], and the next time
## the same room scene is entered those changes will update the room scene.
## This means that the scene that is built from the editor becomes the default room instance,
## and the actual encountered environment during a game session is an updated version of that room.

## Path to the playing background music.
@export_file var bgm_file: String

## Reference to [Party] child node.
@onready var party = $YSort/Party

## Reference to [code]NPCs[/code] child node.
@onready var npcs = $YSort/NPCs

@onready var _cutscenes = $RoomCutscenes
@onready var _things = $YSort/Things
@onready var _doors = $Doors
@onready var _roam_state: RoamState = preload("res://game/game_state/roam_state.gd").new("roam_state")
@onready var _cutscene_state: CutsceneState = preload("res://game/game_state/cutscene_state.gd").new("cutscene_state")
@onready var _rest_state: RestState = preload("res://game/game_state/rest_state.gd").new("rest_state")
@onready var _browse_state: BrowseState = preload("res://game/game_state/browse_state.gd").new("browse_state")
@onready var _dialogue_cutscene_scn: PackedScene = preload("res://game/cutscene/dialogue_cutscene.tscn")

## The filename (without the extension) is used as ID for this class.
var room_id: String

## Current RNG instance for [Thing] nodes.
var thing_rng: RandomNumberGenerator

## Name of the current entrance node, representing a spawn point.
var entrance_node: String

## Current spawn point node.
var entrance: Door

## Reference to current game session state manager.
var stm: StateMachine

## Reference to current background music player.
var bgm: AudioStreamPlayer

## Reference to the current transition screen instance.
var screen: Screen

## Function that starts a [TextBox].
var textbox_started_target: Callable

## Target function when a [CutsceneState] ends.
var cutscene_ended_target: Callable

## Function that sets focus on the current [TextBox].
var textbox_focused_target: Callable

## Emitted when exiting the current room
## and entering the room with filename [code]next_room_id[/code]
## at the spawn point with node name [next_room_entrance_node].
signal room_changed(next_room_id: String, next_room_entrance_node: String)

## Emitted when the [Player] interacts with the given [code]interactable[/code].
signal player_interacted(interactable: Interactable)

## Emitted when an [Interactable] finishes an interaction.
signal end_interaction()

## Emitted when the entrance event for the room with file name [code]room_id[/code]
## is toggled accordingly to [code]is_enabled[/code].
signal entrance_event_edited(room_id: String, is_enabled: bool)

## Emitted when an [NPC] with node name [code]npc_name[/code] is freed.
signal npc_removed(npc_name: String)


func _ready():
	_ready_entrance()
	_ready_doors()
	_ready_things()
	_ready_npcs()
	_ready_states()
	_ready_cutscenes()
	stm.change_state(_roam_state.state_id)


func _ready_entrance():
	if _doors.get_child_count() == 0:
		room_changed.emit("main_entrance", "DefaultDoor")
		return
	if _doors.has_node(entrance_node):
		entrance = _doors.get_node(entrance_node)
	else:
		entrance = _doors.get_children()[0]
	party.set_global_position(entrance.spawn_point.global_position)


func _ready_doors():
	for door in _doors.get_children():
		door.make_thing(self)
		var door_interactable = door.get_node("InteractArea")
		player_interacted.connect(door_interactable.check_interaction)
		door_interactable.begin_interaction.connect(_on_door_begin_interaction)


func _ready_things():
	thing_rng = RandomNumberGenerator.new()
	var thing_seed = Utils.str_to_seed(name)
	thing_rng.set_seed(thing_seed)
	for thing in _things.get_children():
		thing.make_thing(self)
		var thing_interactable = thing.get_node("InteractArea")
		player_interacted.connect(thing_interactable.check_interaction)
		thing_interactable.begin_interaction.connect(_on_begin_interaction)
		thing.set_rng(thing_rng)


func _ready_npcs():
	for npc in npcs.get_children():
		npc.make_npc("npc_still_state", self)


func _ready_states():
	_roam_state.init_state(party)
	stm.add_state(_roam_state)
	_cutscene_state.init_state(_cutscenes)
	stm.add_state(_cutscene_state)
	_rest_state.init_state(start_cutscene)
	stm.add_state(_rest_state)
	_browse_state.init_state(party)
	stm.add_state(_browse_state)


func _ready_cutscenes():
	for cutscene in _cutscenes.get_children():
		_make_cutscene(cutscene)


func _make_cutscene(cutscene: Cutscene):
	cutscene.init_cutscene(_cutscenes, screen)
	cutscene.cutscene_started.connect(
		_on_cutscene_started)
	cutscene.cutscene_ended.connect(cutscene_ended_target)


## Initialises this node before it is added to the [SceneTree].
func init_room(
		given_room_id: String,
		given_entrance_node: String,
		given_stm: StateMachine,
		given_bgm: BGMPlayer,
		given_screen: Screen,
		change_room_target: Callable,
		given_textbox_started_target: Callable,
		given_cutscene_ended_target: Callable,
		given_textbox_focused_target: Callable,
		given_entrance_event_edited_target: Callable,
		npc_removed_target: Callable):
	room_id = given_room_id
	entrance_node = given_entrance_node
	stm = given_stm
	bgm = given_bgm
	bgm.update_stream(bgm_file)
	screen = given_screen
	room_changed.connect(change_room_target, CONNECT_DEFERRED)
	textbox_started_target = given_textbox_started_target
	cutscene_ended_target = given_cutscene_ended_target
	textbox_focused_target = given_textbox_focused_target
	entrance_event_edited.connect(given_entrance_event_edited_target)
	npc_removed.connect(npc_removed_target)


## Updates the current cutscene in [RoomCutscenes] and
## changes the game session state to [CutsceneState].
## The node name of this cutscene is given by [code]interaction_node[/code]
## and it needs to have be added to the [SceneTree] before this function is called.
## Also, [code]source_node[/code] is a required node that relates the most to the current cutscene,
## see [member RoomCutscenes.current_source_node].
## If the cutscene has dialogue, the dialogue contents are given by the
## filename of the [DialogueResource], [code]dialogue_id[/code], and
## title to the [method DialogueResource.get_next_dialogue_line], [code]dialogue_node[/code].
func start_cutscene(
		interaction_node: String,
		dialogue_id: String,
		dialogue_node: String,
		source_node: Node2D):
	_cutscenes.change_cutscene(interaction_node)
	_cutscenes.change_dialogue(dialogue_id, dialogue_node)
	_cutscenes.change_source_node(source_node)
	_cutscenes.current_cutscene.cutscene_started.emit()
	stm.change_state(_cutscene_state.state_id)
	end_interaction.connect(source_node.get_node("InteractArea")._on_end_interaction, CONNECT_ONE_SHOT)


## Adds a [Cutscene] instance to the [SceneTree]
## and ensures that the node name of this cutscene is unique in the current game session.
## Optionally, the [PackedScene] of a subclass of [Cutscene] can be given
## as [code]cutscene_scn[/code].
## By default, a [DialogueCutscene] is instantiated.
func add_unique_cutscene(cutscene_scn: PackedScene = _dialogue_cutscene_scn) -> String:
	# When using this, wait for the cutscene node to be added before starting the cutscene
	var dlg_cutscene: Cutscene = cutscene_scn.instantiate()
	var interaction_node = "Default%s" % _cutscenes.get_children().size()
	add_cutscene(dlg_cutscene, interaction_node)
	return interaction_node


## Adds the given [code]cutscene[/code] to the [SceneTree]
## and assigns the node name [code]interaction_node[/code] to it.
func add_cutscene(cutscene: Cutscene, interaction_node: String):
	if not _cutscenes.has_node(interaction_node):
		_cutscenes.add_child(cutscene)
		cutscene.owner = self
		_make_cutscene(cutscene)
		cutscene.name = interaction_node


func _remove_members_at_gateway(door: Door):
	for member in party.get_members_ordered():
		if member.is_imaginary and door.is_gateway:
			party.remove_member(member)
			member.is_waiting_at_gateway = true


## Adds the [NPC] with the given filename [code]npc_id[/code] to the [SceneTree].
func create_npc(npc_id: String):
	var npc = load(Utils.get_npc_path(npc_id)).instantiate()
	npcs.add_child(npc)
	npc.make_npc(npc.spawn_state, self)
	npc.idling_room_id = room_id


## Frees the [NPC] with the given node name [code]npc_node[/code].
func remove_npc(npc_node: String):
	var npc = npcs.get_node(npc_node)
	npc_removed.emit(npc.name)
	npc.queue_free()


## Changes to a room with filename [code]next_room_id[/code]
## at the spawn point with node name [next_room_entrance_node].
func change_room(next_room_id: String, next_room_entrance_node: String):
	room_changed.emit(next_room_id, next_room_entrance_node)


## Called when the player interacts with the given [code]interactable[/code].
func _on_player_interacted(interactable: Interactable):
	player_interacted.emit(interactable)


## Called when an interaction with the given [Interactable] scene root [code]target_root[/code] starts.
## If [code]target_root[/code] does not have an assigned [member Interactable.interaction_node],
## a unique [code]interaction_node[/code] name is assigned.
func _on_begin_interaction(target_root: Node2D):
	if _cutscenes.has_node(target_root.interaction_node):
		start_cutscene(
			target_root.interaction_node,
			target_root.dialogue_id,
			target_root.dialogue_node,
			target_root)
	else:
		var cutscene_node = add_unique_cutscene()
		target_root.interaction_node = cutscene_node
		_on_begin_interaction.call_deferred(target_root)


## Called when the player interacts with the given [code]door[/code].
## If the door is linked to a room, the current room is changed to that
## and any existing interaction is skipped.
## Handles cases where party members are not intended to pass the door
func _on_door_begin_interaction(door: Door):
	var room_path = Utils.get_room_path(door.next_room_id)
	if FileAccess.file_exists(room_path):
		_remove_members_at_gateway(door)
		change_room(door.next_room_id, door.next_room_entrance_node)
	else:
		_on_begin_interaction(door)


## Starts the current [Cutscene].
func _on_cutscene_started():
	_cutscenes.current_cutscene.make()


## Changes the current game session state to [BrowseState].
func _on_browsing_started():
	stm.change_state("browse_state")


## Called when a [BrowseState] game session state ends.
func _on_browsing_ended():
	stm.change_state("roam_state")


## Starts a cutscene about examining the current item
## [member Bubbles.item_bubble.current_item_sprite].
func _on_idle_bubbles_selected():
	_cutscenes.add_cutscene(_dialogue_cutscene_scn, _browse_state.browsing_cutscene_name)
	start_cutscene(
		_browse_state.browsing_cutscene_name,
		"browse_items",
		party.player.get_thought_item_sprite().browse_dialogue_node,
		party.player.items.exhibit_item)


## Starts a cutscene about using the current item
## [member Bubbles.item_bubble.current_item_sprite]
## on the current interactable [member Player.nearest_interactable].
func _on_interact_bubbles_selected(item_id: String, interactable_name: String):
	if not _cutscenes.item_interact_cutscenes.has(item_id):
		_cutscenes.item_interact_cutscenes[item_id] = {}
	var item_dict = _cutscenes.item_interact_cutscenes[item_id]
	if not item_dict.has(interactable_name):
		item_dict[interactable_name] = add_unique_cutscene()
	start_cutscene(
		item_dict[interactable_name],
		party.player.nearest_interactable.dialogue_id,
		party.player.get_thought_item_sprite().interaction_dialogue_node,
		party.player.nearest_interactable)
