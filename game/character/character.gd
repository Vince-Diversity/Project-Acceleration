class_name Character extends CharacterBody2D

@export var speed: float = 150
@export var is_symmetric: bool = true
@onready var anim = $AnimatedSprite2D
@onready var following_area = $FollowingArea
var inputted_direction := Vector2(0, 1)
var party: Party


func init_character(given_party: Party):
	party = given_party


func roam():
	pass


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
	if anim.sprite_frames.has_animation(get_anim_name()):
		anim.play(get_anim_name())
		anim.set_frame(0)
		anim.stop()


func update_angle():
	pass


func set_animation(anim_name: String):
	anim.set_animation(anim_name)
	var anim_id = Utils.get_anim_id(anim_name)
	if anim_id != null:
		set_direction(Utils.get_anim_direction(anim_id))
		update_direction()


func get_anim_name() -> String:
	var snapped_direction: Vector2 = Utils.snap_to_compass(inputted_direction)
	var anim_id: int = Utils.anim_direction[snapped_direction]
	if anim_id == Utils.AnimID.RIGHT and is_symmetric:
		anim_id = Utils.AnimID.LEFT
		anim.set_flip_h(true)
	else:
		anim.set_flip_h(false)
	return Utils.anim_name[anim_id]
