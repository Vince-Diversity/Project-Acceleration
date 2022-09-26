extends Control

onready var dlg_scn = preload("res://game/ui/dialogue.tscn")
onready var narrative_scn = preload("res://game/ui/narrative_label.tscn")
onready var pending_scn = preload("res://game/ui/pending_visual.tscn")
onready var resp_scn = preload("res://game/ui/response.tscn")
onready var resp_maker: Resource = preload("res://game/ui/response_maker.gd")
var dlg

signal accept_pressed
signal finished

func _ready():
	_run_dlg()

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("accept_pressed")

func _mark_room() -> void:
	var id = Utils.get_res_filename(owner.dlg_res)
	if !States.visited.has(id):	States.visited.append(id)

func _run_dlg() -> void:
	var dlg_node: String
	if States.visited.has(Utils.get_res_filename(owner.dlg_res)):
		dlg_node = owner.revisit_dlg_node
	else:
		dlg_node = owner.first_visit_dlg_node
	var dlg_line = yield(owner.dlg_res.get_next_dialogue_line(dlg_node), "completed")
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
			dlg_line = yield(owner.dlg_res.get_next_dialogue_line(dlg_line.next_id), "completed")
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
			dlg_line = yield(owner.dlg_res.get_next_dialogue_line(dlg_line.responses[resp_index].next_id), "completed")
	_mark_room()
	emit_signal("finished")

func _on_Game_accept_pressed():
	emit_signal("accept_pressed")

func clear():
	for entry in dlg.get_children():
		dlg.remove_child(entry)
