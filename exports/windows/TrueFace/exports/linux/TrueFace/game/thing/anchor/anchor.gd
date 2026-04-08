extends Thing

@onready var anim_player = $AnimationPlayer


func _ready():
	super()
	anim_player.play("drift")
