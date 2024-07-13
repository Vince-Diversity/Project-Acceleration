class_name ItemSprite extends SpriteFrames
## Contains the sprite of an item and gives the outcomes of examining or using this item.
##
## The ID of this item is given by the filename of this resource, without the extension.
## Only the titles of the [DialogueResource] instances are needed, the
## filenames of the paths to the resources are the same for every item.
## For browsing, the filename is given by [member BrowseState.browsing_cutscene_name].
## For interacting with the item, the filename is given by the [code]interaction_node[/code]
## member of every node that is interactable, see [Interactable].


## Title of the dialogue that plays when the player examines this item,
## see [method DialogueResource.get_next_dialogue_line].
@export var browse_dialogue_node: String


## Title of the dialogue that plays when the player uses this item on an [Interactable] scene,
## see [method DialogueResource.get_next_dialogue_line].
@export var interaction_dialogue_node: String


## Name of the [Character] callable that is called when selecting the item.
## The callable needs to take one argument that is the ID of the item sprite.
@export var select_animation: String
