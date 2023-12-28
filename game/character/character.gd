class_name Character extends CharacterBody2D

@export var speed: float = 150
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


func set_animation(anim_name: String):
	anim_sprite.set_animation(anim_name)
	var anim_id = Utils.get_anim_id(anim_name)
	if anim_id != null:
		items.clear_exhibit()
		set_direction(Utils.get_anim_direction(anim_id))
		update_direction()
	else:
		anim_sprite.play(anim_name)


func get_animation() -> String:
	return anim_sprite.animation


func exhibit(item_id: String):
	set_animation("exhibit")
	items.start_exhibit_item(item_id)


func get_anim_name() -> String:
	if inputted_direction == Vector2.ZERO: return ""
	var snapped_direction: Vector2 = Utils.snap_to_compass(inputted_direction)
	var anim_id: int = Utils.anim_direction[snapped_direction]
	return Utils.anim_name[anim_id]
