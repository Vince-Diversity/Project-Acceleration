extends KinematicBody2D

onready var anim = $AnimatedSprite
var velocity := Vector2()
var speed := 100.0
var inputted_direction := Vector2()

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
	anim.stop()
	anim.set_frame(0)

func update_input_direction():
	inputted_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
