class_name Door extends Thing

@export var next_room_id: String
@export var next_room_entrance_node: String
@export var entrance_direction: Utils.AnimID
@onready var spawn_point = $SpawnPoint

func set_entrance_direction(character: Character):
	character.set_direction(
		Utils.get_anim_direction(entrance_direction))
	character.update_direction()
