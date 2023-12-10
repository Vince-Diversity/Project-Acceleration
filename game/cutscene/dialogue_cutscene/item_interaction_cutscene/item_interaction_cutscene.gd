extends DialogueCutscene

var target:
	get:
		return cutscenes.current_source_node.name
