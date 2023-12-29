class_name Settings extends CanvasLayer
## Menu for configuring the [BGMPlayer]
## and other desirable nodes.
##
## Uses the [TogglingCheckButton] to make changes to nodes whenever it is toggled.


@onready var _return_node = $Margin/MenuContainer/Return
@onready var _bgm = $Margin/MenuContainer/BGM/BGMButton
@onready var _bgm_check = $Margin/MenuContainer/BGM/CheckButton

## Reference to the menu node that had focus
## before this settings node was added to the scene tree.
## Used for returning to the previous menu later.
var previous_menu: Node

## Reference to the parent of the node in [member previous_menu]
## before this settings node was added to the scene tree.
## Assigning this allows the previous node to be a menu that gets freed
## when this menu is opened.
var previous_parent: Node

## Reference to the desired focus of the previous menu node
## before this settings node was added to the scene tree.
## Used for returning to the previous menu later.
var previous_focus: Control

## Reference to [BGMPlayer].
var bgm_player: BGMPlayer


func _ready():
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	_ready_menu()
	_ready_bgm()
	_return_node.grab_focus()


func _ready_menu():
	_return_node.pressed.connect(_on_return_pressed)
	_bgm.pressed.connect(_on_bgm_pressed)


func _ready_bgm():
	_bgm_check.set_pressed(bgm_player.sound_toggle)


## Initialises this node before it is added to the scene tree.
func init_settings(
		given_menu: Node,
		given_parent: Node,
		focus: Node,
		given_bgm_player: AudioStreamPlayer,
		):
	previous_menu = given_menu
	previous_parent = given_parent
	previous_focus = focus
	bgm_player = given_bgm_player


func _on_return_pressed():
	previous_parent.add_child(previous_menu)
	previous_focus.grab_focus()
	queue_free()


func _on_bgm_pressed():
	_bgm_check.toggle(_bgm_pressed_callable)


func _bgm_pressed_callable(is_mode_toggled: bool):
	bgm_player.sound_toggle = is_mode_toggled
