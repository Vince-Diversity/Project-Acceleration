extends Node
## Autoload with game progress checks for dialogues using [DialogueResource].

## When the player is showing the new student around,
## this is toggled on.
var is_mentoring := true

## Saves all current conditions to the given [code]sg[/code].
func make_save(sg: SaveGame):
	sg.data[sg.condition_key][sg.mentoring_condition_key] = is_mentoring


## Loads conditions from the given [code]sg[/code].
func load_save(sg: SaveGame):
	is_mentoring = sg.data[sg.condition_key][sg.mentoring_condition_key]


func new_game_init_condition(sg: SaveGame):
	sg.data[sg.condition_key][sg.mentoring_condition_key] = true
