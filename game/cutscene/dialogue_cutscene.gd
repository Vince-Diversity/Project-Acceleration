class_name DialogueCutscene extends Cutscene

@onready var mentor_mark = $MentorMark
@onready var student_mark = $StudentMark
@onready var dialogue_act_scr: GDScript = preload("res://game/cutscene/act/dialogue_act.gd")
@onready var lighting_act_scr: GDScript = preload("res://game/cutscene/act/lighting_act.gd")


func make():
	actm.add_act(make_current_dialogue())


func make_current_dialogue() -> Act:
	var dialogue_act: Act = dialogue_act_scr.new()
	dialogue_act.init_act(
		owner.textbox_started_target,
		cutscenes.current_dialogue_id,
		cutscenes.current_dialogue_node,
		owner.textbox_focused_target,
		self)
	return dialogue_act


func make_dialogue(dialogue_id: String, dialogue_node: String) -> Act:
	var dialogue_act: Act = dialogue_act_scr.new()
	dialogue_act.init_act(
		owner.textbox_started_target,
		dialogue_id,
		dialogue_node,
		owner.textbox_focused_target,
		self)
	return dialogue_act


func make_move_party() -> Act:
	return make_move(
		owner.party.get_party_ordered(),
		[mentor_mark, student_mark])


func make_move_npc(
		npc_node: String,
		mark_node: String) -> Act:
	if owner.npcs.has_node(npc_node) and cutscenes.current_cutscene.has_node(mark_node):
		return make_move(
			[owner.npcs.get_node(npc_node)],
			[cutscenes.current_cutscene.get_node(mark_node)])
	else: return null


func make_move_player(mark_node: String) -> Act:
	if cutscenes.current_cutscene.has_node(mark_node):
		return make_move(
			[owner.party.player],
			[cutscenes.current_cutscene.get_node(mark_node)])
	else: return null


func make_flash() -> Act:
	var flash_in_act: Act = lighting_act_scr.new()
	flash_in_act.init_act(screen, Color.WHITE, 0.2)
	return flash_in_act


func make_darken() -> Act:
	var darken_act: Act = lighting_act_scr.new()
	darken_act.init_act(screen, Color(Color.BLACK, 0.5), screen.instant)
	return darken_act


func make_reset_ligtning() -> Act:
	var reset_lighting_act: Act = lighting_act_scr.new()
	reset_lighting_act.init_act(screen, Color.TRANSPARENT, screen.instant)
	return reset_lighting_act


func make_fade_away(duration: float) -> Act:
	var fade_away_act: Act = lighting_act_scr.new()
	fade_away_act.init_act(screen, Color(Color.BLACK, 1), duration)
	return fade_away_act


func next_dialogue(next_dialogue_node: String):
	cutscenes.change_dialogue(
		cutscenes.current_dialogue_id,
		next_dialogue_node)
	actm.add_act(make_current_dialogue())


func move(next_dlg_line: String):
	play(make_move_party(), next_dlg_line)


func move_npc(npc_node: String, mark_node: String, next_dlg_line: String):
	var act = make_move_npc(npc_node, mark_node)
	play(act, next_dlg_line)


func move_player(mark_node: String, next_dlg_line: String):
	var act = make_move_player(mark_node)
	play(act, next_dlg_line)


func animate_player(anim_name: String, next_dlg_line: String):
	var act = make_animate_player(anim_name)
	play(act, next_dlg_line)


func animate_npc(npc_node: String, anim_name: String, next_dlg_line: String):
	var act = make_animate_npc(npc_node, anim_name)
	play(act, next_dlg_line)


func animate_thing(thing_node: String, anim_name: String, next_dlg_line: String):
	var act = make_animate_thing(thing_node, anim_name)
	play(act, next_dlg_line)


func flash(next_dlg_line: String):
	actm.add_act(make_flash())
	actm.add_act(make_reset_ligtning())
	next_dialogue(next_dlg_line)


func darken(next_dlg_line: String):
	actm.add_act(make_darken())
	next_dialogue(next_dlg_line)


func reset_lighting(next_dlg_line: String):
	actm.add_act(make_reset_ligtning())
	next_dialogue(next_dlg_line)


