class_name CustomDialogueLabel extends RichTextLabel
## Writes out text for dialogue.
##
## Edited version of the dialogue label from Dialogue addon v2.14.1
## with some quickfixes from v2.16.1,
## see [url]https://github.com/nathanhoad/godot_dialogue_manager/releases/tag/v2.14.1[/url].

signal spoke(letter: String, letter_index: int, speed: float)
signal paused_typing(duration: float)
signal finished_typing()


## The action to press to skip typing
@export var skip_action: String = "ui_cancel"

## The speed with which the text types out
@export var seconds_per_step: float = 0.02

## Automatically have a brief pause when these characters are encountered
@export var pause_at_characters: String = "."


var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		dialogue_line = next_dialogue_line
		custom_minimum_size = Vector2.ZERO
		text = dialogue_line.text
	get:
		return dialogue_line

var last_wait_index: int = -1
var last_mutation_index: int = -1
var waiting_seconds: float = 0

var is_typing: bool = false:
	set(value):
		if is_typing != value and value == false:
			finished_typing.emit()
		is_typing = value
	get:
		return is_typing


func _process(delta: float) -> void:
	if self.is_typing:
		# Type out text
		if visible_ratio < 1:
			# See if we are waiting
			if waiting_seconds > 0:
				waiting_seconds = waiting_seconds - delta
			# If we are no longer waiting then keep typing
			if waiting_seconds <= 0:
				type_next(delta, waiting_seconds)
		else:
			self.is_typing = false


func _unhandled_input(event: InputEvent) -> void:
	if self.is_typing and visible_ratio < 1 and event.is_action_pressed(skip_action):
		# Run any inline mutations that haven't been run yet
		for i in range(visible_characters, get_total_character_count()):
			mutate_inline_mutations(i)
		visible_characters = get_total_character_count()
		self.is_typing = false
		finished_typing.emit()
		

# Start typing out the text
func type_out() -> void:
	text = dialogue_line.text
	visible_characters = 0
	self.is_typing = true
	waiting_seconds = 0
	
	# Text isn't calculated until the next frame
	await get_tree().process_frame
	
	if get_total_character_count() == 0:
		self.is_typing = false
	elif seconds_per_step == 0:
		# Run any inline mutations
		for i in range(0, get_total_character_count()):
			dialogue_line.mutate_inline_mutations(i)
		visible_characters = get_total_character_count()
		self.is_typing = false


# Type out the next character(s)
func type_next(delta: float, seconds_needed: float) -> void:
	if visible_characters == get_total_character_count():
		return
	
	if last_mutation_index != visible_characters:
		last_mutation_index = visible_characters
		mutate_inline_mutations(visible_characters)
	
	var additional_waiting_seconds: float = get_pause(visible_characters)
	
	# Pause on characters like "."
	if visible_characters > 0 and get_parsed_text()[visible_characters - 1] in pause_at_characters.split():
		additional_waiting_seconds += seconds_per_step * 15
	
	# Pause at literal [wait] directives
	if last_wait_index != visible_characters and additional_waiting_seconds > 0:
		last_wait_index = visible_characters
		waiting_seconds += additional_waiting_seconds
		paused_typing.emit(get_pause(visible_characters))
	else:
		visible_characters += 1
		seconds_needed += seconds_per_step * (1.0 / get_speed(visible_characters))
		if seconds_needed > delta:
			waiting_seconds += seconds_needed
			if visible_characters < get_total_character_count():
				spoke.emit(text[visible_characters - 1], visible_characters - 1, get_speed(visible_characters))
		else:
			type_next(delta, seconds_needed)


# Get the pause for the current typing position if there is one
func get_pause(at_index: int) -> float:
	return dialogue_line.pauses.get(at_index, 0)


# Get the speed for the current typing position
func get_speed(at_index: int) -> float:
	var speed: float = 1
	for index in dialogue_line.speeds:
		if index > at_index:
			return speed
		speed = dialogue_line.speeds[index]
	return speed


# Run any mutations at the current typing position
func mutate_inline_mutations(index: int) -> void:
	for inline_mutation in dialogue_line.inline_mutations:
		# inline mutations are an array of arrays in the form of [character index, resolvable function]
		if inline_mutation[0] > index:
			return
		if inline_mutation[0] == index:
			# The DialogueManager can't be referenced directly here so we need to get it by its path
			Engine.get_singleton("DialogueManager").mutate(inline_mutation[1], dialogue_line.extra_game_states, true)


# Changes fonts for just this line if it exists.
func change_fonts(font_id: String) -> void:
	var font_path = get_font_path(font_id)
	if ResourceLoader.exists(font_path):
		var font: Font = load(font_path)
		add_theme_font_override("normal_font", font)
		add_theme_font_size_override("normal_font_size", 32)
	else:
		remove_theme_font_override("normal_font")
		remove_theme_font_size_override("normal_font_size")


# Gets path to the font [code].ttf[/code] asset
# with the given filename [code]name[/code].
func get_font_path(font_id) -> String:
	if font_id.is_empty():
		return font_id
	else:
		return Utils.font_dir.path_join(font_id + ".ttf")
