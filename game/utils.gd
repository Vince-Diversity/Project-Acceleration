extends Node

const dlg_dir = "res://game/room/"
const room_dir = "res://game/room/"

enum InputType {RESPONSE, ACTION, REACTIVATION}

func connect_neighbouring_elems(arr: Array) -> void:
	if arr.size() > 1:
		arr[0].focus_neighbour_bottom = arr[1].get_path()
		arr[-1].focus_neighbour_top = arr[-2].get_path()
		if arr.size() > 2:
			for i in range(1, arr.size()-2):
				arr[i].focus_neighbour_top = arr[i-1].get_path()
				arr[i].focus_neighbour_bottom = arr[i+1].get_path()

func get_res_filename(res: Resource) -> String:
	return res.get_path().get_file().trim_suffix("." + res.get_path().get_extension())

func get_dlg_path(dlg_name) -> String:
	return Utils.dlg_dir + dlg_name + ".tres"

func get_action_state_name(dlg_name: String, action_id: String) -> String:
	return dlg_name + '_' + Names.action_suffix[action_id]

func scroll_to_bottom(scroll_bar: ScrollBar) -> void:
	scroll_bar.value = scroll_bar.max_value
