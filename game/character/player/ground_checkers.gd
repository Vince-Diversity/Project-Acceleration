class_name GroundCheckers extends Node2D
## Manages class instances that determine what physics layer the player is currently on.
##
## The player can cross physics layers depending on their [PlayerState].
## This class is used to check if the player is allowed to change states
## on certain physics layers. If not allowed, a dialogue plays.


## What physics layer the player is currently on,
## or [member Utils.PhysicsLayer.NONE] if the player is not on any physics layer.
var current_physics_layer: Utils.PhysicsLayer = Utils.PhysicsLayer.NONE


## Updates the [member current_physics_layer] to what physics layer the player is currently on.
## Assumes that areas on a tilemap can have at most one physics layer.
func update_ground_checker():
	for checker in get_children():
		if checker.has_overlapping_bodies():
			current_physics_layer = checker.physics_layer
			return
	current_physics_layer = Utils.PhysicsLayer.NONE
