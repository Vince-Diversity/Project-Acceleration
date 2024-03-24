extends RichTextLabel

func _ready():
	text = "Version %s\n" % ProjectSettings.get_setting("application/config/version")
	append_text("Controls: Arrow keys, Z, S or Esc and you'll see more later...\n")
