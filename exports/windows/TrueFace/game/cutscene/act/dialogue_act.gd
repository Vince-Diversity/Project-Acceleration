class_name DialogueAct extends Act
## Plays out a dialogue.

## Filename of the [DialogueResource] containing the dialogue of this act.
var dialogue_id: String

## Title of the dialogue of this act, see [method DialogueResource.get_next_dialogue_line].
var dialogue_node: String

## Reference to the cutscene that contains this act.
var cutscene: DialogueCutscene

## Emitted when this act starts a [TextBox],
## passing the members of this act and the function [code]dialogue_ended_target[/code]
## which is called when the text box closes.
signal textbox_started(
		dialogue_id: String,
		dialogue_node: String,
		dialogue_ended_target: Callable,
		cutscene: DialogueCutscene)

## Emitted when the text box [Control] node that this act starts receives focus.
signal textbox_focused


## Initialises this class.
func init_act(
		textbox_started_target: Callable,
		given_dialogue_id: String,
		given_dialogue_node: String,
		textbox_focused_target: Callable,
		given_cutscene: DialogueCutscene):
	textbox_started.connect(textbox_started_target)
	dialogue_id = given_dialogue_id
	dialogue_node = given_dialogue_node
	textbox_focused.connect(textbox_focused_target)
	cutscene = given_cutscene


## Starts the [TextBox] which is used for the dialogue of this act.
func enter():
	textbox_started.emit(dialogue_id, dialogue_node, _on_dialogue_ended, cutscene)


## Directs the focus onto the [TextBox] used for this act.
func grab_focus():
	textbox_focused.emit()


## Called when the [TextBox] used for this act closes.
func _on_dialogue_ended(_dlg_res: DialogueResource):
	act_finished.emit()
