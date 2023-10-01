class_name RestState extends GameState

var start_cutscene_target: Callable
var stand_up_node_name: String
var stand_up_source_node: Node2D


func init_state(given_start_cutscene_target: Callable):
	start_cutscene_target = given_start_cutscene_target


func make_state(
		given_stand_up_node_name: String,
		given_stand_up_source_node: Node2D):
	stand_up_node_name = given_stand_up_node_name
	stand_up_source_node = given_stand_up_source_node


func update(_delta: float):
	pass


func handle_input(event: InputEvent):
	if event.is_action_pressed("ui_accept") \
	or event.is_action_pressed("ui_down") \
	or event.is_action_pressed("ui_right") \
	or event.is_action_pressed("ui_up") \
	or event.is_action_pressed("ui_left"):
		start_cutscene_target.call(
			stand_up_node_name,
			"",
			"",
			stand_up_source_node)


func enter():
	pass


func exit():
	pass


func grab_focus():
	pass


func save(game: Game, sg: SaveGame):
	super(game, sg)
	for node in stand_up_source_node.owner.cutscenes.get_tree().get_nodes_in_group("Preserved"):
		if node == stand_up_source_node:
			if not node.has_method("make_preserved_save"): continue
			node.make_preserved_save(sg)
		else:
			if not node.has_method("make_save"): continue
			node.make_save(sg)
