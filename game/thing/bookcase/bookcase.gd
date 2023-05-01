extends Thing

const bookcase_sprite_frames := preload("res://resources/things/bookcase.tres")
const bookcase_txr_dir: String = "res://assets/things/bookcase_books/"
const bookcase_taken_txr_dir: String = "res://assets/things/bookcase_book_taken/"
@onready var bookcase_book_frames = SpriteFrames.new()


func set_rng(thing_rng: RandomNumberGenerator):
	var sprite_frames = anim_sprite.sprite_frames.duplicate()
	remove_child(anim_sprite)
	anim_sprite = AnimatedSprite2D.new()
	anim_sprite.sprite_frames = sprite_frames
	add_child(anim_sprite)
	move_child(anim_sprite, 0)
	var bookcase_txr_path_arr = Utils.get_res_arr(bookcase_txr_dir)
	var txr_i = thing_rng.randi_range(0, bookcase_txr_path_arr.size()-1)
	var bookcase_txr: Texture = load(bookcase_txr_dir.path_join(bookcase_txr_path_arr[txr_i]))
	anim_sprite.sprite_frames.clear(Names.bookcase_anim)
	anim_sprite.sprite_frames.add_frame(Names.bookcase_anim, bookcase_txr)
	var bookcase_taken_txr_path_arr = Utils.get_res_arr(bookcase_taken_txr_dir)
	var bookcase_taken_txr: Texture = load(bookcase_taken_txr_dir.path_join(bookcase_taken_txr_path_arr[txr_i]))
	anim_sprite.sprite_frames.clear(Names.bookcase_taken_anim)
	anim_sprite.sprite_frames.add_frame(Names.bookcase_taken_anim, bookcase_taken_txr)
	anim_sprite.set_animation(Names.bookcase_anim)
