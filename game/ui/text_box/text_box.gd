extends ScrollContainer

onready var narrative_scn = preload("res://game/ui/text_box/narrative_label.tscn")
onready var pending_scn = preload("res://game/ui/text_box/pending_visual.tscn")
onready var resp_scn = preload("res://game/ui/text_box/response.tscn")
onready var dlg = $Dialogue
onready var scroll_bar = get_v_scrollbar()
var dlg_res: Resource
var input_node
var resp_arr := []

signal responses_displayed(input_node)
signal input_given
signal finished_next_set

func load_text(dlg_name):
	dlg_res = load(Utils.get_dlg_path(dlg_name))

func run_text() -> void:
	var dlg_node: String
	if States.visited_with_blue.has(Utils.get_res_filename(dlg_res)):
		dlg_node = States.visit_dlg_node
	else:
		if States.visited.has(Utils.get_res_filename(dlg_res)):
			dlg_node = States.visit_dlg_node
		else:
			dlg_node = States.first_visit_dlg_node
	var dlg_line = yield(dlg_res.get_next_dialogue_line(dlg_node), "completed")
	while dlg_line != null:
		resp_arr = []
		var narrative = narrative_scn.instance()
		dlg.add_child(narrative)
		make_narrative(narrative, dlg_line)
		yield(narrative.reset_height(), "completed")
		narrative.type_out()
		yield(get_tree(), "idle_frame")
		Utils.scroll_to_bottom(scroll_bar)
		yield(narrative, "finished")
		if dlg_line.responses.empty():
			var pending_vfx = pending_scn.instance()
			dlg.add_child(pending_vfx)
#			yield(get_tree(), "idle_frame")
#			Utils.scroll_to_bottom(scroll_bar) # This looks too jumpy
			yield(input_node, "accept_pressed")
			dlg.remove_child(pending_vfx)
			dlg_line = yield(dlg_res.get_next_dialogue_line(dlg_line.next_id), "completed")
		else:
			var response
			for i in dlg_line.responses.size():
				response = resp_scn.instance()
				make_response(response, i)
				dlg.add_child(response)
				resp_arr.append(response)
				response.prompt(dlg_line.responses[i].prompt)
			Utils.connect_neighbouring_elems(resp_arr)
			grab_next_focus()
			emit_signal("responses_displayed", input_node)
			yield(get_tree(), "idle_frame")
			yield(get_tree(), "idle_frame") # This second idle frame matters
			Utils.scroll_to_bottom(scroll_bar)
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
			for resp in resp_arr:
				resp.disable()
	remove_child(dlg)
	mark_dlg()
	emit_signal("finished_next_set")

func make_narrative(narrative, dlg_line):
	narrative.dialogue = dlg_line

func make_response(resp, resp_index: int):
	resp.index = resp_index
	resp.connect("selected", input_node, "_on_Response_selected")

func mark_dlg() -> void:
	var dlg_id = Utils.get_res_filename(dlg_res)
	if !States.visited.has(dlg_id):
		States.visited.append(dlg_id)
		if States.blue_joined:
			States.visited_with_blue.append(dlg_id)

func clear():
	for entry in dlg.get_children():
		dlg.remove_child(entry)

func grab_next_focus():
	if !resp_arr.empty():
		resp_arr[0].grab_focus()
