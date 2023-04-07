class_name Member extends Character

var is_following: bool


func _on_FollowingArea_area_entered(area: Area2D):
	if area == party.get_next_member(self).following_area:
		is_following = false


func _on_FollowingArea_area_exited(area: Area2D):
	if area == party.get_next_member(self).following_area:
		is_following = true
