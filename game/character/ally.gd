extends "res://game/character/character.gd"

var is_following: bool

func _on_FollowingArea_area_entered(area):
	if area == party.get_next_ally(self).following_area:
		is_following = false

func _on_FollowingArea_area_exited(area):
	if area == party.get_next_ally(self).following_area:
		is_following = true
