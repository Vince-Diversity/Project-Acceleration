# Introduction to reading the code

Each GDScript file is documented with the classes they instantiate into the gameor references to other classes that do the instantiation. For example, the [loader.gd](./loader/loader.gd) documentation references the [main_menu.gd](./loader/main_menu/main_menu.gd) and [game.gd](./game/game.gd) classes. Let's start from the `loader.gd` class.


## Loading and saving

The `loader.gd` is the main scene of this godot project. Some methods and properties are temporary during development. In particular, the `save_dir` property is a godot project folder, which starts with `res://`, storing a save file when the game is saved. When releasing the game, this property will change to a default user data folder, `user://`.

The save file is a godot resource called `SaveGame.gd`. This way, the save data can be viewed and changed in the godot editor when developing. It is labeled with the game version. Running a game on a save file with a different game version is probably not going to work.


## The Game class
