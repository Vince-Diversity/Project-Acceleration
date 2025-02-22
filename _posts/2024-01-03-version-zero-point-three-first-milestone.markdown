---
layout: post
title: "First milestone of version 0.3"
date: 2024-01-03 12:00:00 +0100
categories: development
---

Version 0.3 started being worked on a year ago, on January 2023. The version before was text-based, and the current version implements all the gameplay and some simple graphics, so 0.3 is going to take much longer to make. The first milestone has been reached now: game developement has gotten far enough so it's time to focus on designing the game's content next.

The things that can be done in the game now are summarised here.
* An environment can be built using Godot 4 editor. The environment background can be mapped with a tileset and objects in the environment can be interacted with.
* Non-playable characters, NPCs, can also be added to an environment and be interacted with. NPCs can also follow the player around within the environment or to a different place.
* Players and NPCs can have dialogues or monologues. This feature uses a Godot addon called Dialogue Manager by Nathan Hoad and contributors, see <https://github.com/nathanhoad/godot_dialogue_manager>.
* Cutscenes can be created, either in a separate script or directly in the Dialogue Manager. The latter means that cutscenes in this game are integrated with this addon, so the same user interface can be used when making a cutscene as when writing the dialogue.
* The player can obtain, read about and use items on objects or NPCs in the environment.
* The player can change settings using the main menu or the pause menu. So far, there is only a setting to toggle background music.
* Finally, the game can be paused, then saved or quit, then loaded again. If NPCs or objects in an environment have changed in some way, or any other form of game progression has been made, that is saved too.

Most features should now be implemented now. Future features will be added to the existing code once the story gets to that point, such as items with new effects or that can be equipped on the player.
