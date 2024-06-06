class_name DialogueCutscene extends Cutscene
## Base class for cutscenes that are dynamically built using [DialogueResource].
##
## When this cutscene is started, a [DialogueAct] is added as the first act in
## the [member ActManager.act_list].
## The act list is then gradually built up
## by calling methods in this dialogue cutscene class within the [DialogueResource].
## All methods in this class are added to the scope of the dialogue resource using
## [code]extra_game_states[/code] in [method DialogueResource.get_next_dialogue_line].
## [br]
## [br]
## After the first [DialogueAct] instance in the act list, consecutive instances
## are automatically added to the end of the act list when building the act list
## from within the dialogue resource. Those new dialogue act instances use the
## same dialogue resource but reads lines from a different dialogue title,
## see [method DialogueResource.get_next_dialogue_line].
## The title is given by the argument [code]next_dlg_title[/code] in those methods.
## [br]
## [br]
## This goes on until no more acts are added within the dialogue.
## An exception is setter methods in this class, which do not add any acts
## but performs changes to nodes in the current game session immediately when called
## from within the dialogue resource.
## [br]
## [br]
## Some pre-instantiated [CharacterMark] nodes are added as child nodes for convenience.
## They can be ignored when not needed, and more markers can be added as
## child nodes when creating a [Room] scene.

## Reference to marker intended as a default [Player] position.
@onready var mentor_mark: CharacterMark = $MentorMark

## Reference to marker intended as a default position for a party member [NPC].
## So far, only one party member that has a key role is joined at a time.
@onready var student_mark: CharacterMark = $StudentMark

@onready var _dialogue_act_scr: GDScript = preload("res://game/cutscene/act/dialogue_act.gd")
@onready var _lighting_act_scr: GDScript = preload("res://game/cutscene/act/lighting_act.gd")
@onready var _idle_frame_act_scr: GDScript = preload("res://game/cutscene/act/idle_frame_act.gd")


## Creates a [DialogueAct] to initialise the act list.
func start_cutscene():
	actm.add_act(_make_current_dialogue())


func _make_current_dialogue() -> Act:
	var dialogue_act: Act = _dialogue_act_scr.new()
	dialogue_act.init_act(
		owner.textbox_started_target,
		cutscenes.current_dialogue_id,
		cutscenes.current_dialogue_node,
		owner.textbox_focused_target,
		self)
	return dialogue_act


func _next_dialogue(next_dialogue_node: String):
	cutscenes.change_dialogues(
		cutscenes.current_dialogue_id,
		next_dialogue_node)
	actm.add_act(_make_current_dialogue())


## Creates and returns a new dialogue act using the
## filename of the [DialogueResource] [code]dialogue_id[/code] and
## the dialogue title [code]dialogue_node[/code].
func make_dialogue(dialogue_id: String, dialogue_node: String) -> DialogueAct:
	var dialogue_act: DialogueAct = _dialogue_act_scr.new()
	dialogue_act.init_act(
		owner.textbox_started_target,
		dialogue_id,
		dialogue_node,
		owner.textbox_focused_target,
		self)
	return dialogue_act


## Creates and returns a movement act of the
## current [Party] to the
## [member mentor_mark] and [member student_mark].
## If only the player is present in the party, the [member student_mark] is skipped.
func make_move_party() -> MoveAct:
	return make_move(
		owner.party.get_party_ordered(),
		[mentor_mark, student_mark])


## Creates and returns a movement act of the
## [NPC] with the given [code]npc_node[/code] name to the
## [CharacterMark] with the given [code]mark_node[/code] name,
## or null if that NPC or marker does not exist.
func make_move_npc(
		npc_node: String,
		mark_node: String) -> MoveAct:
	if owner.npcs.has_node(npc_node) and cutscenes.current_cutscene.has_node(mark_node):
		return make_move(
			[owner.npcs.get_node(npc_node)],
			[cutscenes.current_cutscene.get_node(mark_node)])
	else: return null


## Creates and returns a movement act of the
## [Player] to the [CharacterMark] with the given [code]mark_node[/code] name.
func make_move_player(mark_node: String) -> MoveAct:
	if cutscenes.current_cutscene.has_node(mark_node):
		return make_move(
			[owner.party.player],
			[cutscenes.current_cutscene.get_node(mark_node)])
	else: return null


## Creates and returns an act which instantly removes any changes to the [Screen].
func make_reset_lighting() -> LightingAct:
	var reset_lighting_act: LightingAct = _lighting_act_scr.new()
	reset_lighting_act.init_act(screen, Color.TRANSPARENT, screen.instant_duration)
	return reset_lighting_act


