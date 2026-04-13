extends Node2D
## Spawner for teardrop [AnimationSprite2D] instances.


## Minimum time between teardrops.
@export var min_delay: float = 1.0

## Maximum time between teardrops.
@export var max_delay: float = 2.0

@onready var teardrop_scn = preload("res://game/effect/teardrop/teardrop.tscn")

## Timer for adding teardrops.
var timer: Timer

## RNG instance for this teardrop's timer.
var timer_rng: RandomNumberGenerator

## Current teardrop instance.
var teardrop: AnimatedSprite2D


func _ready():
	init_teardrops()


## Initialises this class before it is added to the [SceneTree].
## Initializes the random number generator with a random seed.
func init_teardrops():
	timer_rng = RandomNumberGenerator.new()
	timer_rng.randomize()
	timer = Timer.new()
	timer.connect("timeout", _on_timer_timeout)
	timer.wait_time = timer_rng.randf_range(min_delay, max_delay)
	add_child(timer)
	timer.start()


## Adds a teardrop to the [SceneTree].
func add_teardrop():
	teardrop = teardrop_scn.instantiate()
	teardrop.connect("animation_finished", _on_sprite_animation_finished)
	add_child(teardrop)
	teardrop.play()


func _on_timer_timeout():
	timer.wait_time = timer_rng.randf_range(min_delay, max_delay)
	add_teardrop()


func _on_sprite_animation_finished():
	teardrop.queue_free()
