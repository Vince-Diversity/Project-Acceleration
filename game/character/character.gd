class_name Character extends CharacterBody2D

@onready var anim = $AnimatedSprite
@onready var following_area = $FollowingArea
var speed := 100.0
var inputted_direction := Vector2(0, 1)
var party


func move():
	velocity = speed * inputted_direction
	move_and_slide()
	animate_walk()


func animate_walk():
	anim.play(get_anim_name())


func animate_idle():
	anim.stop()


func set_direction(direction: Vector2):
	inputted_direction = direction.normalized()


func update_direction():
	anim.play(get_anim_name())
	anim.set_frame(0)
	anim.stop()


func get_anim_name() -> String:
	var snapped_direction = Utils.snap_to_compass(inputted_direction)
	var anim_id = Utils.anim_direction[snapped_direction]
	var anim_name = Utils.anim_name[anim_id]
	if anim_name == Utils.anim_name[Utils.AnimID.RIGHT]:
		anim_name = Utils.anim_name[Utils.AnimID.LEFT]
		anim.set_flip_h(true)
	else:
		anim.set_flip_h(false)
	return anim_name

