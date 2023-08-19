class_name DialogueCutscene extends Cutscene

@onready var mentor_mark = $MentorMark
@onready var student_mark = $StudentMark
@onready var dialogue_act_scr: GDScript = preload("res://game/cutscene/act/dialogue_act.gd")
@onready var lightning_act_scr: GDScript = preload("res://game/cutscene/act/lightning_act.gd")
@onready var async_act_scr: GDScript = preload("res://game/cutscene/act/async_act.gd")
var async_act_matrix: Array

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


func make_move(
		character_list: Array,
		mark_list: Array) -> Act:
	var move_to_position_act: Act = move_to_position_act_scr.new()
	move_to_position_act.init_act(character_list, mark_list)
	return move_to_position_act


func make_move_npc(
		npc_node: String,
		mark_node: String) -> Act:
	if owner.npcs.has_node(npc_node) and cutscenes.current_cutscene.has_node(mark_node):
		return make_move(
			[owner.npcs.get_node(npc_node)],
			[cutscenes.current_cutscene.get_node(mark_node)])
	else: return null


func make_move_party() -> Act:
	return make_move(
		owner.party.get_party_ordered(),
		[mentor_mark, student_mark])


func make_flash() -> Act:
	var flash_in_act: Act = lightning_act_scr.new()
	flash_in_act.init_act(screen, Color.WHITE, 0.2)
	return flash_in_act


func make_darken() -> Act:
	var darken_act: Act = lightning_act_scr.new()
	darken_act.init_act(screen, Color(Color.BLACK, 0.5), screen.instant)
	return darken_act


func make_reset_ligtning() -> Act:
	var reset_lightning_act: Act = lightning_act_scr.new()
	reset_lightning_act.init_act(screen, Color.TRANSPARENT, screen.instant)
	return reset_lightning_act


func next_dialogue(next_dialogue_node: String):
	cutscenes.change_dialogue(
		cutscenes.current_dialogue_id,
		next_dialogue_node)
	actm.add_act(make_current_dialogue())


func move(next_dialogue_node: String):
	actm.add_act(make_move_party())
	next_dialogue(next_dialogue_node)


func move_npc(npc_node: String, mark_node: String, next_dlg_line: String):
	var act = make_move_npc(npc_node, mark_node)
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


func reset_lightning(next_dlg_line: String):
	actm.add_act(make_reset_ligtning())
	next_dialogue(next_dlg_line)


func set_player_anim(anim_name: String):
	owner.party.player.set_animation(anim_name)


func set_npc_anim(npc_node: String, anim_name: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).set_animation(anim_name)


func set_npc_direction(npc_node: String, direction: String):
	if owner.npcs.has_node(npc_node):
		var anim_id = Utils.get_anim_id(direction)
		if anim_id == null: return
		var npc = owner.npcs.get_node(npc_node)
		npc.set_direction(Utils.get_anim_direction(anim_id))
		npc.update_direction()


func set_npc_dialogue_node(npc_node: String, dialogue_node: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).dialogue_node = dialogue_node


func set_thing_anim(thing_node: String, anim_name: String):
	if owner.things.has_node(thing_node):
		owner.things.get_node(thing_node).anim_sprite.play(anim_name)


func set_thing_state(thing_node: String, thing_state_id: String):
	if owner.things.has_node(thing_node):
		owner.things.get_node(thing_node).change_state(thing_state_id)


func turn_npc_to_player(npc_node: String):
	if owner.npcs.has_node(npc_node):
		var npc = owner.npcs.get_node(npc_node)
		var direction: Vector2 =\
			owner.party.player.global_position - npc.global_position
		npc.set_direction(direction)
		npc.update_direction()


func add_member(npc_node: String):
	if owner.npcs.has_node(npc_node):
		var npc = owner.npcs.get_node(npc_node)
		owner.party.add_member(npc)


func play(act: Act, next_dlg_line: String):
	if is_instance_valid(act):
		actm.add_act(act)
		next_dialogue(next_dlg_line)


func add_async(content: Array):
	if not content.is_empty():
		async_act_matrix.append([])
		for c in content:
			if c.size() == 2:
				var act = c[0].callv(c[1])
				if is_instance_valid(act):
					async_act_matrix[-1].append(act)


func play_async(next_dlg_line: String):
	var async_act = async_act_scr.new()
	async_act.init_act(async_act_matrix)
	actm.add_act(async_act)
	next_dialogue(next_dlg_line)
	async_act_matrix = []


func begin_cutscene():
	super()


func end_cutscene():
	super()
	cutscene_ended.emit("party_roam_state")


func update_cutscene(delta: float):
	super(delta)


func grab_cutscene_focus():
	super()