## Creates and returns an act where the screen quickly turns white,
## used for making a flashing visual.
func make_flash() -> LightingAct:
	var flash_in_act: LightingAct = _lighting_act_scr.new()
	flash_in_act.init_act(screen, Color.WHITE, 0.2)
	return flash_in_act


## Creates and returns an act where the screen quickly turns black,
## used for making a blinking visual.
func make_blink() -> LightingAct:
	var blink_in_act: LightingAct = _lighting_act_scr.new()
	blink_in_act.init_act(screen, Color.BLACK, 0.2)
	return blink_in_act


## Creates and returns an act where the screen instantly turns black.
func make_darken() -> LightingAct:
	var darken_act: LightingAct = _lighting_act_scr.new()
	darken_act.init_act(screen, Color(Color.BLACK, 0.5), screen.instant_duration)
	return darken_act


## Creates and returns an act where the screen slowly turns black.
func make_fade_away(duration: float) -> LightingAct:
	var fade_away_act: LightingAct = _lighting_act_scr.new()
	fade_away_act.init_act(screen, Color(Color.BLACK, 1), duration)
	return fade_away_act


## Creates and returns an empty act that is used to wait one frame.
func make_idle_frame() -> IdleFrameAct:
	return _idle_frame_act_scr.new()


func _play(act: Act, next_dlg_title: String):
	if is_instance_valid(act):
		actm.add_act(act)
		_next_dialogue(next_dlg_title)


## Starts an [AsyncAct] using the current async act list [member Cutscene.async_act_matrix].
## The list is then cleared.
func play_async(next_dlg_title: String):
	_play(make_async(), next_dlg_title)


## Moves the player and the first party member to the
## [member mentor_mark] and [member student_mark] markers.
func move(next_dlg_title: String):
	_play(make_move_party(), next_dlg_title)


## Moves an [NPC] with the given [code]npc_node[/code] name
## to the [CharacterMark] with the given [code]mark_node[/code] name.
func move_npc(npc_node: String, mark_node: String, next_dlg_title: String):
	var act = make_move_npc(npc_node, mark_node)
	_play(act, next_dlg_title)


## Moves the [Player] to the [CharacterMark] with the given [code]mark_node[/code] name.
func move_player(mark_node: String, next_dlg_title: String):
	var act = make_move_player(mark_node)
	_play(act, next_dlg_title)


## Animates the [Player]
## with the given [member AnimatedSprite2D.animation] [code]anim_name[/code].
func animate_player(anim_name: String, next_dlg_title: String):
	var act = make_animate_player(anim_name)
	_play(act, next_dlg_title)


## Animates an [NPC] with the given [code]npc_node[/code] name
## with the given [member AnimatedSprite2D.animation] [code]anim_name[/code].
func animate_npc(npc_node: String, anim_name: String, next_dlg_title: String):
	var act = make_animate_npc(npc_node, anim_name)
	_play(act, next_dlg_title)


## Animates a [Thing] with the given [code]thing_node[/code] name
## with the given [member AnimatedSprite2D.animation] [code]anim_name[/code].
func animate_thing(thing_node: String, anim_name: String, next_dlg_title: String):
	var act = make_animate_thing(thing_node, anim_name)
	_play(act, next_dlg_title)


## Resets the [Screen].
func reset_lighting(next_dlg_title: String):
	actm.add_act(make_reset_lighting())
	_next_dialogue(next_dlg_title)


## Plays a flashing visual on the [Screen].
func flash(next_dlg_title: String):
	actm.add_act(make_flash())
	actm.add_act(make_reset_lighting())
	_next_dialogue(next_dlg_title)


## Plays a blinking visual on the [Screen].
func blink(next_dlg_title: String):
	actm.add_act(make_blink())
	actm.add_act(make_reset_lighting())
	_next_dialogue(next_dlg_title)


## Instantly darkens the [Screen].
func darken(next_dlg_title: String):
	actm.add_act(make_darken())
	_next_dialogue(next_dlg_title)

## Slowly darkens the [Screen].
func fade_away(duration: float, next_dlg_title: String):
	actm.add_act(make_fade_away(duration))
	_next_dialogue(next_dlg_title)


## Removes the [NPC] with [code]member_node[/code] from the current [Party].
func remove_member(member_node: String):
	if owner.party.has_node(member_node):
		owner.party.remove_member(owner.party.get_node(member_node))


## Removes the [NPC] with node name [code]npc_node[/code] from the current [Room].
func remove_npc(npc_node: String):
	if owner.npcs.has_node(npc_node):
		owner.remove_npc(npc_node)


