extends Thing

const bookcase_txr_dir: String = "res://assets/things/bookcase_books/"
const bookcase_taken_txr_dir: String = "res://assets/things/bookcase_book_taken/"
@onready var bookcase_book_frames = SpriteFrames.new()


func set_rng(thing_rng: RandomNumberGenerator):
	var bookcase_txr_path_arr = Utils.get_res_arr(bookcase_txr_dir)
	var txr_i = thing_rng.randi_range(0, bookcase_txr_path_arr.size()-1)
	var bookcase_txr: Texture = load(bookcase_txr_dir.path_join(bookcase_txr_path_arr[txr_i]))
	anim_sprite.sprite_frames.clear(Names.bookcase_anim)
	anim_sprite.sprite_frames.add_frame(Names.bookcase_anim, bookcase_txr)
	var bookcase_taken_txr_path_arr = Utils.get_res_arr(bookcase_taken_txr_dir)
	var bookcase_taken_txr: Texture = load(bookcase_taken_txr_dir.path_join(bookcase_taken_txr_path_arr[txr_i]))
	anim_sprite.sprite_frames.add_animation(Names.bookcase_taken_anim)
	anim_sprite.sprite_frames.add_frame(Names.bookcase_taken_anim, bookcase_taken_txr)
