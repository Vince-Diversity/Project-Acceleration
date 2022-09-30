extends Resource

static func make(resp, dlg, resp_line, resp_index: int) -> void:
	resp.prompt(resp_line.prompt)
	resp.index = resp_index
	resp.connect("selected", dlg, "_on_Response_selected")
