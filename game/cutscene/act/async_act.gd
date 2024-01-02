class_name AsyncAct extends Act
## A meta act that plays lists of acts in parallel.

## List of act lists contained within each act manager
var actm_list: Array[ActManager]

## Counter for how many act lists that have reached the end.
var finish_counter: int = 0


## Initalises this class.
func init_act(act_matrix: Array):
	for actm_i in act_matrix.size():
		if not act_matrix[actm_i].is_empty():
			var actm: GDScript = ActManager.new(actm_finished)
			actm_list.append(actm)
			for act_j in act_matrix[actm_i]:
				actm.add_act(act_j)


## Called when an act list in this act has finished.
func actm_finished():
	finish_counter += 1
	if finish_counter == actm_list.size():
		act_finished.emit()


## Calls [method Act.update] the current act in each act list at every frame.
func update(delta: float):
	for actm in actm_list:
		if actm.act_list.is_empty(): continue
		actm.update_act(delta)


## Starts all act lists simultaneously.
func enter():
	for actm in actm_list:
		actm.enter_next_act()
