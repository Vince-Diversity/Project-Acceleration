class_name Cutscene extends Node2D

@onready var actm: GDScript = ActManager.new(end_cutscene)
@onready var move_to_position_act_scr: GDScript = preload("res://game/cutscene/act/move_to_position_act.gd")
@onready var animate_act_scr: GDScript = preload("res://game/cutscene/act/animate_act.gd")
var cutscenes: RoomCutscenes
var screen: Screen

signal cutscene_started
signal cutscene_ended(next_state_id: String)


func init_cutscene(given_cutscenes: RoomCutscenes, given_screen: Screen):
	cutscenes = given_cutscenes
	screen = given_screen


func make():
	pass


func make_move(
		character_list: Array,
		mark_list: Array) -> Act:
	var move_to_position_act: Act = move_to_position_act_scr.new()
	move_to_position_act.init_act(character_list, mark_list)
	return move_to_position_act


func make_animate(anim_sprite: AnimatedSprite2D, anim_name: String):
	var animate_act = animate_act_scr.new()
	animate_act.init_act(
		anim_sprite,
		anim_name)
	return animate_act


func make_animate_player(anim_name: String) -> Act:
	if is_instance_valid(owner.party.player):
		return make_animate(
			owner.party.player.anim_sprite,
			anim_name)
	else: return null


func make_animate_npc(npc_node: String, anim_name: String) -> Act:
	if owner.npcs.has_node(npc_node):
		return make_animate(
			owner.npcs.get_node(npc_node).anim_sprite,
			anim_name)
	else: return null


func make_animate_thing(thing_node: String, anim_name: String) -> Act:
	if owner.things.has_node(thing_node):
		return make_animate(
			owner.things.get_node(thing_node).anim_sprite,
			anim_name)
	else: return null


func set_thing_state(thing_node: String, thing_state_id: String):
	if owner.things.has_node(thing_node):
		owner.things.get_node(thing_node).change_state(thing_state_id)


func begin_cutscene():
	actm.enter_next_act()


func end_cutscene():
	owner.end_interaction.emit()


func update_cutscene(delta: float):
	actm.update_act(delta)


func grab_cutscene_focus():
	actm.grab_act_focus()
