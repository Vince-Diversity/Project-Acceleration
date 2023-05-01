class_name DialogueCutscene extends Cutscene

@onready var mentor_mark = $MentorMark
@onready var student_mark = $StudentMark


func make():
	make_dialogue_act()


func move(next_dialogue_node: String):
	make_move_to_position_act()
	make_next_dialogue(next_dialogue_node)


func animate_player(anim_name: String, next_dialogue_line: String):
	make_animate_act(owner.party.player, anim_name)
	make_next_dialogue(next_dialogue_line)


func make_animate_act(character: Character, anim_name: String):
	var animate_act = animate_act_scr.new()
	animate_act.init_act(
		character.anim,
		anim_name)
	actm.add_act(animate_act)


func make_move_to_position_act():
	var move_to_position_act: Act = move_to_position_act_scr.new()
	var target_position: Array[Vector2] = [
		mentor_mark.global_position,
		student_mark.global_position]
	var target_direction: Array[Vector2] = [
		mentor_mark.get_target_direction(),
		student_mark.get_target_direction()]
	move_to_position_act.init_act(
		owner.party,
		target_position,
		target_direction)
	actm.add_act(move_to_position_act)


func set_thing_anim(thing_node: String, anim_name: String):
	if owner.things.has_node(thing_node):
		owner.things.get_node(thing_node).anim_sprite.play(anim_name)


func set_player_anim(anim_name: String):
	owner.party.player.set_animation(anim_name)


func make_next_dialogue(next_dialogue_node: String):
	cutscenes.change_dialogue(
		cutscenes.current_dialogue_id,
		next_dialogue_node)
	make_dialogue_act()


func begin_cutscene():
	super()


func end_cutscene():
	cutscene_ended.emit("party_roam_state")


func update_cutscene(delta: float):
	super(delta)


func grab_cutscene_focus():
	super()
