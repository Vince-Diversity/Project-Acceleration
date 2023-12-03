class_name ItemBubble extends Bubble

@onready var anim_player: AnimationPlayer = $AnimationPlayer
var current_item


func _ready():
	anim_player.play("indicator")


func add_item(item_id):
	var item_path = Utils.get_item_path(item_id)
	if ResourceLoader.exists(item_path):
		current_item = load(item_path).instantiate()
		add_child(current_item)


func close():
	queue_free()
