class_name PlayerSkatingState extends PlayerState
## Player state when using ice skates.
##
## When skating, ice visual effects are spawned under the player.
## The ice visuals have different despawn conditions
## when the player is idle or is moving.
## When idle, one ice visual persists until the player moves or changes states.
## When moving, ice visuals despawn after a set duration.

var _skating_ice_scn: PackedScene = \
	preload("res://game/vfx/skates/skating_ice.tscn")

## Distance counter.
var moved_distance: float

## Stored ice visual during idle state.
var idle_skating_ice: Node2D


## Initialises this class.
func init_state():
	profile_dir_name = "green_skating"

## Changes player sprite and speed to skating.
## Set movement counter so that the next movement frame adds skating ice.
## Enables player movement on water.
func enter():
	# Update player sprite
	var anim_sprite_path = Utils.get_character_sprite_path("green_skating")
	player.anim_sprite.sprite_frames = load(anim_sprite_path)
	player.speed = player.skating_speed
	# Set movement counter
	moved_distance = player.skating_ice_wavelength
	# Enable movement on water
	player.set_collision_mask_value(6, false)


## Despawns persisting visual effects.
## Disables moving over water.
## For good measure, resets movement counter.
func exit():
	# despawns visual effects
	player.vfx_despawned.emit(idle_skating_ice)
	# disables movement on water
	player.set_collision_mask_value(6, true)
	## resets movement counter
	moved_distance = 0


## Moves the player and calls the ordinary walking animation
## (using skating sprites).
## Adds skating ice and resets movement counter at regular intervals.
## Despawns ice that were created during idle state.
func move(delta: float):
	player.move_ordinary()
	moved_distance += delta * player.speed
	# despawns skating ice from idle state.
	player.vfx_despawned.emit(idle_skating_ice)
	if moved_distance > player.skating_ice_wavelength:
		# adds a new ice instance to the scene tree
		var temporary_skating_ice = _skating_ice_scn.instantiate()
		temporary_skating_ice.init_vfx(player.get_node("SkatingIceMark").global_position, true, player.skating_ice_lifetime)
		player.vfx_created.emit(temporary_skating_ice)
		moved_distance = 0


## Plays the default idle animation.
## Spawns skating ice so that the player is always standing on ice.
func animate_idle():
	player.animate_idle()
	if not is_instance_valid(idle_skating_ice):
		# create a persisting ice visual
		idle_skating_ice = _skating_ice_scn.instantiate()
		idle_skating_ice.init_vfx(player.get_node("SkatingIceMark").global_position, false)
		player.vfx_despawned.connect(idle_skating_ice._on_player_vfx_despawned)
		player.vfx_created.emit(idle_skating_ice)
	# prepare movement counter for next movement
	moved_distance = player.skating_ice_wavelength
