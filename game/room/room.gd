extends Control

onready var ui = $UI
var dlg_res: Resource

func run_room():
	ui.load_ui()
	ui.text_box.run_text()
