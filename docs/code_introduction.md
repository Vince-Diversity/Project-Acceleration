# Introduction to reading the code

The code is documented in a way that, hopefully, makes it clear how different classes relate to each other. Classes that aren't self-explanatory, are documented with what other classes they instantiate. For example, the [loader.gd](../loader/loader.gd) documentation references the [main menu.gd](../loader/main_menu/main_menu.gd) and [game.gd](../game/game.gd) classes. Let's start from the `loader.gd` class. This introduction goes through the code briefly so it becomes easier to navigate in the code documentation later.


## Loading the game

The `loader.gd` manages the `Loader` scene, which is the main scene of this godot project. It starts the main menu, creates new game instances and loads save files.

Some methods and properties in `loader.gd` are temporary for development purposes. In particular, the `save_dir` property is a godot project folder, which starts with `res://`, where a save file is stored when the game is saved. (It's planned that this property will change to a default user data folder, `user://`, when making a game release.) Also, the save file is a custom godot resource configured in `save_game.gd`. This way, the save data can be viewed and changed as a resource in the godot editor when developing. The save file is labeled with the current game version. Running a game on a save file with a different game version is probably not going to work.


## Starting a game session

When loading or starting a new game session, a `Game` node instance is added to the scene tree and the `game.gd` class manages this game session. After loading any existing save data, this class then adds the game environment, which is a `Room` node, to the scene tree. The environment given by a `Room` node includes a `TileMap`, the player, NPCs and interactable things. Once the `Room` is loaded, the player can start playing.


## Using states to switch between different node behaviours

The `Game` node is the first example where states are used. A state is a class that adapts a node behaviour to the current context of the game. For example, when a player goes to an NPC and starts a dialogue, the game session state switches from an instance of the `roam_state.gd` class to the `cutscene_state.gd` class. In the former state, the player can move around and interact, while in the latter, the player is unable to move freely and instead controls how the dialogue evolves. Many other nodes have states too, such as things in the environment that have interactions with the player if they are in an interactable state.

## Making the environment interactable

To make NPCs and things able to respond to player interaction, a custom `Area2D` child is added to these scenes. Subclasses of `interactable_interface.gd` are used to create different interaction nodes. For example, an `NPC` node has a child interactable node called `Interactable` which is configured by the `npc_interactable.gd` class. An interactable `Thing` node in the environment has a different interactable node.

## Saving changes to the current game session

The contents of a `Room` instance is dynamic. Some player interactions may perform preserved changes to the environment. These changes are saved temporarily to `Game.cache`  when exiting the current `Room`, or to a save file when saving the game. In the latter case, this calls the `Game.save()` function, which in turn calls the `save()` function in the current game session state.

Only nodes that can change need to be treated with a save functionality. To distinguish these nodes, they are assigned the Godot node group `Preserved`. Whenever the player exits the current `Room` or saves the game, the current game state calls a `make_save(save_game: SaveGame)` function on each node in this node group, if the function exists there.

The player saves the game in the pause menu when pausing the game. Since pausing is possible at any point in the game, saving during cutscene states, or other temporary states, are treated differently. When saving during a cutscene state, the `save()` function of the `cutscene_state.gd` class is used, which calls a different function `make_preserved_save(save_game: SaveGame)` on each `Preserved` node, if the function exists. Also, in a `Preserved` node, there are reserved variables for copies of saved properties that update only after a cutscene has ended. These properties are used when saving during a cutscene by calling `exit_cutscene()` in the `Preserved` node, if that function exists. As a result, a save file made during a cutscene does not take into account any changes that were made during that cutscene.

This result is also ensured by the fact that `Cutscene` instances are child nodes of the current `Room` instance, so that the cutscene instance always ends before leaving a room instance. It is possible to make a cutscene that changes the current `Room` instance and continues. Then, loading a save file that was saved during such a cutscene will start the game session at the last `Room` instance that was entered, and save changes to any previous rooms.

A cutscene that changes to a new `Room` instance is actually two different `Cutscene` instances, where the second starts immediately once the new `Room` instance is entered. This is done in the `entrance_events.gd` class.

The entrance events class is also attached as a `Preserved` node. This is what enables the player to change the contents of a `Room` instance that is not the current room and therefore not in the scene tree. Hopefully, entrance events, alongside items which the player may obtain, gives the player a sense of game progression.
