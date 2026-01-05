class_name SkatingIce extends AnimatedSprite2D
## Skating ice visual effect.
##
## By default, ice visuals despawn when the lifetime duration ends.
## Optionally, the ice visual can persist without a lifetime.

## Toggle for ice visual without duration.
var has_lifetime: bool

## Duration.
var lifetime: float

func _ready():
	if has_lifetime:
		var lifetime_timer = Timer.new()
		lifetime_timer.autostart = true
		lifetime_timer.wait_time = lifetime
		lifetime_timer.connect("timeout", despawn)
		add_child(lifetime_timer)


## Initialises this class.
func init_vfx(
		given_global_position: Vector2,
		given_lifetime_toggle: bool,
		given_lifetime: float = 1):
	global_position = given_global_position
	has_lifetime = given_lifetime_toggle
	lifetime = given_lifetime


## Removes this ice visual from the [SceneTree].
func despawn():
	queue_free()


func _on_player_vfx_despawned(vfx_visual: Node2D):
	if vfx_visual == self:
		despawn()
