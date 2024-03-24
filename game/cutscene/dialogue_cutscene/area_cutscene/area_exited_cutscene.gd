class_name AreaExitedCutscene extends AreaCutscene
# An [AreaCutscene] that activates when leaving its area.


func init_cutscene(given_cutscenes: RoomCutscenes, given_screen: Screen):
	super(given_cutscenes, given_screen)
	event_area.body_exited.connect(_on_area_cutscene_body_exited)


func _on_area_cutscene_body_exited(body: PhysicsBody2D):
	if is_body_valid(body):
		area_cutscene_started.emit(name, dialogue_id, dialogue_node)
