class_name TextBox extends CanvasLayer
## Edited version of the example balloon from Dialogue addon v2.14.1,
## see [url]https://github.com/nathanhoad/godot_dialogue_manager/releases/tag/v2.14.1[/url].
## Updated to use a feature about tags, which was introduced somewhere
## around v2.29.

@onready var _balloon: ColorRect = %TextBackground
@onready var _character_label: RichTextLabel = %CharacterLabel
@onready var _dialogue_label := %DialogueLabel
@onready var _responses_menu: VBoxContainer = %Responses
@onready var _response_template: RichTextLabel = %ResponseTemplate
@onready var _profile_background := %ProfileBackground
@onready var _profile: TextureRect = %Profile
@onready var _indicator:  TextureRect = %Indicator

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false:
	set(value):
		is_waiting_for_input = value
		_indicator.set_visible(value)

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		is_waiting_for_input = false
		
		if not next_dialogue_line:
			queue_free()
			return
		
		# Remove any previous responses
		for child in _responses_menu.get_children():
			_responses_menu.remove_child(child)
			child.queue_free()
		
		dialogue_line = next_dialogue_line
		
		_character_label.visible = not dialogue_line.character.is_empty()
		_character_label.text = tr(dialogue_line.character, "dialogue")
		
		_dialogue_label.modulate.a = 0
		_dialogue_label.dialogue_line = dialogue_line
		
		# Show any responses we have
		_responses_menu.modulate.a = 0
		if dialogue_line.responses.size() > 0:
			for response in dialogue_line.responses:
				# Duplicate the template so we can grab the fonts, sizing, etc
				var item: RichTextLabel = _response_template.duplicate(0)
				item.name = "Response%d" % _responses_menu.get_child_count()
				if not response.is_allowed:
					item.name = String(item.name) + "Disallowed"
					item.modulate.a = 0.4
				item.text = response.text
				item.show()
				_responses_menu.add_child(item)
		
		# Toggle profile
		if not dialogue_line.character.is_empty():
			if dialogue_line.tags.is_empty():
				_profile.express("")
			else:
				_profile.express(dialogue_line.get_tag_value("expression"))
		else:
			_profile.set_texture(null)
			_profile_background.set_visible(false)
		
		# Show our balloon
		_balloon.show()
		will_hide_balloon = false
		
		_dialogue_label.modulate.a = 1
		if not dialogue_line.text.is_empty():
			_dialogue_label.type_out()
			await _dialogue_label.finished_typing
		
		# Wait for input
		if dialogue_line.responses.size() > 0:
			_responses_menu.modulate.a = 1
			configure_menu()
		elif is_instance_valid(dialogue_line.time):
			var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)
		else:
			is_waiting_for_input = true
			_balloon.focus_mode = Control.FOCUS_ALL
			_balloon.grab_focus()
	get:
		return dialogue_line


func _ready() -> void:
	_response_template.hide()
	_balloon.hide()
	
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)


func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	get_viewport().set_input_as_handled()


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	temporary_game_states = extra_game_states
	temporary_game_states.push_front(_profile)
	is_waiting_for_input = false
	resource = dialogue_resource

	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


### Helpers


## Set up keyboard movement and signals for the response menu
func configure_menu() -> void:
	_balloon.focus_mode = Control.FOCUS_NONE
	
	var items = get_responses()
	for i in items.size():
		var item: Control = items[i]
		
		item.focus_mode = Control.FOCUS_ALL
		
		item.focus_neighbor_left = item.get_path()
		item.focus_neighbor_right = item.get_path()
		
		if i == 0:
			item.focus_neighbor_top = item.get_path()
			item.focus_previous = item.get_path()
		else:
			item.focus_neighbor_top = items[i - 1].get_path()
			item.focus_previous = items[i - 1].get_path()
		
		if i == items.size() - 1:
			item.focus_neighbor_bottom = item.get_path()
			item.focus_next = item.get_path()
		else:
			item.focus_neighbor_bottom = items[i + 1].get_path()
			item.focus_next = items[i + 1].get_path()
		
		item.mouse_entered.connect(_on_response_mouse_entered.bind(item))
		item.gui_input.connect(_on_response_gui_input.bind(item))
	
	items[0].grab_focus()


## When external scripts reset the focus
func reset_focus():
	if dialogue_line.responses.size() > 0:
		var item = get_responses()[0]
		item.focus_mode = Control.FOCUS_ALL
		item.grab_focus()
	else:
		_balloon.focus_mode = Control.FOCUS_ALL
		_balloon.grab_focus()


## Get a list of enabled items
func get_responses() -> Array:
	var items: Array = []
	for child in _responses_menu.get_children():
		if "Disallowed" in child.name: continue
		items.append(child)
		
	return items


### Signals


func _on_mutated(_mutation: Dictionary) -> void:
	_profile_background.hide()
	is_waiting_for_input = false
	will_hide_balloon = true
	get_tree().create_timer(0.1).timeout.connect(func():
		if will_hide_balloon:
			will_hide_balloon = false
			_balloon.hide()
	)


func _on_response_mouse_entered(item: Control) -> void:
	if "Disallowed" in item.name: return
	
	item.grab_focus()


func _on_response_gui_input(event: InputEvent, item: Control) -> void:
	if "Disallowed" in item.name: return
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		next(dialogue_line.responses[item.get_index()].next_id)
	elif event.is_action_pressed("ui_accept") and item in get_responses():
		next(dialogue_line.responses[item.get_index()].next_id)


func _on_balloon_gui_input(event: InputEvent) -> void:
	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing	
	get_viewport().set_input_as_handled()
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		next(dialogue_line.next_id)
	elif event.is_action_pressed("ui_accept") and get_viewport().gui_get_focus_owner() == _balloon:
		next(dialogue_line.next_id)
