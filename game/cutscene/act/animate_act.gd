extends Act

var anim: AnimatedSprite2D
var anim_name: String


func init_act(
		given_anim,
		given_anim_name):
	anim = given_anim
	anim_name = given_anim_name


func update(_delta: float):
	pass


func enter():
	anim.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)
	if anim.sprite_frames.has_animation(anim_name):
		anim.play(anim_name)
	else:
		anim.play("default")


func exit():
	anim.stop()


func grab_focus():
	pass


func _on_animation_finished():
	act_finished.emit()
