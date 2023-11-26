extends TextureRect

func express(expression: String):
	var profile_path = Utils.get_profile_path(owner.dialogue_line, expression)
	if ResourceLoader.exists(profile_path):
		set_texture(load(profile_path))
	else:
		set_texture(load(Utils.get_profile_path(owner.dialogue_line, "")))
	owner.profile_background.set_visible(true)
