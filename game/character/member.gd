class_name Member extends Character

var is_following: bool


func roam():
	_set_following_direction()
	if is_following:
		move()
	else:
		animate_idle()


func _set_following_direction():
	var next_member: Character = get_next_member()
	var direction: Vector2 = next_member.global_position - global_position
	set_direction(direction)


func _on_FollowingArea_area_entered(area: Area2D):
	if area == get_next_member().following_area:
		is_following = false


func _on_FollowingArea_area_exited(area: Area2D):
	if area == get_next_member().following_area:
		is_following = true


func get_next_member() -> Character:
	return party.get_next_member(self)
