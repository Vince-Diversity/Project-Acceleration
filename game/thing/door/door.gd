class_name Door extends Thing
## Base class for a spawn point
## that is used as an entrance or exit to a [Room] instance.
##
## When interacting with a door,
## the player and other party members primarily change
## to a different [Room] instance.
## If [member next_room_id] does not match any existing room scenes,
## this door will instead be treated as a [Thing] instance,
## which allows cutscenes within the current room to be played.

## [member Room.room_id] of the room instance that this spawn point leads to.
@export var next_room_id: String

## [member Room.entrance_node] of the room instance that this spawn point leads to.
@export var next_room_entrance_node: String

## The direction that the player and any party members takes when spawning at [member spawn_point].
@export var entrance_direction: Utils.AnimID

## Toggles whether this spawn point allows access for
## imaginary party members, see [NPC].
@export var is_gateway: bool = false


## Path to tileset of current room, used for making corners around a door.
@export_file var current_tileset: String = "res://resources/tilesets/"


## Marker to the spawn point position of this door.
@onready var spawn_point: Marker2D = $SpawnPoint



func _ready():
	super()
	_ready_tileset()


func _ready_tileset():
	if ResourceLoader.exists(current_tileset):
		anim_sprite.set_sprite_frames(load(current_tileset))
		anim_sprite.set_animation("default")


## Sets [member entrance_direction] to the given [code]character[/code].
func set_entrance_direction(character: Character):
	character.set_direction(
		Utils.get_anim_direction(entrance_direction))
	character.update_direction()
