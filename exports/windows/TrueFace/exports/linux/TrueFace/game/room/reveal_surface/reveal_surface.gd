class_name RevealSurface extends Node2D
## Node for when the player uses the revealer on the surface below the player.
##
## Surfaces that can be revealed on cells where
## it has a tile data with name "imaginary" that is set to true.

## [Room] tile map layer that is considered the surface that the player is standing on.
@export var tile_map_layer: TileMapLayer

## [member Room.room_id] of the room instance that is revealed.
@export var next_room_id: String

## [member Room.entrance_node] of the room instance that is revealed.
@export var next_room_entrance_node: String

const _imaginary_tile_map_cell_name = "imaginary"


## Check the tile below the player.
## If it has the custom data "imaginary" set to true,
## returns true. Otherwise false.
func is_current_surface_imaginary() -> bool:
	var surface_pos = owner.party.player.ground_checkers.global_position
	var surface_cell = tile_map_layer.local_to_map(surface_pos)
	var surface_cell_data = tile_map_layer.get_cell_tile_data(surface_cell)
	if is_instance_valid(surface_cell_data):
		if surface_cell_data.has_custom_data(_imaginary_tile_map_cell_name):
			return surface_cell_data.get_custom_data(_imaginary_tile_map_cell_name)
	return false
