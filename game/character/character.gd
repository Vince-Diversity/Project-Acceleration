extends KinematicBody2D

onready var anim = $AnimatedSprite
onready var following_area = $FollowingArea
var velocity := Vector2()
var speed := 100.0
var inputted_direction := Vector2(0, 1)
var party

func move():
	velocity = speed * inputted_direction
	velocity = move_and_slide(velocity)
	animate_walk()

func animate_walk():
	var snapped_direction = Utils.snap_to_compass(inputted_direction)
	var anim_id = Utils.anim_direction[snapped_direction]
	var anim_name = Utils.anim_name[anim_id]
	if anim_name == Utils.anim_name[Utils.AnimID.RIGHT]:
		anim_name = Utils.anim_name[Utils.AnimID.LEFT]
		anim.set_flip_h(true)
	else:
		anim.set_flip_h(false)
	anim.play(anim_name)

func animate_idle():
	pass
	anim.stop()

func set_direction(direction: Vector2):
	inputted_direction = direction.normalized()
