class_name Cutscene extends Node2D
## Base scene for creating cutscenes.
##
## A cutscene is a temporary game event which consists of a series of
## predetermined [Act] instances. The [member actm] manages acts and is initialised
## when this cutscene is added to the [SceneTree].
## [br]
## [br]
## A cutscene can be built by coding acts either in cutscene subclasses
## or in [DialogueResource] instances.
## The former way is useful for creating cutscenes which do not have any
## dialogue. A subscene of [SilentCutscene] is used for such a cutscene, where a list of acts
## is created by a call to [method make] when the cutscene starts.
## The latter way allows new acts to be added gradually to this cutscene
## as the outcome of a dialogue evolves. These are subscenes of [DialogueCutscene].

## The act manager of this cutscene.
@onready var actm := ActManager.new(end_cutscene)

@onready var _move_to_position_act_scr: GDScript = preload("res://game/cutscene/act/move_to_position_act.gd")
@onready var _animate_act_scr: GDScript = preload("res://game/cutscene/act/animate_act.gd")
@onready var _async_act_scr: GDScript = preload("res://game/cutscene/act/async_act.gd")

## Reference to the cutscenes node of the current [Room].
var cutscenes: RoomCutscenes

## Reference to the current transition screen instance.
var screen: Screen

## Array of array used to build asynchronous acts, see [AsyncAct].
## Each entry in the outer array are run in parallel.
var async_act_matrix: Array

## Emitted when this cutscene starts.
signal cutscene_started

## Emitted when this cutscene ends, passing the next [GameState] [code]next_state_id[/code].
signal cutscene_ended(next_state_id: String)


## Initialises this node before it is added to the scene tree.
func init_cutscene(given_cutscenes: RoomCutscenes, given_screen: Screen):
	cutscenes = given_cutscenes
	screen = given_screen


## Creates the initial [member actm] contents of this cutscene.
func make():
	pass


## Creates and returns new movement act of the [Character] entries in the given
## [code]character_list[/code] to the corresponding [Marker2D] entries
## in the given [code]mark_list[/code].
func make_move(
		character_list: Array,
		mark_list: Array) -> MoveAct:
	var move_to_position_act: Act = _move_to_position_act_scr.new()
	move_to_position_act.init_act(character_list, mark_list)
	return move_to_position_act


## Creates and returns a new animation act about the given [code]anim_sprite[/code]
## playing the animation with the given [code]anim_name[/code].
func make_animate(anim_sprite: AnimatedSprite2D, anim_name: String) -> AnimateAct:
	var animate_act = _animate_act_scr.new()
	animate_act.init_act(
		anim_sprite,
		anim_name)
	return animate_act


## Creates and returns an animation act about the [Player]
## playing the animation with the given [code]anim_name[/code],
## or null if that animation does not exist.
func make_animate_player(anim_name: String) -> AnimateAct:
	if is_instance_valid(owner.party.player):
		return make_animate(
			owner.party.player.anim_sprite,
			anim_name)
	else: return null


## Creates and returns an animation act about the [NPC] with the given
## [code]npc_node[/code] name playing the animation with the given [code]anim_name[/code],
## or null if that animation does not exist.
func make_animate_npc(npc_node: String, anim_name: String) -> AnimateAct:
	if owner.npcs.has_node(npc_node):
		return make_animate(
			owner.npcs.get_node(npc_node).anim_sprite,
			anim_name)
	else: return null


## Creates and returns an animation act about the [Thing] with the given
## [code]thing_node[/node] name playing the animation with the given [code]anim_name[/code],
## or null if that animation does not exist.
func make_animate_thing(thing_node: String, anim_name: String) -> AnimateAct:
	if owner.things.has_node(thing_node):
		return make_animate(
			owner.things.get_node(thing_node).anim_sprite,
			anim_name)
	else: return null


## Changes the state of the [Thing] with the given [code]thing_node[/code] name
## to that which has the given [code]thing_state_id[/code].
func set_thing_state(thing_node: String, thing_state_id: String):
	if owner.things.has_node(thing_node):
		owner.things.get_node(thing_node).change_states(thing_state_id)


## Adds a new outer entry to the [member async_act_matrix],
## that will run in parallel with other outer entries.
## The given [code]content[/code] has the following format:
## [codeblock]
## content = [
##   [act_maker1, [arg11, arg12, ...]],
##   [act_maker2, [arg21, arg22, ...]],
##   ...
##  ]
## [/codeblock]
## where each act maker returns a subclass of [Act]
## and takes the arguments in the corresponding argument arrays.
func add_async(content: Array):
	if not content.is_empty():
		async_act_matrix.append([])
		for c in content:
			if c.size() == 2:
				var act = c[0].callv(c[1])
				if is_instance_valid(act):
					async_act_matrix[-1].append(act)


## Creates and returns an asynchronous act from the current
## contents in [member async_act_matrix], then empties those contents.
func make_async() -> AsyncAct:
	var async_act = _async_act_scr.new()
	async_act.init_act(async_act_matrix)
	async_act_matrix = []
	return async_act


## Changes the current [Room] instance to that of the given
## [code]room_id[/code], using the spawn point with the given
## [code]entrance_node[/code] name.
## Does not handle when [member NPC.is_imaginary] is true,
## since those require the exit door of the current room to be known.
func change_rooms(room_id: String, entrance_node: String):
	owner.change_rooms(room_id, entrance_node)


## Checks if an [NPC] with the given [code]npc_node[/code] name is a party member.
func is_joined(npc_node: String) -> bool:
	return owner.party.has_member(npc_node)


## Executes the currently built [member actm].
func begin_cutscene():
	actm.enter_next_act()


## Called when [member actm] reaches the end of its act list.
func end_cutscene():
	owner.end_interaction.emit()


## Called at every frame update.
func update_cutscene(delta: float):
	actm.update_act(delta)


## Manages the current focus.
func grab_cutscene_focus():
	actm.grab_act_focus()