func fade_away(duration: float, next_dlg_line: String):
	actm.add_act(make_fade_away(duration))
	next_dialogue(next_dlg_line)


func remove_member(member_node: String):
	if owner.party.has_node(member_node):
		owner.party.remove_member(owner.party.get_node(member_node))


func remove_npc(npc_node: String):
	if owner.npcs.has_node(npc_node):
		owner.remove_npc(npc_node)


func create_npc(npc_node: String):
	owner.create_npc(npc_node)


func elevate_npc(npc_node: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).set_z_index(Utils.Elevation.FRONT)


func reset_npc_elevation(npc_node: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).set_z_index(Utils.Elevation.FLOOR)


func set_player_anim(anim_name: String):
	owner.party.player.set_animation(anim_name)


func set_npc_anim(npc_node: String, anim_name: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).set_animation(anim_name)


func set_player_exhibit_anim(item_id: String):
	owner.party.player.exhibit(item_id)


func set_npc_exhibit_anim(npc_node: String, item_id: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).exhibit(item_id)


func set_npc_at_mark(npc_node: String, mark_node: String):
	if owner.npcs.has_node(npc_node)\
	and cutscenes.current_cutscene.has_node(mark_node):
		var npc = owner.npcs.get_node(npc_node)
		var mark = cutscenes.current_cutscene.get_node(mark_node)
		npc.set_global_position(mark.global_position)
		set_npc_direction(npc_node, Utils.anim_name[mark.target_direction_id])


func set_npc_direction(npc_node: String, direction: String):
	if owner.npcs.has_node(npc_node):
		var anim_id = Utils.get_anim_id(direction)
		if anim_id == null: return
		var npc = owner.npcs.get_node(npc_node)
		npc.set_direction(Utils.get_anim_direction(anim_id))
		npc.update_direction()


func set_player_direction(direction: String):
	var anim_id = Utils.get_anim_id(direction)
	if anim_id == null: return
	owner.party.player.set_direction(Utils.get_anim_direction(anim_id))
	owner.party.player.update_direction()


func set_npc_interaction_node(npc_node: String, interaction_node: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).interaction_node = interaction_node


func set_npc_dialogue_id(npc_node: String, dialogue_id: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).dialogue_id = dialogue_id


func set_npc_dialogue_node(npc_node: String, dialogue_node: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).dialogue_node = dialogue_node


func set_thing_anim(thing_node: String, anim_name: String):
	if owner.things.has_node(thing_node):
		owner.things.get_node(thing_node).anim_sprite.play(anim_name)


func turn_npc_to_player(npc_node: String):
	if owner.npcs.has_node(npc_node):
		var npc = owner.npcs.get_node(npc_node)
		var direction: Vector2 = _get_npc_to_player_direction(npc_node)
		npc.set_direction(direction)
		npc.update_direction()


func turn_player_to_npc(npc_node):
	if owner.npcs.has_node(npc_node):
		var direction = -_get_npc_to_player_direction(npc_node)
		owner.party.player.set_direction(direction)
		owner.party.player.update_direction()


func _get_npc_to_player_direction(npc_node) -> Vector2:
	var npc = owner.npcs.get_node(npc_node)
	return owner.party.player.global_position - npc.global_position


func enable_entrance_event(room_id: String):
	owner.entrance_event_edited.emit(room_id, true)


func add_member(npc_node: String):
	if owner.npcs.has_node(npc_node):
		var npc = owner.npcs.get_node(npc_node)
		owner.party.add_npc_as_member(npc)


func add_source_as_member():
	if cutscenes.current_source_node.is_class("CharacterBody2D"):
		owner.party.add_npc_as_member(cutscenes.current_source_node)


func add_item(item_id: String):
	owner.party.player.items.add_item(item_id)


func play_async(next_dlg_line: String):
	play(make_async(), next_dlg_line)


func play(act: Act, next_dlg_line: String):
	if is_instance_valid(act):
		actm.add_act(act)
		next_dialogue(next_dlg_line)


func begin_cutscene():
	super()


func end_cutscene():
	super()
	cutscene_ended.emit("roam_state")


func update_cutscene(delta: float):
	super(delta)


func grab_cutscene_focus():
	super()
