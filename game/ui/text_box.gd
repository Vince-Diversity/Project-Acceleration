extends Control

onready var dlg_scn = preload("res://game/ui/text_box/dialogue.tscn")
onready var narrative_scn = preload("res://game/ui/text_box/narrative_label.tscn")
onready var pending_scn = preload("res://game/ui/text_box/pending_visual.tscn")
onready var resp_scn = preload("res://game/ui/text_box/response.tscn")
onready var resp_maker: Resource = preload("res://game/ui/text_box/response_maker.gd")
var dlg_res: Resource
var dlg

signal accept_pressed
signal finished_next_set

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("accept_pressed")

func load_text(dlg_name):
	var dlg_path = Utils.dlg_dir + dlg_name + ".tres"
	dlg_res = load(dlg_path)

func run_text() -> void:
	var dlg_node: String
	if States.visited.has(Utils.get_res_filename(dlg_res)):
		dlg_node = States.revisit_dlg_node
	else:
		dlg_node = States.first_visit_dlg_node
	var dlg_line = yield(dlg_res.get_next_dialogue_line(dlg_node), "completed")
	dlg = dlg_scn.instance()
	add_child(dlg)
	while dlg_line != null:
		var narrative = narrative_scn.instance()
		dlg.add_child(narrative)
		narrative.dialogue = dlg_line
		narrative.type_out()
		yield(narrative, "finished")
		if dlg_line.responses.empty():
			var pending_vfx = pending_scn.instance()
			dlg.add_child(pending_vfx)
			yield(self, "accept_pressed")
			dlg.remove_child(pending_vfx)
			dlg_line = yield(dlg_res.get_next_dialogue_line(dlg_line.next_id), "completed")
		else:
			var resp_arr := []
			var resp
			for i in dlg_line.responses.size():
				resp = resp_scn.instance()
				resp_maker.make(resp, dlg, dlg_line.responses[i], i)
				dlg.add_child(resp)
				resp_arr.append(resp)
			Utils.connect_neighbouring_elems(resp_arr)
			resp_arr[0].grab_focus()
			var resp_index = yield(dlg, "answered")
			resp_arr[resp_index].release_focus()
			dlg_line = yield(dlg_res.get_next_dialogue_line(dlg_line.responses[resp_index].next_id), "completed")
	remove_child(dlg)
	mark_dlg()
	emit_signal("finished_next_set")

func mark_dlg() -> void:
	var id = Utils.get_res_filename(dlg_res)
	if !States.visited.has(id):	States.visited.append(id)

func clear():
	for entry in dlg.get_children():
		dlg.remove_child(entry)

func _on_Game_accept_pressed():
	emit_signal("accept_pressed")
