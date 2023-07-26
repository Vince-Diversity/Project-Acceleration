extends Act

var actm_list: Array[ActManager]
var finish_counter: int = 0


func init_act(act_matrix: Array):
	for actm_i in act_matrix.size():
		if not act_matrix[actm_i].is_empty():
			var actm: GDScript = ActManager.new(actm_finished)
			actm_list.append(actm)
			for act_j in act_matrix[actm_i]:
				actm.add_act(act_j)


func actm_finished():
	finish_counter += 1
	if finish_counter == actm_list.size():
		act_finished.emit()


func update(delta: float):
	for actm in actm_list:
		actm.update_act(delta)


# Start all act lists simultaneously
func enter():
	for actm in actm_list:
		actm.enter_next_act()


func exit():
	clear_actm_list.call_deferred()
	finish_counter = 0


func clear_actm_list():
	actm_list = []


# Whichever focusable act is added last gets the focus
func grab_focus():
	for actm in actm_list:
		actm.grab_focus()
