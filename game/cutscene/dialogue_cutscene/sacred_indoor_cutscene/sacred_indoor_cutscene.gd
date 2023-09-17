extends DialogueCutscene

@onready var sacred_mark = $SacredMark1
var is_sacred_joined: bool = false

func check_sacred_joined():
	if owner.party.has_node("Sacred"):
		is_sacred_joined = true
	else:
		is_sacred_joined = false


func make_move_party() -> Act:
	return make_move(
		owner.party.get_party_ordered(),
		[mentor_mark, student_mark, sacred_mark])
