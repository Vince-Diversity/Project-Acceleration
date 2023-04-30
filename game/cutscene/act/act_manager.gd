class_name ActManager extends GDScript

var act_list: Array[Act]
var current_i: int

signal act_list_finished


func _init(act_list_finished_target: Callable):
	act_list_finished.connect(act_list_finished_target)
	current_i = -1


func add_act(act: Act):
	act.act_finished.connect(next_act)
	act_list.push_back(act)


func update_act(delta: float):
	act_list[current_i].update(delta)


func enter_next_act():
	current_i += 1
	if current_i < act_list.size():
		act_list[current_i].enter()
	else:
		end_act_list()

func next_act():
	act_list[current_i].exit()
	enter_next_act()


func end_act_list():
	clear_act_list.call_deferred()
	current_i = -1
	act_list_finished.emit()


func clear_act_list():
	act_list = []


func grab_act_focus():
	act_list[current_i].grab_focus()
