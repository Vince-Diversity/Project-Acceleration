extends TextureRect

const neutral := ""
const cheerful := "cheerful"


func express(expression: String):
	var profile_path = Utils.get_profile_path(owner.dialogue_line, expression)
	if FileAccess.file_exists(profile_path):
		set_texture(load(profile_path))
	owner.profile_background.set_visible(true)