extends Cutscene

func make():
	var interact_act: Act = interact_act_scr.new()
	interact_act.init_act(
		owner.textbox_started_target,
		cutscenes.current_dialogue_id,
		cutscenes.current_dialogue_node,
		owner.textbox_focused_target)
	actm.add_act(interact_act)


func begin_cutscene():
	super()


func end_cutscene():
	cutscene_ended.emit("party_roam_state")


func update_cutscene(delta: float):
	super(delta)


func grab_cutscene_focus():
	super()
