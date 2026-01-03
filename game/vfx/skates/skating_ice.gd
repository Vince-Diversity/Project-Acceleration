extends AnimatedSprite2D
## Skating ice visual effect. Despawns when lifetime ends.

## Duration
var lifetime: float = 1

func _ready():
	var lifetime_timer = Timer.new()
	lifetime_timer.autostart = true
	lifetime_timer.wait_time = lifetime
	lifetime_timer.connect("timeout", _on_lifetime_timeout)
	add_child(lifetime_timer)


## Initialises this class.
func init_vfx(given_global_position: Vector2, given_lifetime: float):
	global_position = given_global_position
	lifetime = given_lifetime


func _on_lifetime_timeout():
	queue_free()
