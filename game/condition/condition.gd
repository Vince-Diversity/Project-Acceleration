extends Node
## Autoload with game progress checks for dialogues using [DialogueResource].

## When the player is showing the new student around,
## this is toggled on.
var is_mentoring := true

## When the player has entered one of the following worlds for the first time,
## the world variable is enabled.
## Unfortunately need to update [method make_save] and [method load_save]
## manually everytime a new world is added.
var been_to_sacred_space := false
var been_to_sea_space := false

## Saves all current conditions to the given [code]sg[/code].
func make_save(sg: SaveGame):
	sg.data[sg.condition_key][sg.mentoring_condition_key] = is_mentoring
	sg.data[sg.condition_key][sg.sacred_space_condition_key] = been_to_sacred_space
	sg.data[sg.condition_key][sg.sea_space_condition_key] = been_to_sea_space


## Loads conditions from the given [code]sg[/code].
func load_save(sg: SaveGame):
	is_mentoring = sg.data[sg.condition_key][sg.mentoring_condition_key]
	been_to_sacred_space = sg.data[sg.condition_key][sg.sacred_space_condition_key]
	been_to_sea_space = sg.data[sg.condition_key][sg.sea_space_condition_key]


func new_game_init_condition(sg: SaveGame):
	sg.data[sg.condition_key][sg.mentoring_condition_key] = true
	sg.data[sg.condition_key][sg.sacred_space_condition_key] = false
	sg.data[sg.condition_key][sg.sea_space_condition_key] = false
