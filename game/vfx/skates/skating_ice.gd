extends AnimatedSprite2D
## Skating ice visual effect. Despawns when lifetime ends.

@onready var _lifetime = $Lifetime


func _ready():
	_lifetime.connect("timeout", _on_lifetime_timeout)


func _on_lifetime_timeout():
	queue_free()
