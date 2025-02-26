# Developing notes

Just some notes of obscure problems encountered during development
* To disable an Area2D, setting its monitororable property to false does not work. The player still sees the Area2D, for example, when Thing instances have their state switched to static state. And it only happens for one frame. And it doesn't seem to matter how many idle frames are skipped either... What works is setting the CollisionShape2D of the Area2D to disabled.