## Adds an [NPC] with node name [code]npc_name[/code] to the current [Room].
## If the node name is different, i.e. not the Pascal case, of its filename,
## the filename needs to be added manually with [code]npc_filename[/code].
func create_npc(npc_node: String, npc_filename = ""):
	owner.create_npc(npc_node, npc_filename)


## Adds an [NPC] with scene name [code]npc_name[/code] to the current [Room]
## and waits until that is done, then continues with the [code]next_dlg_title[/code].
## Workaround to create_npc(), since sometimes NPCs can not be created.
## This happened when trying to make an NPC during an [AreaCutscene].
func await_create_npc(npc_name: String, next_dlg_title: String):
	create_npc.call_deferred(npc_name)
	_play(make_idle_frame(), next_dlg_title)


## Adds a [CharacterMark] with xy-coordinates relative to the [Player] position
## with the given node name [code]mark_node[/code], unless the name already exists.
## The direction of the created character mark is "right", just as a default.
func create_mark_from_player(mark_node: String, x: float, y: float):
	if not has_node(mark_node):
		var target_pos = owner.party.player.global_position + Vector2(x, y)
		var target_direction_id = Utils.AnimID.RIGHT
		owner.create_character_mark(mark_node, target_pos, target_direction_id)


## Sets the [member CanvasItem.z_index] of the [NPC] with the given [code]npc_node[/code] name
## to be in front of the general environment.
func elevate_npc(npc_node: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).set_z_index(Utils.Elevation.FRONT)


## Resets the [member CanvasItem.z_index] of the [NPC] with the given [code]npc_node[/code] name.
func reset_npc_elevation(npc_node: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).set_z_index(Utils.Elevation.FLOOR)


## Sets the [Player] animation with the given [member AnimatedSprite2D.animation] [code]anim_name[/code].
func set_player_anim(anim_name: String):
	owner.party.player.set_animation(anim_name)


## Sets the animation of the [NPC], with the given [code]npc_node[/code] name,
## with the given [member AnimatedSprite2D.animation] [code]anim_name[/code].
func set_npc_anim(npc_node: String, anim_name: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).set_animation(anim_name)


## Sets the player animation to show an [ItemSprite] with the given [code]item_id[/code].
func set_player_exhibit_anim(item_id: String):
	owner.party.player.exhibit(item_id)


## Sets the [NPC], with the given [code]npc_node[/code] name,
## to show an [ItemSprite] with the given [code]item_id[/code].
func set_npc_exhibit_anim(npc_node: String, item_id: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).exhibit(item_id)


## Sets the position of the [NPC], with the given [code]npc_node[/code] name,
## at the [CharacterMark] with the given [code]mark_node[/code] name.
func set_npc_at_mark(npc_node: String, mark_node: String):
	if owner.npcs.has_node(npc_node)\
	and cutscenes.current_cutscene.has_node(mark_node):
		var npc = owner.npcs.get_node(npc_node)
		var mark = cutscenes.current_cutscene.get_node(mark_node)
		npc.set_global_position(mark.global_position)
		set_npc_direction(npc_node, Utils.anim_name[mark.target_direction_id])


## Sets the position of the [NPC], with the given [code]npc_node[/code] name,
## just outside the screen and to the left of the player.
func set_npc_just_outside_viewport(npc_node: String):
	if owner.npcs.has_node(npc_node):
		var npc = owner.npcs.get_node(npc_node)
		var npc_xpos =\
			owner.party.player.global_position.x\
			- ProjectSettings.get("display/window/size/viewport_width")
		var npc_ypos = owner.party.player.global_position.y
		var npc_pos = Vector2(npc_xpos, npc_ypos)
		npc.set_global_position(npc_pos)


## Sets the direction of the [NPC], with the given [code]npc_node[/code] name,
## corresponding to the name of the movement animation that is given by [code]direction[/code].
func set_npc_direction(npc_node: String, direction: String):
	if owner.npcs.has_node(npc_node):
		var anim_id = Utils.get_anim_id(direction)
		if anim_id == null: return
		var npc = owner.npcs.get_node(npc_node)
		npc.set_direction(Utils.get_anim_direction(anim_id))
		npc.update_direction()


## Sets the direction of the [Player]
## corresponding to the name of the movement animation that is given by [code]direction[/code].
func set_player_direction(direction: String):
	var anim_id = Utils.get_anim_id(direction)
	if anim_id == null: return
	owner.party.player.set_direction(Utils.get_anim_direction(anim_id))
	owner.party.player.update_direction()


