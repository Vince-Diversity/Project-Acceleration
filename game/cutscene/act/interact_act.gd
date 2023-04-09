extends Act

var dialogue_id: String
var dialogue_node: String

signal textbox_started(
		dialogue_id: String,
		dialogue_node: String,
		dialogue_ended_target: Callable)
signal textbox_focused


func init_act(
		textbox_started_target: Callable,
		given_dialogue_id: String,
		given_dialogue_node: String,
		textbox_focused_target: Callable):
	textbox_started.connect(textbox_started_target)
	dialogue_id = given_dialogue_id
	dialogue_node = given_dialogue_node
	textbox_focused.connect(textbox_focused_target)


func update(_delta: float):
	pass


func enter():
	textbox_started.emit(dialogue_id, dialogue_node, _on_dialogue_ended)


func exit():
	pass


func _on_dialogue_ended(_dlg_res: DialogueResource):
	act_finished.emit()


func grab_focus():
	textbox_focused.emit()
