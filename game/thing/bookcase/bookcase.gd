extends Thing

const bookcase_txr_dir: String = "res://assets/things/bookcase_books/"
@onready var bookcase_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var bookcase_book_frames = SpriteFrames.new()


func set_rng(thing_rng: RandomNumberGenerator):
	var bookcase_txr_path_arr = Utils.get_res_arr(bookcase_txr_dir)
	var bookcase_txr_i = thing_rng.randi_range(0, bookcase_txr_path_arr.size()-1)
	var bookcase_txr: Texture = load(bookcase_txr_dir.path_join(bookcase_txr_path_arr[bookcase_txr_i]))
	bookcase_sprite.sprite_frames.clear("default")
	bookcase_sprite.sprite_frames.add_frame("default", bookcase_txr)
