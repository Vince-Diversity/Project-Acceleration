class_name AnimateAct extends Act
## Plays out an animation.

## The sprite node to be animated.
var anim: AnimatedSprite2D

## The [AnimatedSprite2D.animation] name to be played.
var anim_name: String


## Initialises this class.
func init_act(
		given_anim,
		given_anim_name):
	anim = given_anim
	anim_name = given_anim_name


## Plays the animation of this act, if it exists, otherwise a default animation is played.
func enter():
	anim.sprite_frames.set_animation_loop(anim_name, false)
	anim.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)
	if anim.sprite_frames.has_animation(anim_name):
		anim.play(anim_name)
	else:
		anim.play("default")


## Stops the animation of this act.
func exit():
	anim.stop()


## Called when the animation of this act finishes.
func _on_animation_finished():
	act_finished.emit()
