extends ScrollContainer

onready var narrative_scn = preload("res://game/ui/text_box/narrative_label.tscn")
onready var pending_scn = preload("res://game/ui/text_box/pending_visual.tscn")
onready var resp_scn = preload("res://game/ui/text_box/response.tscn")
onready var dlg = $Dialogue
onready var scroll_bar = get_v_scrollbar()
var dlg_res: Resource
var input_node

signal responses_displayed(input_node)
signal input_given
signal finished_next_set

func load_text(dlg_name):
	dlg_res = load(Utils.get_dlg_path(dlg_name))

func run_text() -> void:
	var dlg_node: String
	if States.visited.has(Utils.get_res_filename(dlg_res)):
		dlg_node = States.visit_dlg_node
	else:
		dlg_node = States.first_visit_dlg_node
	var dlg_line = yield(dlg_res.get_next_dialogue_line(dlg_node), "completed")
	while dlg_line != null:
		var narrative = narrative_scn.instance()
		dlg.add_child(narrative)
		make_narrative(narrative, dlg_line)
		narrative.type_out()
		yield(narrative, "finished")
		if dlg_line.responses.empty():
			var pending_vfx = pending_scn.instance()
			dlg.add_child(pending_vfx)
			yield(input_node, "accept_pressed")
			dlg.remove_child(pending_vfx)
			dlg_line = yield(dlg_res.get_next_dialogue_line(dlg_line.next_id), "completed")
		else:
			var resp_arr := []
			var resp
			for i in dlg_line.responses.size():
				resp = resp_scn.instance()
				make_response(resp, i)
				dlg.add_child(resp)
				resp_arr.append(resp)
				resp.prompt(dlg_line.responses[i].prompt)
			Utils.connect_neighbouring_elems(resp_arr)
			resp_arr[0].grab_focus()
			emit_signal("responses_displayed", input_node)
			var input_arr = yield(input_node, "input_on_responding")
			if input_arr[0] == Utils.InputType.RESPONSE:
				var resp_index = input_arr[1]
				resp_arr[resp_index].release_focus()
				emit_signal("input_given")
				dlg_line = yield(dlg_res.get_next_dialogue_line(dlg_line.responses[resp_index].next_id), "completed")
			elif input_arr[0] == Utils.InputType.ACTION:
				emit_signal("input_given")
				var action_id = input_arr[1]
				# Matches a state with the action and place to set an action state
				# If there is no match, the set is ignored
				States.set(Utils.get_action_state_name(States.current_room, action_id), true)
				dlg_line = yield(dlg_res.get_next_dialogue_line(States.action_dlg_node), "completed")
			elif input_arr[0] ==  Utils.InputType.REACTIVATION:
				emit_signal("input_given")
				dlg_line = yield(dlg_res.get_next_dialogue_line(States.reactivation_dlg_node), "completed")
			else:
				push_warning("Textbox received a signal that is not in the Utils.InputType: %s" % input_arr[0])
	remove_child(dlg)
	mark_dlg()
	emit_signal("finished_next_set")

func make_narrative(narrative, dlg_line):
	narrative.dialogue = dlg_line
	narrative.scroll_bar = scroll_bar

func make_response(resp, resp_index: int):
	resp.index = resp_index
	resp.scroll_bar = scroll_bar
	resp.connect("selected", input_node, "_on_Response_selected")

func mark_dlg() -> void:
	var dlg_id = Utils.get_res_filename(dlg_res)
	if !States.visited.has(dlg_id):
		States.visited.append(dlg_id)

func clear():
	for entry in dlg.get_children():
		dlg.remove_child(entry)
