class_name ItemSprite extends SpriteFrames
## Contains the sprite of an item and gives the outcomes of examining or using this item.
##
## The ID of this item is given by the filename of this resource, without the extension.


## Title of the dialogue that plays when the player examines this item,
## see [method DialogueResource.get_next_dialogue_line].
@export var browse_dialogue_node: String


## Title of the dialogue that plays when the player uses this item on an [Interactable] scene,
## see [method DialogueResource.get_next_dialogue_line].
@export var interaction_dialogue_node: String