## Sets the node name of the desired cutscene instance that is used when
## interacting with the [NPC] that has the given [code]npc_node[/code] name.
func set_npc_interaction_node(npc_node: String, interaction_node: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).interaction_node = interaction_node


## Sets the filename of the [DialogueResource] that is used when
## interacting with the [NPC] that has the given [code]npc_node[/code] name.
func set_npc_dialogue_id(npc_node: String, dialogue_id: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).dialogue_id = dialogue_id


## Sets the dialogue title that is used when
## interacting with the [NPC] that has the given [code]npc_node[/code] name.
func set_npc_dialogue_node(npc_node: String, dialogue_node: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).dialogue_node = dialogue_node


## Sets the speed of the [NPC] that has the given [code]npc_node[/code] name
## to double that of default.
func double_npc_speed(npc_node: String):
	if owner.npcs.has_node(npc_node):
		var npc = owner.npcs.get_node(npc_node);
		npc.speed = 2 * npc.default_speed


## Sets the speed of the [NPC] that has the given [code]npc_node[/code] name
## to the default walking speed.
func reset_npc_speed(npc_node: String):
	if owner.npcs.has_node(npc_node):
		var npc = owner.npcs.get_node(npc_node);
		npc.speed = npc.default_speed


## Sets the animation of the [Thing], with the given [code]thing_node[/code] name,
## with the given [member AnimatedSprite2D.animation] [code]anim_name[/code].
func set_thing_anim(thing_node: String, anim_name: String):
	if owner.things.has_node(thing_node):
		owner.things.get_node(thing_node).anim_sprite.play(anim_name)


## Turns the [NPC] with the given [code]npc_node[/code] name
## towards the [Player].
func turn_npc_to_player(npc_node: String):
	if owner.npcs.has_node(npc_node):
		var npc = owner.npcs.get_node(npc_node)
		var direction: Vector2 = _get_npc_to_player_direction(npc_node)
		npc.set_direction(direction)
		npc.update_direction()


## Turns the [NPC] with the given [code]source_npc_node[/code] name
## towards the [NPC] with the given [code]target_npc_node[/code] name.
func turn_npc_to_npc(source_npc_node: String, target_npc_node: String):
	if owner.npcs.has_node(source_npc_node) and owner.npcs.has_node(target_npc_node):
		var source_npc = owner.npcs.get_node(source_npc_node)
		var direction: Vector2 = _get_npc_to_npc_direction(source_npc_node, target_npc_node)
		source_npc.set_direction(direction)
		source_npc.update_direction()


## Turns the [Player] towards the [NPC] with the given [code]npc_node[/code] name
func turn_player_to_npc(npc_node: String):
	if owner.npcs.has_node(npc_node):
		var direction = -_get_npc_to_player_direction(npc_node)
		owner.party.player.set_direction(direction)
		owner.party.player.update_direction()


func _get_npc_to_player_direction(npc_node: String) -> Vector2:
	return owner.party.player.global_position - owner.npcs.get_node(npc_node).global_position


func _get_npc_to_npc_direction(source_npc_node: String, target_npc_node: String) -> Vector2:
	return owner.npcs.get_node(target_npc_node).global_position \
		- owner.npcs.get_node(source_npc_node).global_position


## Enables the [EntranceEvent] of the [Room] with the given [code]room_id[/code].
func enable_entrance_event(room_id: String):
	owner.entrance_event_edited.emit(room_id, true)


## Enables the [EntranceEvent] of the [Room] with the given [code]room_id[/code]
## with updated node name of the entrance event cutscene instance [code]interaction_node[/code],
## filename of its [DialogueResource] [code]dialogue_id[/code] and
## its dialogue title [code]dialogue_node[/code].
func change_entrance_event(
		room_id: String,
		interaction_node: String,
		dialogue_id: String,
		dialogue_node: String):
	owner.entrance_event_edited.emit(
		room_id,
		true,
		interaction_node,
		dialogue_id,
		dialogue_node)


## Adds the [NPC] with the given [code]npc_node[/code] name
## as a new member to the current [Party].
func add_member(npc_node: String):
	if owner.npcs.has_node(npc_node):
		var npc = owner.npcs.get_node(npc_node)
		owner.party.add_npc_as_member(npc)


## Adds a newly obtained [ItemSprite] with the given [code]item_id[/code]
## to the player's [Items] list.
func add_item(item_id: String):
	owner.party.player.items.add_item(item_id)


## Finishes this cutscene and changes the current game session state to [RoamState].
func end_cutscene():
	super()
	cutscene_ended.emit("roam_state")
