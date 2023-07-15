class_name DialogueCutscene extends Cutscene

@onready var mentor_mark = $MentorMark
@onready var student_mark = $StudentMark
@onready var dialogue_act_scr: GDScript = preload("res://game/cutscene/act/dialogue_act.gd")
@onready var flash_act_scr: GDScript = preload("res://game/cutscene/act/flash_act.gd")

func make():
	make_dialogue_act()


func make_dialogue_act():
	var dialogue_act: Act = dialogue_act_scr.new()
	dialogue_act.init_act(
		owner.textbox_started_target,
		cutscenes.current_dialogue_id,
		cutscenes.current_dialogue_node,
		owner.textbox_focused_target,
		self)
	actm.add_act(dialogue_act)


func make_flash_act():
	var flash_in_act: Act = flash_act_scr.new()
	var flash_out_act: Act = flash_act_scr.new()
	flash_in_act.init_act(screen, Color.WHITE, 0.2)
	flash_out_act.init_act(screen, Color.TRANSPARENT, 0.2)
	actm.add_act(flash_in_act)
	actm.add_act(flash_out_act)


func make_move_to_position_act(
		character_list: Array,
		mark_list: Array):
	var move_to_position_act: Act = move_to_position_act_scr.new()
	move_to_position_act.init_act(character_list, mark_list)
	actm.add_act(move_to_position_act)


func make_move_party_to_position_act():
	var move_to_position_act: Act = move_to_position_act_scr.new()
	move_to_position_act.init_act(
		owner.party.get_party_ordered(),
		[mentor_mark, student_mark])
	actm.add_act(move_to_position_act)


func make_next_dialogue(next_dialogue_node: String):
	cutscenes.change_dialogue(
		cutscenes.current_dialogue_id,
		next_dialogue_node)
	make_dialogue_act()


func move(next_dialogue_node: String):
	make_move_party_to_position_act()
	make_next_dialogue(next_dialogue_node)


func move_npc(npc_node: String, mark_node: String, next_dlg_line: String):
	if owner.npcs.has_node(npc_node) and cutscenes.current_cutscene.has_node(mark_node):
		make_move_to_position_act(
			[owner.npcs.get_node(npc_node)],
			[cutscenes.current_cutscene.get_node(mark_node)])
		make_next_dialogue(next_dlg_line)


func animate_player(anim_name: String, next_dlg_line: String):
	make_animate_act(owner.party.player.anim, anim_name)
	make_next_dialogue(next_dlg_line)


func animate_npc(npc_node: String, anim_name: String, next_dlg_line: String):
	if owner.npcs.has_node(npc_node):
		make_animate_act(owner.npcs.get_node(npc_node).anim, anim_name)
		make_next_dialogue(next_dlg_line)


func set_player_anim(anim_name: String):
	owner.party.player.set_animation(anim_name)


func set_npc_anim(npc_node: String, anim_name: String):
	if owner.npcs.has_node(npc_node):
		owner.npcs.get_node(npc_node).set_animation(anim_name)


func set_thing_anim(thing_node: String, anim_name: String):
	if owner.things.has_node(thing_node):
		owner.things.get_node(thing_node).anim_sprite.play(anim_name)


func flash(next_dlg_line: String):
	make_flash_act()
	make_next_dialogue(next_dlg_line)


func begin_cutscene():
	super()


func end_cutscene():
	super()
	cutscene_ended.emit("party_roam_state")


func update_cutscene(delta: float):
	super(delta)


func grab_cutscene_focus():
	super()
