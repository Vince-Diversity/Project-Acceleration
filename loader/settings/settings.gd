extends CanvasLayer

@onready var return_node = $Margin/MenuContainer/Return
@onready var bgm = $Margin/MenuContainer/BGM/BGMButton
@onready var bgm_check = $Margin/MenuContainer/BGM/CheckButton
var previous_menu: Node
var previous_menu_parent: Node
var previous_focus: Control
var bgm_player: BGMPlayer


func _ready():
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	_ready_menu()
	_ready_bgm()
	return_node.grab_focus()


func _ready_menu():
	return_node.pressed.connect(_on_return_pressed)
	bgm.pressed.connect(_on_bgm_pressed)


func _ready_bgm():
	bgm_check.set_pressed(bgm_player.sound_toggle)


func init_settings(
		given_menu: Node,
		given_menu_parent: Node,
		focus: Node,
		given_bgm_player: AudioStreamPlayer,
		):
	previous_menu = given_menu
	previous_menu_parent = given_menu_parent
	previous_focus = focus
	bgm_player = given_bgm_player


func _on_return_pressed():
	previous_menu_parent.add_child(previous_menu)
	previous_focus.grab_focus()
	queue_free()


func _on_bgm_pressed():
	bgm_check.toggle(_bgm_pressed_callable)


func _bgm_pressed_callable(is_mode_toggled: bool):
	bgm_player.sound_toggle = is_mode_toggled
