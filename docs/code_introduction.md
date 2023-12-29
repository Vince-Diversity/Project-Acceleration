# Introduction to reading the code

The code is documented in a way that, hopefully, makes it clear how different classes relate to each other. Classes that aren't self-explanatory, are documented with what other classes they instantiate. For example, the [loader.gd](../loader/loader.gd) documentation references the [main menu.gd](../loader/main_menu/main_menu.gd) and [game.gd](../game/game.gd) classes. Let's start from the `loader.gd` class.


## Loading and save files

The `loader.gd` manages the `Loader` scene, which is the main scene of this godot project. It starts the main menu, creates new game instances and loads save files.

Some methods and properties in `loader.gd` are temporary for development purposes. In particular, the `save_dir` property is a godot project folder, which starts with `res://`, where a save file is stored when the game is saved. (It's planned that this property will change to a default user data folder, `user://`, when making a game release.) Also, the save file is a custom godot resource configured in `save_game.gd`. This way, the save data can be viewed and changed as a resource in the godot editor when developing. The save file is labeled with the current game version. Running a game on a save file with a different game version is probably not going to work.


## The game class

When loading or starting a new game, a `Game` node instance is added to the scene tree. The `game.gd` class manages this running game.
