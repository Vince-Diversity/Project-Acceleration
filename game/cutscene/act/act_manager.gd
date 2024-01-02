class_name ActManager extends GDScript
## Manages a list of [Act] instances.
##
## This manager class determines which [Act] is the current act
## to be played out during a cutscene.
## The [member act_list] supports having new entires appended to the end of the list
## while any act is played out.

## The current list of acts.
var act_list: Array[Act]

## Index of the current act in the act list.
var current_i: int

## Emitted when the end of the [member act_list] is reached.
signal act_list_finished


## Initialises this class, assigning the target of the [signal act_list_finished] signal.
## [code]act_list_finished_target[/code].
func _init(act_list_finished_target: Callable):
	act_list_finished.connect(act_list_finished_target)
	current_i = -1


## Adds the given [code]act[/code] to the end of the act list.
func add_act(act: Act):
	act.act_finished.connect(_next_act)
	act_list.push_back(act)


## Called at every frame update.
func update_act(delta: float):
	act_list[current_i].update(delta)


## Enters the next [Act] in the current act list,
## or signals that the act list has finished if at the last act.
func enter_next_act():
	current_i += 1
	if current_i < act_list.size():
		act_list[current_i].enter()
	else:
		_end_act_list()

func _next_act():
	act_list[current_i].exit()
	enter_next_act()


func _end_act_list():
	_clear_act_list.call_deferred()
	current_i = -1
	act_list_finished.emit()


func _clear_act_list():
	act_list = []


## Manages the current focus.
func grab_act_focus():
	act_list[current_i].grab_focus()
