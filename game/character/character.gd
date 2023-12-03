class_name Character extends CharacterBody2D

@export var speed: float = 150
@export var is_symmetric: bool = true
@onready var anim_sprite = $AnimatedSprite2D
@onready var following_area = $FollowingArea
@onready var collision = $CollisionShape2D
@onready var items = $Items
var inputted_direction := Vector2(0, 1)
var party: Party


func roam():
	pass


func move():
	velocity = speed * inputted_direction
	move_and_slide()
	animate_walk()


func animate_walk():
	anim_sprite.play(get_anim_name())


func animate_idle():
	anim_sprite.stop()


func set_direction(direction: Vector2):
	inputted_direction = direction.normalized()


func update_direction():
	if anim_sprite.sprite_frames.has_animation(get_anim_name()):
		anim_sprite.play(get_anim_name())
		anim_sprite.set_frame(0)
		anim_sprite.stop()


func update_angle():
	pass


func set_animation(anim_name: String):
	items.clear_exhibit()
	anim_sprite.set_animation(anim_name)
	var anim_id = Utils.get_anim_id(anim_name)
	anim_sprite.play()
	if is_instance_valid(anim_id):
		set_direction(Utils.get_anim_direction(anim_id))
		update_direction()
	else:
		anim_sprite.set_flip_h(false)


func set_exhibit_animation(item_id: String):
	set_animation("exhibit")
	items.set_exhibit_item(item_id)


func get_anim_name() -> String:
	if inputted_direction == Vector2.ZERO: return ""
	var snapped_direction: Vector2 = Utils.snap_to_compass(inputted_direction)
	var anim_id: int = Utils.anim_direction[snapped_direction]
	if anim_id == Utils.AnimID.RIGHT and is_symmetric:
		anim_id = Utils.AnimID.LEFT
		anim_sprite.set_flip_h(true)
	else:
		anim_sprite.set_flip_h(false)
	return Utils.anim_name[anim_id]
