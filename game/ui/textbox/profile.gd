class_name Profile extends TextureRect
## Profile image of a character that is displayed during a dialogue.
##
## Profile image assets have the format "<character ID>_<expression ID>.png"
## if the profile image has an expression with that ID, otherwise it is just "<character ID>.png".
## The character ID is also the [DialogueLine] replacement variable of a character.
## For example, the player character ID is [code]green[/code].

func express(expression: String):
	var character_id = get_character_id(owner.dialogue_line)
	var profile_path = get_profile_path(character_id, expression)
	if ResourceLoader.exists(profile_path):
		set_texture(load(profile_path))
	else:
		set_texture(load(get_profile_path(owner.dialogue_line, "")))
	owner.profile_background.set_visible(true)


## Gets path to the profile [code].png[/code] asset of the character
## with the given character ID [code]name[/code] and expression ID [code]expression[/code].
func get_profile_path(character_name: String, expression: String) -> String:
	var profile_id
	if expression.is_empty():
		profile_id = character_name
	else:
		profile_id = "%s_%s" % [character_name, expression]
	return Utils.profile_dir.path_join(character_name).path_join(profile_id + ".png")


## Gets the character ID from the given [code]dlg_line[/code].
func get_character_id(dlg_line: DialogueLine) -> String:
	return dlg_line.character_replacements[0].expression[0].value
