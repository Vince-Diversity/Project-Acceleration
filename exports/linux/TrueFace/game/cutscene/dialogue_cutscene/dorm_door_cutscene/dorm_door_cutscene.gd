class_name DormDoorCutscene extends DialogueCutscene
## Custom dialogue cutscene when interacting with numbered doors.

## The doors in the current [Room] are numbered as
## 101, 102, ... on the first floor,
## 201, 202, ... on the second floor, etc.
## The convention used for [member Room.room_id] for floors is 
## "<prefix>_1f", "<prefix>_2f", etc, and for the door node names
## "<door>1", "<door>2", etc.
var door_number: String:
	get:
		var floor_number = owner.name.to_int()
		var number = cutscenes.current_source_node.name.to_int()
		if number > 0: door_number = "%d%02.0d" % [floor_number, number]
		return door_number
