extends RichTextLabel

func _ready():
	bbcode_text = "Version %s\n" % ProjectSettings.get_setting("application/config/version")
	bbcode_text += "Controls: Arrow keys, Space, Esc, Mouse\n"
