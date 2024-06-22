class_name Character extends CharacterBody2D
## Base scene for the [Player] or [NPC] scenes.
##
## A character has a sprite, collision and a following area node.
## The latter is used to enable party members to follow the next party member or player
## when the player moves around in the environment.
## The order in which party members follow each other is given by [method Party.get_party_ordered].
## A character also has markers for special animations such as when showing an item,
## see [Items].

## Default walking speed
const default_speed: float = 150

## How fast this character moves.
@export var speed: float = default_speed

## Reference to the character's sprite.
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

## Reference to the area of the character which checks for following of party members.
@onready var following_area: Area2D = $FollowingArea

## Reference to the character's collision.
@onready var collision: CollisionShape2D = $CollisionShape2D

## Reference to the character's items node.
@onready var items: Items = $Items

## The current direction that was inputted or otherwise assigned to this character.
var inputted_direction := Vector2(0, 1)

## Reference to a party which this character may be part of.
var party: Party


## Called at every frame to determine character movement.
func roam():
	pass


## Moves this character and plays the walking animation.
func move():
	velocity = speed * inputted_direction
	move_and_slide()
	_animate_walk()


func _animate_walk():
	anim_sprite.play(_get_anim_name())


## Stops movement animation to have the player be at its idle frame,
## which is by convention the first frame of the movement animation.
func animate_idle():
	anim_sprite.stop()


## Sets the character's [code]direction[/code] before it is used
## for updating the direction or playing a directional movement animation.
func set_direction(direction: Vector2):
	inputted_direction = direction.normalized()


## Updates the character's direction.
func update_direction():
	if anim_sprite.sprite_frames.has_animation(_get_anim_name()):
		anim_sprite.play(_get_anim_name())
		anim_sprite.set_frame(0)
		anim_sprite.stop()


## Sets the character's direction given by the movement animation name [code]anim_name[/code],
## or, if the animation does not correponds to any movement direction, plays it like a regular animation.
## Also disables animation looping by default.
## Optionally, a looping animation is played when [code]loop_toggle[/code] is true.
func set_animation(anim_name: String, loop_toggle: bool = false):
	anim_sprite.set_animation(anim_name)
	var anim_id = Utils.get_anim_id(anim_name)
	items.clear_exhibit()
	anim_sprite.sprite_frames.set_animation_loop(anim_name, loop_toggle)
	if anim_id != null:
		set_direction(Utils.get_anim_direction(anim_id))
		update_direction()
		if loop_toggle:
			# also play the animation to loop it
			anim_sprite.play()
	else:
		anim_sprite.play(anim_name)


## Plays an animation where the character shows the [ItemSprite] with the given [code]item_id[/code].
func exhibit(item_id: String):
	set_animation("exhibit")
	items.start_exhibit_item(item_id)


## Plays an animation where the [ItemSprite] with the given [code]item_id[/code]
## floats above the character.
func float_item_above(item_id: String):
	items.start_floating_item(item_id)


func _get_anim_name() -> String:
	if inputted_direction == Vector2.ZERO: return ""
	var snapped_direction: Vector2 = Utils.snap_to_compass(inputted_direction)
	var anim_id: int = Utils.anim_direction[snapped_direction]
	return Utils.anim_name[anim_id]
